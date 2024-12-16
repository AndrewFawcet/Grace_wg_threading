package nz.mwh.wg.runtime;

// import nz.mwh.wg.ast.*;

public class GraceChannelWrapper implements GraceObject {
    private final Port<GraceObject> port;

    public GraceChannelWrapper(Port<GraceObject> port) {
        this.port = port;
    }

    // Have a send method in here??
    // Method to send a message to the worker thread
    public void send(GraceObject message) {
        try {
            port.send(message);
        } catch (InterruptedException e) {
            throw new RuntimeException("Interrupted while sending message to worker thread.", e);
        }
    }

    // Method to retrieve a message from the worker thread
    public GraceObject receive() {
        try {
            return port.receive();
        } catch (InterruptedException e) {
            throw new RuntimeException("Interrupted while waiting for message from worker thread.", e);
        }
    }

    // // Method to retrieve the result when ready
    // public GraceObject getResult() {
    //     try {
    //         return port.receive(); // Blocks until a result is available
    //     } catch (InterruptedException e) {
    //         throw new RuntimeException("Interrupted while waiting for result.", e);
    //     }
    // }
    @Override
    public GraceObject request(Request request) {
        if (request.parts.size() == 1) {
            String methodName = request.parts.get(0).getName();
            if (methodName.equals("getResult")) {
                return receive();
            } else if (methodName.equals("sendMessage")) {
                send(request.parts.get(0).getArgs().get(0)); // Assuming 1 argument
                // return GraceObject.NIL; // or appropriate return
            }
        }
        throw new RuntimeException("No such method: " + request.getName());
    }
    // @Override
    // public GraceObject request(Request request) {
    //     if (request.parts.size() == 1 && request.parts.get(0).getName().equals("getResult")) {
    //         return getResult();
    //     }
    //     throw new RuntimeException("No such method: " + request.getName());
    // }

    @Override
    public GraceObject findReceiver(String name) {
        // GraceChannelWrapper doesn't have fields, so it can return null or throw an exception.
        throw new RuntimeException("No such field or receiver: " + name);
    }
}
