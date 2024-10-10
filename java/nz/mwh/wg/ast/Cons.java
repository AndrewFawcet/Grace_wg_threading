package nz.mwh.wg.ast;

import java.util.List;

import nz.mwh.wg.runtime.GraceString;

import java.util.ArrayList;

public class Cons<T> {
    public T head;
    public Cons<T> tail;
    protected boolean isNil = false;

    public Cons(T head, Cons<T> tail) {
        this.head = head;
        this.tail = tail;
    }

    public Cons() {
        isNil = true;
    }

    public static <T> List<T> toList(Cons<? extends T> cons) {
        List<T> list = new ArrayList<>();
        while (cons != null && !cons.isNil) {
            list.add(cons.head);
            cons = cons.tail;
        }
        return list;
    }

    public List<T> toList() {
        List<T> ret = new ArrayList<T>();
        Cons<T> current = this;
        while (!current.isNil) {
            ret.add(current.head);
            current = current.tail;
        }
        return ret;
    }

    // Check if the Cons contains the given element
    public boolean contains(T element) {
        Cons<T> current = this;
        while (!current.isNil) {
            if (current.head.equals(element)) {
                return true;
            }
            current = current.tail;
        }
        return false;
    }

    public String toString() {
        if (isNil)
            return "nil";
        String headStr = head instanceof String ? "\"" + head + "\"" : head instanceof GraceString ? "\"" + head.toString() + "\"" : head.toString();
        if (tail == null || tail.isNil)
            return "one(" + headStr + ")";
        return "cons(" + headStr + ", " + (tail == null ? "nil" : tail.toString()) + ")";
    }

    public boolean isNil() {
        return isNil;
    }

    public T getHead() {
        return head;
    }

    public static <T> Cons<T> nil() {
        return new Cons<T>();
    }

    private static <T> void headToString(T it, StringBuilder sb) {
        if (it instanceof String || it instanceof GraceString) {
            sb.append("\"");
            sb.append(it);
            sb.append("\"");
        } else
            sb.append(it);
    }

    public static <T> String stringFromList(List<T> items) {
        if (items.size() == 0)
            return "nil";
        StringBuilder sb = new StringBuilder();
        int len = items.size();
        int n = 0;
        for (T it : items) {
            n++;
            if (n == len) {
                sb.append("one(");
                headToString(it, sb);
            } else {
                sb.append("cons(");
                headToString(it, sb);
                sb.append(", ");
            }
        }
        //sb.append("nil");
        for (int i = 0; i < items.size(); i++) {
            sb.append(")");
        }
        return sb.toString();
    }

    public static <T> Cons<T> fromValue(T value) {
        if (value == null)
            return new Cons<T>();
        return new Cons<T>(value, new Cons<T>());
    }

}

