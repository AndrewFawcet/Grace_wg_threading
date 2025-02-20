package nz.mwh.wg.runtime;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import nz.mwh.wg.Evaluator;

// represents an object in the runtime with properties like fields, methods, and scope (lexicalParent).
public class BaseObject implements GraceObject {
    // if you look up something it will look in here the lexicalParent, if it
    // doesn't find it it will then look in the parent. It is all one linked list of
    // scopes
    private GraceObject lexicalParent; // scope that surrounds this object
    private Map<String, GraceObject> fields = new HashMap<>();
    private Map<String, Function<Request, GraceObject>> methods = new HashMap<>();
    private int referenceCount = 0;
    private boolean isIsolated = false;
    private boolean isImmutable = false;
    private boolean isLocal = false;
    private Thread objectThread = null;
    private int hashNumber = 0;

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

        // If the object is marked as local, set objectThread to the current thread
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

    public Thread getObjectThread() {
        return objectThread;
    }

    // New method to increment reference count
    public void incrementReferenceCount() {
        referenceCount++;
    }

    // New method to decrement reference count
    public void decrementReferenceCount() {
        referenceCount--;
    }

    public int getReferenceCount() {
        return referenceCount;
    }

    public String toString() {
        Request request = new Request(new Evaluator(),
                Collections.singletonList(new RequestPartR("asString", Collections.emptyList())));
        return request(request).toString();
    }

    public void addMethod(String name, Function<Request, GraceObject> method) {
        methods.put(name, method);
    }

    // TODO 
    @Override
    public GraceObject request(Request request) {

        if (request.getParts().get(0).getName().equals("hash")) { // Added hash method
            return new GraceNumber(hashNumber);
        }
        
        Function<Request, GraceObject> method = methods.get(request.getName());
        if (isLocal()) {
            validateThreadAccess();
        }

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

                // checking if isolated, and runtime exception if too many references
                if (baseObjectBeingAssigned.isIsolated()) {
                    if (baseObjectBeingAssigned.getReferenceCount() > 1) {
                        throw new RuntimeException(
                                "Capability Violation: Isolated object '" + name
                                        + "' cannot have more than one reference.");
                    }
                }
                // checking if isolated and imutable, and runtime exception if multiple
                // capabilities
                if (baseObjectBeingAssigned.isIsolated() && baseObjectBeingAssigned.isImmutable()) {
                    throw new RuntimeException(
                            "Capability Violation: Object '" + name
                                    + "' cannot have both capabilities 'isolated' and 'immutable' assigned.");
                }
            }

            // this looks at the current object and as the fields are being changed checks
            // if the object is:
            // -immutable
            // -does it have one or more references (less than one indicates in
            // construction)
            // This functions in conjunction with the downward propagation of immutable
            // capabilities in the public GraceObject visit(GraceObject context,
            // ObjectConstructor node) method
            if (isImmutable) {
                if (getReferenceCount() != 0) {
                    throw new RuntimeException(
                            "Capability Violation: Immutable object, cannot mutate 'immutable' object field '" + name
                                    + "'.");
                } else {
                    // System.out.println("all ok, in construction as no references ");
                }
            }

            // should be value that has been removed, with a decremented reference count.
            // (to zero for an iso)
            // this then should be stored somewhere else...
            return objectBeingRemoved;
        });
    }

    public void setField(String name, GraceObject value) {
        fields.put(name, value);
    }

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
        // checking if it is looking at a local object;
        if (isLocal) {
            if (objectThread != Thread.currentThread()) {
                throw new RuntimeException("Capability Violation: Local object accessed from a different thread.");
            } else {
                // System.out.println("all ok with the access on this local object +++++");
            }
        }
    }
}