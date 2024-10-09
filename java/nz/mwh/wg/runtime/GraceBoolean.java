package nz.mwh.wg.runtime;

import java.util.List;

public class GraceBoolean implements GraceObject {
    private boolean value;

    public GraceBoolean(boolean value) {
        this.value = value;
    }

    public String toString() {
        return "" + value;
    }

    public boolean getValue() {
        return value;
    }

    @Override
    public GraceObject request(Request request) {
        List<RequestPartR> parts = request.getParts();
        if (parts.size() == 1) {
            String name = parts.get(0).getName();
            if (name.equals("prefix!") || name.equals("not")) {
                return new GraceBoolean(!value);
            } else if (name.equals("&&")) {
                return new GraceBoolean(value && ((GraceBoolean) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("||")) {
                return new GraceBoolean(value || ((GraceBoolean) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("asString")) {
                return new GraceString("" + value);
            } else if (name.equals("==")) {
                return new GraceBoolean(value == ((GraceBoolean) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("!=")) {
                return new GraceBoolean(value != ((GraceBoolean) parts.get(0).getArgs().get(0)).value);
            }
        }
        throw new RuntimeException("No such method in Boolean: " + request.getName());
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}
