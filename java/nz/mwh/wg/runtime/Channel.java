package nz.mwh.wg.runtime;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import nz.mwh.wg.ast.*;

public class Channel<T> {
    private final BlockingQueue<T> queue1; // Queue from port1 to port2
    private final BlockingQueue<T> queue2; // Queue from port2 to port1

    public Channel(int capacity) {
        this.queue1 = new LinkedBlockingQueue<>(capacity);
        this.queue2 = new LinkedBlockingQueue<>(capacity);
    }

    public Port<T> createPort1() {
        return new Port<>(queue1, queue2);
    }

    public Port<T> createPort2() {
        return new Port<>(queue2, queue1);
    }
}