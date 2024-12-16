package nz.mwh.wg.runtime;

import java.util.concurrent.BlockingQueue;

// import nz.mwh.wg.ast.*;

// This class represents one end of a communication channel that can send and receive messages.
// The Port class encapsulates a bidirectional communication mechanism using two blocking queues, enabling synchronized message passing between threads while supporting blocking behavior for backpressure.
public class Port<T> implements GraceObject {
    private final BlockingQueue<T> writeQueue;
    private final BlockingQueue<T> readQueue;

    public Port(BlockingQueue<T> writeQueue, BlockingQueue<T> readQueue) {
        this.writeQueue = writeQueue;
        this.readQueue = readQueue;
    }

    public void send(T message) throws InterruptedException {
        writeQueue.put(message); // Blocks if the queue is full
    }

    public T receive() throws InterruptedException {
        return readQueue.take(); // Blocks if the queue is empty
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