package nz.mwh.wg.runtime;

import java.util.ArrayList;
import java.util.List;

public class GraceArray implements GraceObject {
    private List<GraceObject> elements;

    public GraceArray() {
        elements = new ArrayList<>();
    }

    public void add(GraceObject obj) {
        elements.add(obj);
    }

    public GraceObject get(int index) {
        if (index < 0 || index >= elements.size()) {
            throw new IndexOutOfBoundsException("Index " + index + " out of bounds");
        }
        return elements.get(index);
    }

    public int size() {
        return elements.size();
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < elements.size(); i++) {
            sb.append(elements.get(i).toString());
            if (i < elements.size() - 1) sb.append(", ");
        }
        sb.append("]");
        return sb.toString();
    }

    @Override
    public GraceObject request(Request request) {
        List<RequestPartR> parts = request.getParts();
        String name = parts.get(0).getName();

        if (name.equals("add")) {
            GraceObject obj = parts.get(0).getArgs().get(0);
            add(obj);
            return GraceDone.done;
        } else if (name.equals("get")) {
            try {
                int index = (int) ((GraceNumber) parts.get(0).getArgs().get(0)).getValue();
                return get(index);
            } catch (RuntimeException e) {
                throw new RuntimeException("Failed to get element: " + e.getMessage());
            }
        } else if (name.equals("size")) {
            return new GraceNumber(size());
        } else if (name.equals("asString")) {
            return new GraceString(toString());
        }

        throw new RuntimeException("No such method in GraceArray: " + name);
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }

    // Method to integrate with Evaluator
    public static void addToEvaluator(BaseObject lexicalParent) {
        lexicalParent.addMethod("array(0)", request -> new GraceArray());
    }
}
