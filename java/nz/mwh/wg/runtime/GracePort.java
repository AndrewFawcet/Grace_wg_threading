package nz.mwh.wg.runtime;

import java.util.concurrent.BlockingQueue;

// import nz.mwh.wg.ast.*;

// This class represents one end of a communication channel that can send and receive messages.
// The Port class encapsulates a bidirectional communication mechanism using two blocking queues, enabling synchronized message passing between threads while supporting blocking behavior for backpressure.
// Represents one end of a duplex channel, with the ability to send and receive messages of different types.
// GracePort provides an abstraction over BlockingQueue to handle message passing in a thread-safe manner.
public class GracePort<SendT, ReceiveT> implements GraceObject{
    private final BlockingQueue<SendT> sendQueue;
    private final BlockingQueue<ReceiveT> receiveQueue;

    public GracePort(BlockingQueue<SendT> sendQueue, BlockingQueue<ReceiveT> receiveQueue) {
        this.sendQueue = sendQueue;
        this.receiveQueue = receiveQueue;
    }

    // Sends a message to the connected port
    public void send(SendT message) throws InterruptedException {
        sendQueue.put(message);
    }

    // Receives a message from the connected port
    public ReceiveT receive() throws InterruptedException {
        return receiveQueue.take();
    }

    @Override
    public GraceObject request(Request request) {
        throw new UnsupportedOperationException("Ports do not support direct requests.");
    }

    @Override
    public GraceObject findReceiver(String name) {
        throw new UnsupportedOperationException("Ports do not have receivers.");
    }
}