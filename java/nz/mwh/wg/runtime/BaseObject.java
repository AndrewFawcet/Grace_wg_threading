package nz.mwh.wg.runtime;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import nz.mwh.wg.Evaluator;

public class BaseObject implements GraceObject {
    // if you look up something it will look in here the lexicalParent, if it
    // doesn't find it it will then look in the parent. It is all one linked list of
    // scopes
    private GraceObject lexicalParent; // scope that surrounds this object
    private Map<String, GraceObject> fields = new HashMap<>();
    private Map<String, Function<Request, GraceObject>> methods = new HashMap<>();
    private int referenceCount = 0; // Reference count field
    private boolean isIsolated = false;
    private boolean isImmutable = false;

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
        this(lexicalParent, returns, bindSelf, false, false); // Pass false for isIsolated by default
    }

    // The old constructor for BaseObject, does not use isIsolated boolean or isImmutable boolean
    // public BaseObject(GraceObject lexicalParent, boolean returns, boolean
    // bindSelf) {
    // this.lexicalParent = lexicalParent;
    // this.returns = returns;
    // addMethod("==(1)", request -> {
    // GraceObject other = request.getParts().get(0).getArgs().get(0);
    // return new GraceBoolean(this == other);
    // });
    // addMethod("!=(1)", request -> {
    // GraceObject other = request.getParts().get(0).getArgs().get(0);
    // return new GraceBoolean(this != other);
    // });
    // if (bindSelf) {
    // addMethod("self(0)", request -> this);
    // }
    // }

    // New constructor that accepts isIsolated and IsImmutable as a parameter
    public BaseObject(GraceObject lexicalParent, boolean returns, boolean bindSelf, boolean isIsolated,
                      boolean isImmutable) {
        this.lexicalParent = lexicalParent;
        this.returns = returns;
        this.isIsolated = isIsolated; // Set the isolation capability
        this.isImmutable = isImmutable; // Set the immutability capability

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

    public boolean isIsolated() {
        return isIsolated;
    }

    public boolean isImmutable() {
        return this.isImmutable;
    }

    public void setIsolated(boolean isIsolated) {
        this.isIsolated = isIsolated;
    }

    public void setImmutable(boolean immutable) {
        isImmutable = immutable;
    }

    // New method to increment reference count
    public void incrementReferenceCount() {
        referenceCount++;

        System.out.println("Reference count incremented to " + referenceCount);
        System.out.println(" -& the isolated bool is " + isIsolated);
        System.out.println(" -& the immutable bool is " + isImmutable);

    }

    // New method to decrement reference count
    public void decrementReferenceCount() {
        referenceCount--;
        System.out.println("Reference count decremented to " + referenceCount);
    }

    // New method to get the reference count
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

    @Override
    public GraceObject request(Request request) {
        Function<Request, GraceObject> method = methods.get(request.getName());
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

    public void addFieldWriter(String name) {
        methods.put(name + ":=(1)", request -> {
            fields.put(name, request.getParts().get(0).getArgs().get(0));

            // incrementing the BaseObject being referenced.
            fields.put(name, request.getParts().get(0).getArgs().get(0));
            GraceObject valueBeingAssigned = request.getParts().get(0).getArgs().get(0); // Get the object being assigned
            if (valueBeingAssigned instanceof BaseObject) {
                System.out.println(name + " assigned to a baseObject ----------");
                BaseObject objectBeingAssigned = (BaseObject) valueBeingAssigned; // Safe cast after instanceof check


                objectBeingAssigned.incrementReferenceCount(); // Increment the reference count
                if (objectBeingAssigned.isIsolated()) {
                    if (objectBeingAssigned.getReferenceCount() > 1) {
                        throw new RuntimeException(
                                "Violation: Isolated object '" + name + "' cannot have more than one reference.");
                    }
                }

            }

            // this looks at the current object and as the fields are being changed checks if the object is:
            // -immutable 
            // -does it have one or more references (less than one indicates in construction)
            // This functions in conjunction with the downward propagation of immutable capabilities in the public GraceObject visit(GraceObject context, ObjectConstructor node) method
            if (isImmutable) {
                System.out.println("Has the object been created?");
                if (getReferenceCount() != 0) {
                    System.out.println("this is printing an errrrr-----------------------------------");
                    throw new RuntimeException(
                            "Violation: Immutable object '" + name + "' cannot mutate immutable object fields.");
                } else {
                    System.out.println("all ok, in construction as no references ");
                }
            }

            return done;
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


    public Map<String, GraceObject> getFields() {
        return fields;
    }
}
