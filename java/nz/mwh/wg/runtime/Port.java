package nz.mwh.wg.runtime;

import java.util.concurrent.BlockingQueue;

// import nz.mwh.wg.ast.*;

// This class represents one end of a communication channel that can send and receive messages.
// The Port class encapsulates a bidirectional communication mechanism using two blocking queues, enabling synchronized message passing between threads while supporting blocking behavior for backpressure.
public class Port<T> implements GraceObject {
    private final BlockingQueue<T> writeQueue;
    private final BlockingQueue<T> readQueue;
    private volatile boolean closed = false; // Flag to indicate closure

    public Port(BlockingQueue<T> writeQueue, BlockingQueue<T> readQueue) {
        this.writeQueue = writeQueue;
        this.readQueue = readQueue;
    }

    public void send(T message) throws InterruptedException {
        if (closed) {
            throw new IllegalStateException("Port is closed and cannot accept new messages.");
        }
        writeQueue.put(message); // Blocks if the queue is full
    }

    public T receive() throws InterruptedException {
        // return readQueue.take(); // Blocks if the queue is empty
        T message = readQueue.take(); // Blocks if the queue is empty
        if (message == null) { // Null indicates the port has been closed
            throw new IllegalStateException("Port is closed and no further messages are available.");
        }
        return message;
    }

    public void close() throws InterruptedException {
        closed = true;
        writeQueue.put(null);   // for graceful closure.
        readQueue.put(null);    // for graceful closure.
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