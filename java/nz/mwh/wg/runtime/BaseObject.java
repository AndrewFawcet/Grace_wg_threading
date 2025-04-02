package nz.mwh.wg.runtime;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import nz.mwh.wg.Evaluator;
import nz.mwh.wg.runtime.enums.IsoCheckMode;
import nz.mwh.wg.runtime.enums.IsoMoveMode;
import nz.mwh.wg.runtime.enums.LocalCheckMode;

// represents an object in the runtime with properties like fields, methods, and scope (lexicalParent).
public class BaseObject implements GraceObject {
    // if you look up something it will look in here the lexicalParent, if it
    // doesn't find it it will then look in the parent. It is all one linked list of
    // scopes
    private GraceObject lexicalParent; // scope that surrounds this object
    private Map<String, GraceObject> fields = new HashMap<>();
    private Map<String, Function<Request, GraceObject>> methods = new HashMap<>();
    private int referenceCount = 0;
    // private boolean decrementedToZero = false;
    private boolean extraRefIncrement = false;
    private boolean isIsolated = false;
    private boolean isImmutable = false;
    private boolean isLocal = false;
    private Thread objectThread = null;
    private int hashNumber = 0;

    // storage for holding object and alias to this (iso) object
    // enables auto unlinking of previous location
    private String aliasName;
    private GraceObject holdingObject;
    private boolean isAccessAllowed = false; // Default: no direct access from isoWrapper

    // enums governing runtime checking behaviour of capabilities
    IsoCheckMode isoCheckMode = CapabilityToggles.getIsoCheckMode();
    IsoMoveMode isoMoveMode = CapabilityToggles.getIsoMoveMode();
    LocalCheckMode localCheckMode = CapabilityToggles.getLocalCheckMode();

    protected static GraceDone done = GraceDone.done;
    protected static GraceUninitialised uninitialised = GraceUninitialised.uninitialised;

    private boolean returns = false;

    public BaseObject(GraceObject lexicalParent) {
        this(lexicalParent, false);
    }

    public BaseObject(GraceObject lexicalParent, boolean returns) {
        this(lexicalParent, returns, false);
    }

    public BaseObject(GraceObject lexicalParent, boolean returns, boolean bindSelf) {
        this(lexicalParent, returns, bindSelf, false, false, false); // Pass false for islocal, isIsolated, isImmutable
                                                                     // and isThreaded by default
    }

    // New constructor that accepts isIsolated and IsImmutable as a parameter
    public BaseObject(GraceObject lexicalParent, boolean returns, boolean bindSelf, boolean isLocal, boolean isIsolated,
            boolean isImmutable) {
        this.lexicalParent = lexicalParent;
        this.returns = returns;
        this.isLocal = isLocal;
        this.isIsolated = isIsolated;
        this.isImmutable = isImmutable;
        // set objectThread to the current thread
        this.objectThread = Thread.currentThread();

        // Add basic methods
        addMethod("==(1)", request -> {
            GraceObject other = request.getParts().get(0).getArgs().get(0);
            return new GraceBoolean(this == other);
        });
        addMethod("!=(1)", request -> {
            GraceObject other = request.getParts().get(0).getArgs().get(0);
            return new GraceBoolean(this != other);
        });
        if (bindSelf) {
            addMethod("self(0)", request -> this);
        }
    }

    public boolean isLocal() {
        return isLocal;
    }

    public boolean isIsolated() {
        return isIsolated;
    }

    public boolean isImmutable() {
        return this.isImmutable;
    }

    public void setLocal(boolean isLocal) {
        this.isLocal = isLocal;
    }

    public void setIsolated(boolean isIsolated) {
        this.isIsolated = isIsolated;
    }

    public void setImmutable(boolean isImmutable) {
        this.isImmutable = isImmutable;
    }

    public void setObjectThread(Thread thread) {
        this.objectThread = thread;
    }

    public Thread getObjectThread() {
        return objectThread;
    }

    public int getReferenceCount() {
        return referenceCount;
    }

    public void incrementReferenceCount() {
        if (extraRefIncrement && referenceCount != 1) {
            System.out.println("oddly the extraRefIncrement is true and the ref count is " + referenceCount);
        }
        if (extraRefIncrement) {
            extraRefIncrement = false;
        } else {
            referenceCount++;
        }
    }

    public void decrementReferenceCount() {
        referenceCount--;
        if (referenceCount == 0) {
            for (GraceObject val : fields.values()) { 
                if (val instanceof BaseObject) {
                    ((BaseObject)val).decrementReferenceCount();
                }
            }
        }
    }

    public boolean getExtraRefIncrement() {
        return extraRefIncrement;
    }

    public void setExtraRefIncrement(boolean refIncrement) {
        extraRefIncrement = refIncrement;
    }
 
    public void setAliasName(String name) {
        aliasName = name;
    }

    public String getAliasName() {
        return aliasName;
    }

    public void setHoldingObject(GraceObject object) {
        holdingObject = object;
    }

    public GraceObject getHoldingObject() {
        return holdingObject;
    }

    public void setIsAccessAllowed(boolean access) {
        isAccessAllowed = access;
    }

    public String toString() {
        Request request = new Request(new Evaluator(),
                Collections.singletonList(new RequestPartR("asString", Collections.emptyList())));
        return request(request).toString();
    }

    public void addMethod(String name, Function<Request, GraceObject> method) {
        methods.put(name, method);
    }

    @Override
    public GraceObject request(Request request) {

        if (request.getParts().get(0).getName().equals("hash")) { // Added hash method
            return new GraceNumber(hashNumber);
        }
        
        Function<Request, GraceObject> method = methods.get(request.getName());
        
        // dereferencing check for local
        if (isLocal()) {
            validateThreadAccess();
        }
        // dereferencing check for iso
        if (isIsolated()) {
            validateIsoAccess();
        }
        
        // TODO where requests for method calls are made from
        if (method != null) {
            return method.apply(request);
        }
        if (fields.containsKey(request.getName())) {
            return fields.get(request.getName());
        }
        if (request.getParts().size() == 1 && request.getParts().get(0).getName().endsWith(":=(1)")) {
            RequestPartR part = request.getParts().get(0);
            fields.put(part.getName().substring(0, part.getName().length() - 5), part.getArgs().get(0));
            return done;
        }
        throw new RuntimeException("No such method or field " + request.getName() + " in " + this.getClass().getName());
    }

    public GraceObject findReceiver(String name) {

        if (methods.containsKey(name) || fields.containsKey(name)) {
            return this;
        }
        if (lexicalParent != null) {
            return lexicalParent.findReceiver(name);
        }
        throw new RuntimeException("No such method in scope: " + name);
    }

    // adding methods or fields to an object
    public void addField(String name) {

        fields.put(name, uninitialised);
        methods.put(name + "(0)", request -> {

            GraceObject val = fields.get(name);
            // junk?
            // if (val instanceof BaseObject) {
            //     // put in to increment reference count of def objects.
            //     // ((BaseObject) val).incrementReferenceCount();
            // }

            if (val == uninitialised) {
                throw new RuntimeException(
                        "Field " + name + " is not initialised; other fields are " + fields.keySet());
            }
            return val;
        });
    }

    // puts the writer method into the object or scope
    // return the old value/object instead of 'done'
    // decrement or unassign the returned value/object
    public void addFieldWriter(String name) {

        methods.put(name + ":=(1)", request -> {

            GraceObject objectBeingAssigned = request.getParts().get(0).getArgs().get(0);

            // Check if the assigned value is null and throw an exception.
            // (Will occur if a previous isolated reference has been deleted)
            if (objectBeingAssigned == null) {
                String errorMessage = String.format(
                        "Capability Violation: Attempt to assign null to field '%s'. This is not allowed and may indicate an erroneous object assignment or an alias transferring access to a isolated object.",
                        name);
                System.out.println(errorMessage);
                throw new RuntimeException(errorMessage);
            }

            // pulls the existing value out here, and returns it at the end.
            // TODO could put a token zero reference object here, which acts as a tombstone.
            GraceObject objectBeingRemoved = null;
            objectBeingRemoved = fields.remove(name);
            if (objectBeingRemoved instanceof BaseObject) {
                BaseObject baseObjectBeingRemoved = (BaseObject) objectBeingRemoved;
                baseObjectBeingRemoved.decrementReferenceCount();
            }

            fields.put(name, objectBeingAssigned);
            if (objectBeingAssigned instanceof BaseObject) {
                // System.out.println(name + " assigned to a baseObject ----------");
                BaseObject baseObjectBeingAssigned = (BaseObject) objectBeingAssigned;

                baseObjectBeingAssigned.incrementReferenceCount();
                // the is a system to allow the auto unlinking of previous aliases for iso
                // objects
                // it makes use of the aliasObject (graceObject) which is a link to the
                // baseObject
                // that holds the previous reference (aliasName) to the iso
                if (baseObjectBeingAssigned.isIsolated() && CapabilityToggles.isAutoUnlinkingIsoMoves()) {
                    unlinkPreviousAliasIfNeeded(baseObjectBeingAssigned, name);
                }
                // initial check if isolated (not dereferencing)
                // checking if isolated, and runtime exception if too many references
                if (CapabilityToggles.isAssignmentIsoCheckEnabled()) {
                    if (baseObjectBeingAssigned.isIsolated()) {
                        if (baseObjectBeingAssigned.getReferenceCount() > 1) {
                            throw new RuntimeException(
                                    "Capability Violation: Isolated object '" + name
                                            + "' cannot have more than one reference.");
                        }
                    }
                }
                // runtime exception if multiple capabilities
                if (baseObjectBeingAssigned.isIsolated() && baseObjectBeingAssigned.isImmutable()) {
                    throw new RuntimeException(
                            "Capability Violation: Object '" + name
                                    + "' cannot have both capabilities 'isolated' and 'immutable' assigned.");
                }
            }

            if (isImmutable) {
                if (getReferenceCount() != 0) { // ref count of 0 indicates a fresh object
                    throw new RuntimeException(
                            "Capability Violation: Immutable object, cannot mutate 'immutable' object field '" + name
                                    + "'.");
                }
            }

            // should be value that has been removed, with a decremented reference count.
            // (to zero for an iso)
            // this then should be stored somewhere else...
            if (objectBeingRemoved instanceof BaseObject) {
                System.out.println(
                        "ref count of " + name + " is: " + ((BaseObject) objectBeingRemoved).getReferenceCount());
            }
            return objectBeingRemoved;
        });
    }

    // TODO fix the iterator, this is for def objects
    public void setField(String name, GraceObject value) {
        if (value instanceof BaseObject) {
            BaseObject valueBaseObject = (BaseObject) value;
            // System.out.println("here____" + valueBaseObject.getAliasName());

            valueBaseObject.incrementReferenceCount(); // incrementing up here for def objects.
            // TODO add in special case for self here!!!!
        }
        fields.put(name, value);
    }

    // // TODO fix the iterator, this is for def objects
    // private void incrementFieldsReferenceCount( Map<String, GraceObject> objectFields) {
    //     // recursively iterate through the base object fields Map, incrementing the reference
    //     // counts.
    //     System.out.println("here____");
    //     for (GraceObject field : objectFields.values()) {
    //         System.out.println(" + here____" );
    //         if (field instanceof BaseObject) {
    //             BaseObject fieldBaseObject = (BaseObject) field;
    //             System.out.println(" now here____");
    //             fieldBaseObject.incrementReferenceCount();  // increment this field
    //             incrementFieldsReferenceCount(fieldBaseObject.fields);  // carry on recusivly incrementing
    //         }
    //     }
    // }

    public GraceObject findReturnContext() {

        if (returns) {
            return this;
        }
        if (lexicalParent != null) {
            return ((BaseObject) lexicalParent).findReturnContext();
        }
        throw new RuntimeException("No return context found");
    }

    private void validateThreadAccess() {
        // only called for local objects
        if (CapabilityToggles.isDereferencingLocalCheckEnabled()) {
            if (objectThread != Thread.currentThread()) {
                throw new RuntimeException("Capability Violation: Local object accessed from a different thread.");
            }
        }
    }

    private void validateIsoAccess() {
        // only called for iso objects
        if (CapabilityToggles.isDereferencingIsoCheckEnabled()) {
            if (referenceCount > 1) {
                // TODO include name
                throw new RuntimeException(
                        "Capability Violation: Isolated object cannot be accessed while having more than one reference.");
            }
        }
    }

    private void unlinkPreviousAliasIfNeeded(BaseObject baseObjectBeingAssigned, String name) {
        if (baseObjectBeingAssigned.getReferenceCount() > 1) {
            GraceObject oldObjectReferencingIso = baseObjectBeingAssigned.getHoldingObject();
            if (oldObjectReferencingIso instanceof BaseObject) {
                BaseObject oldBaseObjectReferencingIso = (BaseObject) oldObjectReferencingIso;
                String oldRef = baseObjectBeingAssigned.getAliasName();
                oldBaseObjectReferencingIso.fields.remove(oldRef);
                baseObjectBeingAssigned.decrementReferenceCount();
            }
        }
        baseObjectBeingAssigned.setAliasName(name); // base object now holds the name it is under inside itself.
        baseObjectBeingAssigned.setHoldingObject(this); // base object now holds the object it is under inside itself.
    }

    // Validate method access
    // this is not used, it was intended as a security feature to make sure all
    // calls were directed through the isoWrapper
    // I think it is impossible to call the object directly, hence this is not used.
    private void validateIfUsingIsoWrapper() {
        if (CapabilityToggles.isUsingIsoWrapper() && isIsolated) {
            if (!isAccessAllowed) { // If flag is false, access is denied
                throw new RuntimeException(
                        "Capability Violation: Wrapped Isolated object cannot be accessed directly, must be accessed via wrapper.");
            }
        }
    }
}