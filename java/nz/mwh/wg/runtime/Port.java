package nz.mwh.wg.runtime;

import java.util.concurrent.BlockingQueue;

import nz.mwh.wg.ast.*;

public class Port<T> {
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
}