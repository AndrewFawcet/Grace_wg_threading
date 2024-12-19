package nz.mwh.wg.runtime;

import java.util.concurrent.BlockingQueue;

// import nz.mwh.wg.ast.*;

// This class represents one end of a communication channel that can send and receive messages.
// The Port class encapsulates a bidirectional communication mechanism using two blocking queues, enabling synchronized message passing between threads while supporting blocking behavior for backpressure.
// Represents one end of a duplex channel, with the ability to send and receive messages of different types.
// GracePort provides an abstraction over BlockingQueue to handle message passing in a thread-safe manner.
public class GracePort {
    private final BlockingQueue<GraceObject> sendQueue;
    private final BlockingQueue<GraceObject> receiveQueue;

    public GracePort(BlockingQueue<GraceObject> sendQueue, BlockingQueue<GraceObject> receiveQueue) {
        this.sendQueue = sendQueue;
        this.receiveQueue = receiveQueue;
    }

    public void send(GraceObject message) throws InterruptedException {
        sendQueue.put(message);
    }

    public GraceObject receive() throws InterruptedException {
        return receiveQueue.take();
    }
}