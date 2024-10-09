package nz.mwh.wg.runtime;

public class GraceDone implements GraceObject {
    public static GraceDone done = new GraceDone();
    @Override
    public GraceObject request(Request request) {
        throw new RuntimeException("No such method in Done: " + request.getName());
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}
