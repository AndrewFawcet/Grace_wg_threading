package nz.mwh.wg.runtime;

// import nz.mwh.wg.ast.*;

public class GraceChannelWrapper implements GraceObject {
    private final Port<GraceObject> port;

    public GraceChannelWrapper(Port<GraceObject> port) {
        this.port = port;
    }

    // Have a send method in here??
    public void send(GraceObject obj) throws InterruptedException {
        port.send(obj);
    }

    // Method to retrieve the result when ready
    public GraceObject getResult() {
        try {
            return port.receive(); // Blocks until a result is available
        } catch (InterruptedException e) {
            throw new RuntimeException("Interrupted while waiting for result.", e);
        }
    }

    @Override
    public GraceObject request(Request request) {
        if (request.parts.size() == 1 && request.parts.get(0).getName().equals("getResult")) {
            return getResult();
        }
        throw new RuntimeException("No such method: " + request.getName());
    }

    @Override
    public GraceObject findReceiver(String name) {
        // GraceChannelWrapper doesn't have fields, so it can return null or throw an exception.
        throw new RuntimeException("No such field or receiver: " + name);
    }
}
