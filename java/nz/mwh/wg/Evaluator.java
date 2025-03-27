package nz.mwh.wg;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import nz.mwh.wg.ast.*;

import nz.mwh.wg.runtime.*;

/**
 * the Evaluator executes and manages the abstract syntax tree of grace
 * programs, a kind of runtime interpreter.
 * It handles various expression types, definitions, method declarations,
 * objects constructions, and other constructs, by visiting and processing the
 * AST nodes.
 * It facilitates the interpretation and execution of Grace programs by
 * providing a strutured way to traverse and process the AST.
 * It does this by implementing the visitor pattern for different node types in
 * the AST.
 */
public class Evaluator extends ASTConstructors implements Visitor<GraceObject> {

    private static GraceDone done = GraceDone.done;

    private Map<String, GraceObject> modules = new HashMap<>();

    // Purpose: Constructs and initializes a new object context by processing its
    // body elements, including definitions, variable declarations, imports, and
    // methods.
    // Details: Creates a BaseObject and iterates over the AST body nodes to add
    // fields and methods to the object.
    @Override
    public GraceObject visit(GraceObject context, ObjectConstructor node) {

        baseObejctCapabilityChecks(context, node);
        
        boolean isNewObjectLocal = node.isLocal();
        boolean isNewObjectIsolated = node.isIsolated();
        boolean isNewObjectImmutable = node.isImmutable();

        // This creates the new BaseObject, the context is the lexical parent
        BaseObject object = new BaseObject(context, false, true, isNewObjectLocal, isNewObjectIsolated,
                isNewObjectImmutable);

        // If isoWrapper should be applied, wrap the object
        GraceObject finalObject = object;

        if (CapabilityToggles.isUsingIsoWrapper() && object.isIsolated()) {
            // if (object.isUsingIsoWrapper() && object.isIsolated()) {
            finalObject = new IsoWrapper(object); // Wrap the object if iso and isoWrapper toggle is on
        }

        List<ASTNode> body = node.getBody();
        for (ASTNode part : body) {
            if (part instanceof DefDecl) {
                DefDecl def = (DefDecl) part;
                object.addField(def.getName()); // Always add to the base object (no difference for isoWrapper)
            } else if (part instanceof VarDecl) { // TODO could make a variable Consume and Declare
                VarDecl var = (VarDecl) part;
                if (CapabilityToggles.isUsingIsoWrapper() && object.isIsolated()) {
                    IsoWrapper finalObjectWrapper = (IsoWrapper) finalObject;
                    finalObjectWrapper.addField(var.getName());
                    finalObjectWrapper.addFieldWriter(var.getName()); // for new object field
                } else {
                    BaseObject finalObjectBase = (BaseObject) finalObject;
                    finalObjectBase.addField(var.getName());
                    finalObjectBase.addFieldWriter(var.getName()); // for new object field
                }
            } else if (part instanceof ImportStmt) {
                ImportStmt imp = (ImportStmt) part;
                object.addField(imp.getName());
            } else if (part instanceof MethodDecl) {
                visit(object, part);
            }
        }

        for (ASTNode part : body) {
            // System.out.println("++++");
            if (CapabilityToggles.isUsingIsoWrapper() && object.isIsolated()) {
                IsoWrapper finalObjectWrapper = (IsoWrapper) finalObject;
                visit(finalObjectWrapper, part);
            } else {
                BaseObject finalObjectBase = (BaseObject) finalObject;
                visit(finalObjectBase, part);
            }
            // visit(object, part);
            // System.out.println("----");
        }

        return finalObject;
    }

    private void baseObejctCapabilityChecks(GraceObject context, ObjectConstructor node) {
        // checks if baseObject that is immutable or isolated is making another nested
        // object, if so it will pass on the capability (propagates downward)
        // also checks if baseObject that is immutable and if the newObject is isolated,
        // throws runtime error if so.
        boolean isNewObjectLocal = node.isLocal();
        boolean isNewObjectIsolated = node.isIsolated();
        boolean isNewObjectImmutable = node.isImmutable();
        if (context instanceof BaseObject) {
            BaseObject contextBaseObject = (BaseObject) context;
            if (contextBaseObject.isLocal()) {
                // System.out.println("in the visit -----------");
            }
            if (contextBaseObject.isIsolated()) {
                if (isNewObjectLocal) {
                    throw new RuntimeException(
                            "Capability Violation: An 'isolated' object cannot reference an 'local' object.");
                }
                if (isNewObjectImmutable) {
                    isNewObjectIsolated = false; // referenced object is immutable not isolated
                } else {
                    if (!isNewObjectIsolated) {
                        System.out.println("the BaseObject attached to an isolated should also be isolated.");
                        throw new RuntimeException(
                                "Capability Violation: An 'isolated' object cannot reference a (base) object without the 'isolated' or 'immutable' capability.");
                    }
                }
            }
            if (contextBaseObject.isImmutable()) {
                if (isNewObjectIsolated) {
                    throw new RuntimeException(
                            "Capability Violation: An 'immutable' object cannot reference an 'isolated' object.");
                }
                if (isNewObjectLocal) {
                    throw new RuntimeException(
                            "Capability Violation: An 'immutable' object cannot reference an 'local' object.");
                }
                if (!isNewObjectImmutable) {
                    throw new RuntimeException(
                            "Capability Violation: An 'immutable' object cannot reference a (base) object without the 'immutable' capability.");
                }
            }
        }
    }

    // Purpose: Processes a lexical request, which is a method call or message send
    // within a local context.
    // Details: Collects arguments for the request and finds the receiver object to
    // handle the request.
    @Override
    public GraceObject visit(GraceObject context, LexicalRequest node) {

        List<RequestPartR> parts = new ArrayList<>();
        for (Part part : node.getParts()) {
            // Calls visit(context, x) recursively to process each argument, in case they
            // are themselves method calls.
            // creates a list of RequestPartR objects to store processed method parts.
            List<GraceObject> args = part.getArgs().stream().map(x -> visit(context, x)).collect(Collectors.toList());

            parts.add(new RequestPartR(part.getName(), args));
        }

        Request request = new Request(this, parts); // a method call or message send within a local scope
        GraceObject receiver = context.findReceiver(request.getName());

        return receiver.request(request);
    }

    // Purpose: Converts a number node into a GraceNumber object.
    // Details: Simply wraps the numeric value in a GraceNumber
    @Override
    public GraceObject visit(GraceObject context, NumberNode node) {

        return new GraceNumber(node.getValue());
    }

    // Purpose: Converts a string node into a GraceString object.
    // Details: Simply wraps the string value in a GraceString
    @Override
    public GraceObject visit(GraceObject context, StringNode node) {

        return new GraceString(node.getValue());
    }

    // Purpose: Handles interpolated strings, concatenating static text with
    // evaluated expressions.
    // Details: Processes each part of the interpolated string and concatenates the
    // results.
    @Override
    public GraceObject visit(GraceObject context, InterpString node) {

        String value = node.getValue();
        ASTNode expression = node.getExpression();
        ASTNode next = node.getNext();
        StringBuilder sb = new StringBuilder();
        sb.append(value);
        sb.append(expression.accept(context, this).toString());
        while (next instanceof InterpString) {
            InterpString nextString = (InterpString) next;
            sb.append(nextString.getValue());
            expression = nextString.getExpression();
            next = nextString.getNext();
            sb.append(expression.accept(context, this).toString());
        }
        // next must now be a StringNode
        if (!(next instanceof StringNode)) {
            throw new UnsupportedOperationException("Invalid InterpString node");
        }
        StringNode sn = (StringNode) next;
        sb.append(sn.getValue());

        return new GraceString(value + expression.accept(context, this) + next.accept(context, this));
    }

    // Purpose: Defines a field in the current object context.
    // Details: Evaluates the value and assigns it to the field in the BaseObject.
    //
    // TODO throw in a check here is the object is iso.
    @Override
    public GraceObject visit(GraceObject context, DefDecl node) {

        if (context instanceof BaseObject) {
            System.out.println("blah");
            BaseObject object = (BaseObject) context;
            // object.incrementReferenceCount();
            GraceObject value = node.getValue().accept(context, this);
            object.setField(node.getName(), value);
            return done;
        }
        throw new UnsupportedOperationException("def can only appear inside in-code context");
    }

    // Purpose: Declares a variable and optionally initializes it.
    // Details: Creates a setter method if a value is provided.
    @Override
    public GraceObject visit(GraceObject context, VarDecl node) {
        // the base declaration is the context itself
        // checks if the variable is initialized
        if (node.getValue() != null) {

            // is initialized, so it creates a setter method to assign the value.
            // A LexicalRequest is generated to record or process this declaration and its
            // value.
            new LexicalRequest(new Cons<Part>(

                    new Part(node.getName() + ":=", new Cons<ASTNode>(node.getValue(),
                            Cons.<ASTNode>nil())),
                    Cons.<Part>nil())).accept(context, this);
        }
        return done;
    }

    // Purpose: Declares a method and adds it to the current object context.
    // Details: Processes the method’s parts and body, setting up parameter handling
    // and method execution.
    @Override
    public GraceObject visit(GraceObject context, MethodDecl node) {

        List<? extends Part> parts = node.getParts();
        String name = parts.stream().map(x -> x.getName() + "(" + x.getParameters().size() + ")")
                .collect(Collectors.joining(""));

        // added for IsoWrapper
        if (context instanceof IsoWrapper) {
            GraceObject wrappedObject = insertWrapper((IsoWrapper) context, node, parts);
            return wrappedObject;
        }
        if (context instanceof BaseObject) {
            BaseObject object = (BaseObject) context;
            List<? extends ASTNode> body = node.getBody(); // this body holds all the method statements
            object.addMethod(name, request -> {

                BaseObject methodContext = new BaseObject(context, true);
                methodContext.incrementReferenceCount(); // method now operates as a base object with ref count 1.
                List<RequestPartR> requestParts = request.getParts();

                RequestPartR firstRequestPart = requestParts.get(0); // for testing
                if (firstRequestPart.getName().equals("referenceCounter")) {
                    System.out.println(" --- here with the new request Part!");
                }

                for (int j = 0; j < requestParts.size(); j++) {
                    Part part = parts.get(j);
                    RequestPartR rpart = requestParts.get(j);
                    List<? extends ASTNode> parameters = part.getParameters();
                    for (int i = 0; i < parameters.size(); i++) {
                        IdentifierDeclaration parameter = (IdentifierDeclaration) parameters.get(i);
                        methodContext.addField(parameter.getName());
                        methodContext.setField(parameter.getName(), rpart.getArgs().get(i));
                    }
                }
                for (ASTNode part : body) {
                    if (part instanceof DefDecl) {
                        DefDecl def = (DefDecl) part;
                        methodContext.addField(def.getName());
                    } else if (part instanceof VarDecl) {
                        VarDecl var = (VarDecl) part;
                        methodContext.addField(var.getName());
                        // parameter handling, each method part will contain parts of this.
                        // how to manage the reference counting in this case?
                        methodContext.addFieldWriter(var.getName()); // do something for iso methods???
                        // GraceObject oldObject = methodContext.addFieldWriter(var.getName());
                        // do for iso methods???
                    }
                }
                try {
                    GraceObject last = null;
                    for (ASTNode part : body) {
                        last = visit(methodContext, part); // this is where the method gets actioned
                    }

                    methodContext.decrementReferenceCount(); // TODO decrimenter used now
                    if (methodContext.getReferenceCount() == 0) { // test for zero to indicate a local scope method call
                        System.out
                                .println(" going to decrement all the things aliased by this method as it is now zero");
                        for (ASTNode part : body) {
                            if (part instanceof DefDecl) {
                                DefDecl def = (DefDecl) part;
                                methodContext.decrementFieldReferenceCount(def.getName());

                            } else if (part instanceof VarDecl) {
                                VarDecl var = (VarDecl) part;
                                methodContext.decrementFieldReferenceCount(var.getName());
                            }
                        }
                    }

                    return last;
                } catch (ReturnException re) {
                    if (re.context == methodContext) {
                        GraceObject returningObject = re.getValue();
                        GraceObject otherStuffInObject = re.context;
                        if (otherStuffInObject instanceof BaseObject) {
                            BaseObject otherStuffInObjectBaseObject = (BaseObject) otherStuffInObject;
                            otherStuffInObjectBaseObject.decrementReferenceCount();
                            System.out.println("ref  " + otherStuffInObjectBaseObject.getReferenceCount());
                            if (otherStuffInObjectBaseObject.getReferenceCount() == 0) { // test for zero to indicate a
                                                                                         // local scope method call
                                System.out.println(
                                        " going to decrement all the things aliased by this method as it is now zero for the reurned object");
                                for (ASTNode part : body) {
                                    if (part instanceof DefDecl) {
                                        DefDecl def = (DefDecl) part;
                                        otherStuffInObjectBaseObject.decrementFieldReferenceCount(def.getName());

                                    } else if (part instanceof VarDecl) {
                                        VarDecl var = (VarDecl) part;
                                        otherStuffInObjectBaseObject.decrementFieldReferenceCount(var.getName());
                                    }
                                }
                            }
                        }
                        return returningObject; // TODO this is there the decrimenter also needs to be operating for
                                                // returning aliases or objects
                        // the getValue() gets the returned object or number or whatever
                    } else {
                        throw re;
                    }
                }
            });
            return done;
        }
        throw new UnsupportedOperationException(
                "method can only be defined in object context of either BaseObject or IsoWrapper");
    }

    // This is mostly a repeat of a base Object, but using a IsoWrapper.
    // All methods and fields go through the IsoWrapper object, to the actual
    // BaseObject object.
    private GraceObject insertWrapper(IsoWrapper wrapperContext, MethodDecl node, List<? extends Part> parts) {
        List<? extends ASTNode> body = node.getBody();

        wrapperContext.addMethod(parts.stream().map(x -> x.getName() + "(" + x.getParameters().size() + ")")
                .collect(Collectors.joining("")), request -> {

                    // Create a method context that wraps the current IsoWrapper context
                    BaseObject methodContextBase = new BaseObject(wrapperContext.getWrappedObject(), true);

                    List<RequestPartR> requestParts = request.getParts();
                    for (int j = 0; j < requestParts.size(); j++) {
                        Part part = parts.get(j);
                        RequestPartR rpart = requestParts.get(j);
                        List<? extends ASTNode> parameters = part.getParameters();

                        for (int i = 0; i < parameters.size(); i++) {
                            IdentifierDeclaration parameter = (IdentifierDeclaration) parameters.get(i);
                            methodContextBase.addField(parameter.getName());
                            methodContextBase.setField(parameter.getName(), rpart.getArgs().get(i));
                        }
                    }

                    // Handle the body of the method by visiting each part
                    for (ASTNode part : body) {
                        if (part instanceof DefDecl) {
                            DefDecl def = (DefDecl) part;
                            methodContextBase.addField(def.getName());
                        } else if (part instanceof VarDecl) {
                            VarDecl var = (VarDecl) part;
                            methodContextBase.addField(var.getName());
                            methodContextBase.addFieldWriter(var.getName()); // Handle writing to the field
                        }
                    }

                    try {
                        GraceObject last = null;
                        for (ASTNode part : body) {
                            last = visit(methodContextBase, part); // Visit the body parts using the method context
                        }
                        return last;
                    } catch (ReturnException re) {
                        if (re.context == methodContextBase) {
                            return re.getValue();
                        } else {
                            throw re;
                        }
                    }
                });

        return done;
    }

    // Purpose: Processes an explicit request (method call) with a specified
    // receiver.
    // Details: Collects arguments, builds a Request, and sends it to the receiver.
    @Override
    public GraceObject visit(GraceObject context, ExplicitRequest node) {

        List<RequestPartR> parts = new ArrayList<>();
        for (Part part : node.getParts()) {
            List<GraceObject> args = part.getArgs().stream().map(x -> visit(context, x)).collect(Collectors.toList());
            parts.add(new RequestPartR(part.getName(), args));
        }
        Request request = new Request(this, parts, node.location);
        GraceObject receiver = node.getReceiver().accept(context, this);
        return receiver.request(request);

    }

    // Purpose: Handles assignments to fields or variables.
    // Details: Identifies the target and updates its value through a corresponding
    // request.
    // TODO done something here for returning stuff allowing destructive reads
    @Override
    public GraceObject visit(GraceObject context, Assign node) {

        if (node.getTarget() instanceof LexicalRequest) {
            LexicalRequest target = (LexicalRequest) node.getTarget();
            String name = target.getParts().get(0).getName();
            List<RequestPartR> parts = new ArrayList<>();
            parts.add(new RequestPartR(name + ":=", Collections.singletonList(node.getValue().accept(context, this))));
            Request request = new Request(this, parts);
            GraceObject receiver = context.findReceiver(request.getName());
            if (context instanceof BaseObject) {
                // System.out.println(" Lexical Request, name " + name);
            }
            // receiver.request(request);

            GraceObject previous = receiver.request(request);
            // changed to send the previous object through for destructive reads of
            // variables and objects
            return previous;
            // return done;
        } else if (node.getTarget() instanceof ExplicitRequest) {
            ExplicitRequest target = (ExplicitRequest) node.getTarget();
            String name = target.getParts().get(0).getName();
            System.out.println(" name " + name);
            List<RequestPartR> parts = new ArrayList<>();
            parts.add(new RequestPartR(name + ":=", Collections.singletonList(node.getValue().accept(context, this))));
            Request request = new Request(this, parts);
            GraceObject receiver = target.getReceiver().accept(context, this);

            // receiver.request(request);
            GraceObject previous = receiver.request(request);
            // changed to send the previous object through for destructive reads of fields
            return previous;
            // return done;
        }
        throw new UnsupportedOperationException(
                "Invalid assignment to " + node.getTarget().getClass().getName() + " node");
    }

    // Purpose: Creates a block, which is a function-like construct with parameters
    // and a body.
    // Details: Wraps the block parameters and body in a GraceBlock object.
    @Override
    public GraceObject visit(GraceObject context, Block blockNode) {

        List<ASTNode> parameters = blockNode.getParameters();
        List<ASTNode> body = blockNode.getBody();

        return new GraceBlock(context, parameters, body);
    }

    // Purpose: Handles return statements within method bodies.
    // Details: Evaluates the return value and throws a ReturnException to exit the
    // method.
    @Override
    public GraceObject visit(GraceObject context, ReturnStmt node) {

        GraceObject value = visit(context, node.getValue());
        if (context instanceof BaseObject) {
            GraceObject returnContext = ((BaseObject) context).findReturnContext();
            throw new ReturnException(returnContext, value);
        }
        throw new UnsupportedOperationException("return can only appear inside method body");
    }

    // Purpose: Ignores comments during evaluation.
    // Details: Simply returns a GraceDone object
    @Override
    public GraceObject visit(GraceObject context, Comment node) {

        return done;
    }

    // Purpose: Imports a module and adds it to the current object context.
    // Details: Reads the module file, parses it, evaluates the AST, and binds it to
    // the current object.
    @Override
    public GraceObject visit(GraceObject context, ImportStmt node) {

        if (context instanceof BaseObject) {
            BaseObject object = (BaseObject) context;

            if (modules.containsKey(node.getSource())) {
                object.setField(node.getName(), modules.get(node.getSource()));
                return done;
            }

            String filename = node.getSource() + ".grace";
            try {
                String source = Files.readString(Path.of(filename));
                ObjectConstructor ast = (ObjectConstructor) Parser.parse(source);
                GraceObject mod = this.evaluateModule(ast);
                modules.put(node.getSource(), mod);
                object.setField(node.getName(), mod);
                return done;
            } catch (IOException e) {
                throw new RuntimeException("Error reading file: " + filename);
            }
        }

        throw new UnsupportedOperationException("imports can only appear inside in-code context");
    }

    // Purpose: Creates a base object with built-in methods for the standard
    // library.
    // Details: Adds methods for printing, conditional logic, and file handling.
    static BaseObject basePrelude() {

        BaseObject lexicalParent = new BaseObject(null);
        lexicalParent.addMethod("refCount(1)", request -> {
            BaseObject obj = (BaseObject) request.getParts().get(0).getArgs().get(0);
            return new GraceNumber(obj.getReferenceCount());
        });
        lexicalParent.addMethod("setLoc(1)", request -> {
            BaseObject obj = (BaseObject) request.getParts().get(0).getArgs().get(0);
            CapabilityAdjuster.changeCapability(obj, true, false, false);
            return done;
        });
        lexicalParent.addMethod("setIso(1)", request -> {
            BaseObject obj = (BaseObject) request.getParts().get(0).getArgs().get(0);
            CapabilityAdjuster.changeCapability(obj, false, true, false);
            return done;
        });
        lexicalParent.addMethod("setImm(1)", request -> {
            BaseObject obj = (BaseObject) request.getParts().get(0).getArgs().get(0);
            CapabilityAdjuster.changeCapability(obj, false, false, true);
            return done;
        });
        lexicalParent.addMethod("setUnsafe(1)", request -> {
            BaseObject obj = (BaseObject) request.getParts().get(0).getArgs().get(0);
            CapabilityAdjuster.changeCapability(obj, false, false, false);
            return done;
        });
        lexicalParent.addMethod("array(1)", request -> new GraceArray(1));
        lexicalParent.addMethod("hashprint(1)", request -> {
            Object arg = request.getParts().get(0).getArgs().get(0);
            String str = arg.toString(); // Convert to string
            int hash = str.hashCode(); // Compute hash code
            System.out.println("Hash of \"" + str + "\": " + hash);
            return new GraceNumber(hash); // Return the hash as a GraceNumber
        });
        lexicalParent.addMethod("spawn(1)", request -> {
            GraceBlock block = (GraceBlock) request.getParts().get(0).getArgs().get(0);
            DuplexChannel dchan1 = new DuplexChannel(1);
            DuplexChannel dchan2 = new DuplexChannel(1);
            GraceChannel chan1 = new GraceChannel(dchan1.createPort1(), dchan2.createPort1());
            GraceChannel chan2 = new GraceChannel(dchan2.createPort2(), dchan1.createPort2());
            new Thread(() -> {
                try {
                    block.request(new Request(new Evaluator(),
                            Collections.singletonList(new RequestPartR("apply", Collections.singletonList(chan1)))));
                } catch (ReturnException e) {
                    System.out.println("Thread returned: " + e.getValue());
                }
            }).start();
            return chan2;
        });
        lexicalParent.addMethod("print(1)", request -> {
            System.out.println(request.getParts().get(0).getArgs().get(0).toString());
            return done;
        });
        lexicalParent.addMethod("true(0)", request -> new GraceBoolean(true));
        lexicalParent.addMethod("false(0)", request -> new GraceBoolean(false));
        lexicalParent.addMethod("if(1)then(1)else(1)", request -> {
            GraceBoolean condition = (GraceBoolean) request.getParts().get(0).getArgs().get(0);
            List<RequestPartR> parts = Collections.singletonList(new RequestPartR("apply", Collections.emptyList()));
            Request req = new Request(request.getVisitor(), parts);
            if (condition.getValue()) {
                return request.getParts().get(1).getArgs().get(0).request(req);
            } else {
                return request.getParts().get(2).getArgs().get(0).request(req);
            }
        });
        lexicalParent.addMethod("if(1)then(1)", request -> {
            GraceBoolean condition = (GraceBoolean) request.getParts().get(0).getArgs().get(0);
            List<RequestPartR> parts = Collections.singletonList(new RequestPartR("apply", Collections.emptyList()));
            Request req = new Request(request.getVisitor(), parts);
            if (condition.getValue()) {
                return request.getParts().get(1).getArgs().get(0).request(req);
            }
            return done;
        });
        lexicalParent.addMethod("if(1)then(1)elseif(1)then(1)", request -> {
            GraceBoolean condition = (GraceBoolean) request.getParts().get(0).getArgs().get(0);
            List<RequestPartR> parts = Collections.singletonList(new RequestPartR("apply", Collections.emptyList()));
            Request req = new Request(request.getVisitor(), parts);
            List<RequestPartR> rparts = request.getParts();
            if (condition.getValue()) {
                return request.getParts().get(1).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(2).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(3).getArgs().get(0).request(req);
            } else {
                return done;
            }
        });
        lexicalParent.addMethod("if(1)then(1)elseif(1)then(1)else(1)", request -> {
            GraceBoolean condition = (GraceBoolean) request.getParts().get(0).getArgs().get(0);
            List<RequestPartR> parts = Collections.singletonList(new RequestPartR("apply", Collections.emptyList()));
            Request req = new Request(request.getVisitor(), parts);
            List<RequestPartR> rparts = request.getParts();
            if (condition.getValue()) {
                return request.getParts().get(1).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(2).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(3).getArgs().get(0).request(req);
            } else {
                return request.getParts().get(4).getArgs().get(0).request(req);
            }
        });
        lexicalParent.addMethod("if(1)then(1)elseif(1)then(1)elseif(1)then(1)else(1)", request -> {
            GraceBoolean condition = (GraceBoolean) request.getParts().get(0).getArgs().get(0);
            List<RequestPartR> parts = Collections.singletonList(new RequestPartR("apply", Collections.emptyList()));
            Request req = new Request(request.getVisitor(), parts);
            List<RequestPartR> rparts = request.getParts();
            if (condition.getValue()) {
                return request.getParts().get(1).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(2).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(3).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(4).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(5).getArgs().get(0).request(req);
            } else {
                return request.getParts().get(6).getArgs().get(0).request(req);
            }
        });
        lexicalParent.addMethod("if(1)then(1)elseif(1)then(1)elseif(1)then(1)", request -> {
            GraceBoolean condition = (GraceBoolean) request.getParts().get(0).getArgs().get(0);
            List<RequestPartR> parts = Collections.singletonList(new RequestPartR("apply", Collections.emptyList()));
            Request req = new Request(request.getVisitor(), parts);
            List<RequestPartR> rparts = request.getParts();
            if (condition.getValue()) {
                return request.getParts().get(1).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(2).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(3).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(4).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(5).getArgs().get(0).request(req);
            } else {
                return done;
            }
        });
        lexicalParent.addMethod("if(1)then(1)elseif(1)then(1)elseif(1)then(1)elseif(1)then(1)else(1)", request -> {
            GraceBoolean condition = (GraceBoolean) request.getParts().get(0).getArgs().get(0);
            List<RequestPartR> parts = Collections.singletonList(new RequestPartR("apply", Collections.emptyList()));
            Request req = new Request(request.getVisitor(), parts);
            List<RequestPartR> rparts = request.getParts();
            if (condition.getValue()) {
                return request.getParts().get(1).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(2).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(3).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(4).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(5).getArgs().get(0).request(req);
            } else if (((GraceBoolean) rparts.get(6).getArgs().get(0).request(req)).getValue()) {
                return rparts.get(7).getArgs().get(0).request(req);
            } else {
                return request.getParts().get(8).getArgs().get(0).request(req);
            }
        });
        lexicalParent.addMethod("while(1)do(1)", request -> {
            List<RequestPartR> parts = Collections.singletonList(new RequestPartR("apply", Collections.emptyList()));
            Request req = new Request(request.getVisitor(), parts);
            GraceObject condition = request.getParts().get(0).getArgs().get(0);
            GraceObject body = request.getParts().get(1).getArgs().get(0);
            while (((GraceBoolean) condition.request(req)).getValue()) {
                body.request(req);
            }
            return done;
        });
        lexicalParent.addMethod("getFileContents(1)", request -> {
            String filename = ((GraceString) request.getParts().get(0).getArgs().get(0)).getValue();
            try {
                return new GraceString(new String(Files.readAllBytes(Paths.get(filename))));
            } catch (IOException e) {
                throw new RuntimeException("Error reading file: " + filename);
            }
        });
        return lexicalParent;
    }

    // Purpose: Evaluates an AST representing a module.
    // Details: Uses basePrelude() as the context and processes the module's AST.
    public GraceObject evaluateModule(ObjectConstructor module) {

        return this.visit(basePrelude(), module);
    }

    // Purpose: Adds a module to the internal module map.
    // Details: Maps the module name to its GraceObject representation.
    public void bindModule(String name, GraceObject module) {

        modules.put(name, module);
    }

    // Purpose: Evaluates a given program AST.
    // Details: Uses basePrelude() and an evaluator instance to process the program
    // AST.
    static GraceObject evaluateProgram(ASTNode program) {
        BaseObject lexicalParent = (BaseObject) basePrelude();
        return evaluateProgram(program, lexicalParent);
    }

    // Purpose: Evaluates a program AST with a specified lexical parent.
    // Details: Processes the program AST in the context of the provided BaseObject.
    static GraceObject evaluateProgram(ASTNode program, BaseObject lexicalParent) {

        System.out.println("ASTNode program, BaseObject lexicalParent");

        Evaluator evaluator = new Evaluator();
        return evaluator.visit(lexicalParent, program);
    }

    public static void log(String message) {
        System.out.println(" >" + message);
    }

}
