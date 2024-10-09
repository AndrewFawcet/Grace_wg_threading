package nz.mwh.wg.runtime;

import java.util.List;

public class RequestPartR {
    private String name;
    private List<GraceObject> args;

    public RequestPartR(String name, List<GraceObject> args) {
        this.name = name;
        this.args = args;
    }

    public String getName() {
        return name;
    }

    public List<GraceObject> getArgs() {
        return args;
    }
}
