package nz.mwh.wg.runtime;

import java.util.List;

public class GraceChannel implements GraceObject {
    private final GracePort sendPort;
    private final GracePort receivePort;

    public GraceChannel(GracePort port1, GracePort port2) {
        this.sendPort = port1;
        this.receivePort = port2;
    }

    public GracePort getSendPort() {
        return sendPort;
    }

    public GracePort getReceivePort() {
        return receivePort;
    }

    // putting in a check that local are checked just prior to changing threads.
    public void send(GraceObject objectSending) throws InterruptedException {
        sendPort.send(objectSending);
    }

    // putting in a check that local objects are checked immediately after changing threads.
    public GraceObject receive() throws InterruptedException {
        GraceObject objectReceived = receivePort.receive();

        // Perform the local object check after receiving
        if (objectReceived instanceof BaseObject) {
            BaseObject baseObject = (BaseObject) objectReceived;
            if (baseObject.isLocal()) {
                if (baseObject.getObjectThread() != Thread.currentThread()) {
                    throw new RuntimeException("Capability Violation: Local object received on a different thread");
                }
            }
        }

        return objectReceived;
    }

    @Override
    public GraceObject request(Request request) {
        if ("send(1)".equals(request.getName())) {
            try {
                send(request.getParts().get(0).getArgs().get(0));
                return GraceDone.done;
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        } else if ("receive(0)".equals(request.getName())) {
            try {
                return receive();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
        throw new UnsupportedOperationException("Unimplemented method " + request.getName());
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new RuntimeException("No such method in scope: " + name);
    }
}