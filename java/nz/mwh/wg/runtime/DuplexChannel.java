package nz.mwh.wg.runtime;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

// import nz.mwh.wg.ast.*;

// This class provides a pair of connected Port instances for two-way communication.
// The Channel class creates a full-duplex communication link by internally managing two BlockingQueue instances, each representing a unidirectional flow, and generates interconnected Port objects to facilitate thread-safe message exchanges.
public class DuplexChannel<T1, T2> {
    private final BlockingQueue<T1> queue1; // Queue for Port1 to Port2 communication
    private final BlockingQueue<T2> queue2; // Queue for Port2 to Port1 communication

    public DuplexChannel(int capacity) {
        this.queue1 = new LinkedBlockingQueue<>(capacity);
        this.queue2 = new LinkedBlockingQueue<>(capacity);
    }

    // Creates the first port (sends T1, receives T2)
    public GracePort<T1, T2> createPort1() {
        return new GracePort<>(queue1, queue2);
    }

    // Creates the second port (sends T2, receives T1)
    public GracePort<T2, T1> createPort2() {
        return new GracePort<>(queue2, queue1);
    }
}