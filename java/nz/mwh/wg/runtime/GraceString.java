package nz.mwh.wg.runtime;

import java.util.List;

public class GraceString implements GraceObject {
    private String value;

    public GraceString(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public String toString() {
        return value;
    }

    @Override
    public GraceObject request(Request request) {
        List<RequestPartR> parts = request.getParts();
        if (parts.size() == 1) {
            String name = parts.get(0).getName();
            if (name.equals("++")) {
                return new GraceString(value + parts.get(0).getArgs().get(0).toString());
            } else if (name.equals("asString")) {
                return new GraceString(value);
            } else if (name.equals("size")) {
                return new GraceNumber(value.length());
            } else if (name.equals("==")) {
                return new GraceBoolean(value.equals(((GraceString) parts.get(0).getArgs().get(0)).value));
            } else if (name.equals("!=")) {
                return new GraceBoolean(!value.equals(((GraceString) parts.get(0).getArgs().get(0)).value));
            } else if (name.equals("<")) {
                return new GraceBoolean(value.compareTo(((GraceString) parts.get(0).getArgs().get(0)).value) < 0);
            } else if (name.equals(">")) {
                return new GraceBoolean(value.compareTo(((GraceString) parts.get(0).getArgs().get(0)).value) > 0);
            } else if (name.equals("at")) {
                int index = (int) ((GraceNumber) parts.get(0).getArgs().get(0)).value;
                return new GraceString("" + value.charAt(index - 1));
            } else if (name.equals("firstCodepoint") || name.equals("firstCP")) {
                return new GraceNumber(value.codePointAt(0));
            }
        } else if (parts.size() == 2) {
            String name = request.getName();
            if (name.equals("replace(1)with(1)")) {
                String old = ((GraceString) parts.get(0).getArgs().get(0)).value;
                String replacement = ((GraceString) parts.get(1).getArgs().get(0)).value;
                return new GraceString(value.replace(old, replacement));
            } else if (name.equals("substringFrom(1)to(1)")) {
                int start = (int) ((GraceNumber) parts.get(0).getArgs().get(0)).value;
                int end = (int) ((GraceNumber) parts.get(1).getArgs().get(0)).value;
                return new GraceString(value.substring(start - 1, end));
            }
        }
        throw new RuntimeException("No such method in String: " + request.getName());
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}

