package nz.mwh.wg.runtime;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

// import nz.mwh.wg.ast.*;

// This class provides a pair of connected Port instances for two-way communication.
// The Channel class creates a full-duplex communication link by internally managing two BlockingQueue instances, each representing a unidirectional flow, and generates interconnected Port objects to facilitate thread-safe message exchanges.
public class DuplexChannel {
    private final BlockingQueue<GraceObject> queue1;
    private final BlockingQueue<GraceObject> queue2;

    public DuplexChannel(int capacity) {
        this.queue1 = new LinkedBlockingQueue<>(capacity);
        this.queue2 = new LinkedBlockingQueue<>(capacity);
    }

    public GracePort createPort1() {
        return new GracePort(queue1, queue2);
    }

    public GracePort createPort2() {
        return new GracePort(queue2, queue1);
    }
}