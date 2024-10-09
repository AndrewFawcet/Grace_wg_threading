package nz.mwh.wg.runtime;

public class GraceUninitialised implements GraceObject {
    public static GraceUninitialised uninitialised = new GraceUninitialised();
    
    @Override
    public GraceObject request(Request request) {
        throw new RuntimeException("Cannot request method on uninitialised value: " + request.getName());
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}