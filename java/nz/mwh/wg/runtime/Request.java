package nz.mwh.wg.runtime;

import java.util.List;
import java.util.stream.Collectors;

import nz.mwh.wg.Visitor;

public class Request {
    List<RequestPartR> parts;
    private Visitor<GraceObject> visitor;
    private String location = "<unknown>";

    public Request(Visitor<GraceObject> visitor, List<RequestPartR> parts) {
        this.visitor = visitor;
        this.parts = parts;
    }

    public Request(Visitor<GraceObject> visitor, List<RequestPartR> parts, String location) {
        this.visitor = visitor;
        this.parts = parts;
        this.location = location;
    }

    public List<RequestPartR> getParts() {
        return parts;
    }

    public String getName() {
        return parts.stream().map(x -> x.getName() + "(" + x.getArgs().size() + ")").collect(Collectors.joining(""));
    }

    public String getLocation() {
        return location;
    }

    public Visitor<GraceObject> getVisitor() {
        return visitor;
    }
}
