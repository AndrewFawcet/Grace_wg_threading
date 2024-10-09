package nz.mwh.wg.runtime;

public interface GraceObject {
    GraceObject request(Request request);
    GraceObject findReceiver(String name);
}
