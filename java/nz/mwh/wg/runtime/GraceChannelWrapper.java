package nz.mwh.wg.runtime;

// import nz.mwh.wg.ast.*;
import java.util.concurrent.CompletableFuture;

public class GraceChannelWrapper implements GraceObject {
    private final GracePort<Request, GraceObject> port;

    public GraceChannelWrapper(GracePort<Request, GraceObject> port) {
        this.port = port;
    }

    //  // Non-blocking send using CompletableFuture
    //  public CompletableFuture<Void> sendAsync(GraceObject message) {
    //     return CompletableFuture.runAsync(() -> {
    //         try {
    //             port.send(message);
    //         } catch (InterruptedException e) {
    //             throw new RuntimeException("Interrupted while sending message to worker thread.", e);
    //         }
    //     });
    // }

    // // Non-blocking receive using CompletableFuture
    // public CompletableFuture<GraceObject> receiveAsync() {
    //     return CompletableFuture.supplyAsync(() -> {
    //         try {
    //             return port.receive();
    //         } catch (InterruptedException e) {
    //             throw new RuntimeException("Interrupted while waiting for response from worker thread.", e);
    //         }
    //     });
    // }

    public void sendRequest(Request request) {
        try {
            port.send(request);
        } catch (InterruptedException e) {
            throw new RuntimeException("Interrupted while sending request to worker thread.", e);
        }
    }
    
    public GraceObject receiveResponse() {
        try {
            return port.receive();
        } catch (InterruptedException e) {
            throw new RuntimeException("Interrupted while waiting for response from worker thread.", e);
        }
    }

    @Override
    public GraceObject request(Request request) {
        if (request.parts.size() == 1) {
            String methodName = request.parts.get(0).getName();
            if (methodName.equals("getResult")) {
                return receiveResponse();
            } else if (methodName.equals("sendMessage")) {
                sendRequest(request);   // dodgy?
                // send(request.parts.get(0).getArgs().get(0)); // Assuming 1 argument
                // return GraceObject.NIL; // or appropriate return
            }
        }
        throw new RuntimeException("No such method: " + request.getName());
    }

    @Override
    public GraceObject findReceiver(String name) {
        // GraceChannelWrapper doesn't have fields, so it can return null or throw an exception.
        throw new RuntimeException("No such field or receiver: " + name);
    }
}
