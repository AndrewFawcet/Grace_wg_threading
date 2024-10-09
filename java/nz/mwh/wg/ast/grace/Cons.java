package nz.mwh.wg.ast.grace;

import java.util.Collections;
import java.util.List;

import nz.mwh.wg.runtime.GraceBoolean;
import nz.mwh.wg.runtime.GraceNumber;
import nz.mwh.wg.runtime.GraceObject;
import nz.mwh.wg.runtime.GraceString;
import nz.mwh.wg.runtime.Request;
import nz.mwh.wg.runtime.RequestPartR;

public class Cons<T> extends nz.mwh.wg.ast.Cons<T> implements GraceObject {
    
    private Cons<T> tail;

    public Cons(T head, Cons<T> tail) {
        super(head, tail);
        this.tail = tail;
    }

    public Cons() {
        super();
    }

    public static <T> Cons<T> nil() {
        return new Cons<T>();
    }
    
    @Override
    public GraceObject request(Request request) {
        String name = request.getParts().get(0).getName();
        if ("head".equals(name)) {
            return graceWrap(head);
        } else if ("tail".equals(name)) {
            return tail;
        } else if ("end".equals(name)) {
            return new GraceBoolean(isNil);
        } else if ("asString".equals(name)) {
            return new GraceString("cons(" + head + ", " + tail.request(request).toString() + ")");
        } else if ("reversed".equals(name)) {
            return reversed(new Cons<GraceObject>());
        } else if ("map".equals(name)) {
            return map(request);
        }
        throw new RuntimeException("No such method in Cons: " + name);
    }

    private Cons<GraceObject> map(Request request) {
        List<RequestPartR> parts = request.getParts();
        GraceObject f = parts.get(0).getArgs().get(0);
        GraceObject fResult = f.request(new Request(request.getVisitor(), Collections.singletonList(new RequestPartR("apply", Collections.singletonList(graceWrap(head))))));
        return cons(fResult, tail.isNil ? new Cons<GraceObject>() : tail.map(request));
    }

    private Cons<GraceObject> reversed(Cons<GraceObject> next) {
        if (isNil)
            return next;
        Cons<GraceObject> c = cons(graceWrap(head), next);
        if (tail == null || tail.isNil) {
            return c;
        } else {
            return tail.reversed(c);
        }
    }

    private GraceObject graceWrap(T head) {
        if (head instanceof GraceObject)
                return (GraceObject)head;
        else if (head instanceof String)
            return new GraceString((String)head);
        else if (head instanceof Integer)
            return new GraceNumber((int)head);
        else if (head instanceof Double)
            return new GraceNumber((double)head);
        else if (head instanceof Boolean)
            return new GraceBoolean((boolean)head);
        else
            return new Wrapper(head);
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }

    private static <T> Cons<T> cons(T head, Cons<T> tail) {
        return new Cons<>(head, tail);
    }

}
