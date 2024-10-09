package nz.mwh.wg.runtime;

import java.util.List;

public class GraceNumber implements GraceObject {
    double value;

    public GraceNumber(double value) {
        this.value = value;
    }

    public double getValue() {
        return value;
    }

    public String toString() {
        if (value == (int) value) {
            return ("" + (int) value);
        } else {
            return ("" + value);
        }

    }

    @Override
    public GraceObject request(Request request) {
        List<RequestPartR> parts = request.getParts();
        if (parts.size() == 1) {
            String name = parts.get(0).getName();
            if (name.equals("+")) {
                if (!(parts.get(0).getArgs().get(0) instanceof GraceNumber)) {
                    System.out.println("invalid addition argument at " + request.getLocation());
                }
                return new GraceNumber(value + ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("-")) {
                return new GraceNumber(value - ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("*")) {
                return new GraceNumber(value * ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("/")) {
                return new GraceNumber(value / ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("prefix-")) {
                return new GraceNumber(-value);
            } else if (name.equals(">")) {
                return new GraceBoolean(value > ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("<")) {
                return new GraceBoolean(value < ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals(">=")) {
                return new GraceBoolean(value >= ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("<=")) {
                return new GraceBoolean(value <= ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("==")) {
                return new GraceBoolean(value == ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("!=")) {
                return new GraceBoolean(value != ((GraceNumber) parts.get(0).getArgs().get(0)).value);
            } else if (name.equals("asString")) {
                return new GraceString(toString());
            }
        }
        throw new RuntimeException("No such method in Number: " + request.getName());
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}
