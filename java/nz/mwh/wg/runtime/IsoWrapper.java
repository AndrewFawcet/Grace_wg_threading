package nz.mwh.wg.runtime;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import nz.mwh.wg.Evaluator;

public class IsoWrapper implements GraceObject {
    private BaseObject isoObject;
    private boolean isAlive = true; // Used to track if the wrapper is "killed"
    
    public IsoWrapper(BaseObject isoObject) {
        if (!isoObject.isIsolated()) {
            throw new RuntimeException("IsoWrapper can only wrap isolated objects.");
        }
        this.isoObject = isoObject;
    }

    public synchronized void kill() {
        if (!isAlive) {
            throw new RuntimeException("IsoWrapper has already been killed.");
        }
        this.isoObject = null; // Remove reference
        this.isAlive = false;
    }

    // TODO does this method need to be synchronised?
    public synchronized void replaceIsoObject(BaseObject newIso) {
        if (!isAlive) {
            throw new RuntimeException("Cannot replace isoObject: IsoWrapper is dead.");
        }
        if (!newIso.isIsolated()) {
            throw new RuntimeException("Replacement must be an isolated object.");
        }
        this.isoObject = newIso;
    }

    @Override
    public GraceObject request(Request request) {
        if (!isAlive || isoObject == null) {
            throw new RuntimeException("IsoWrapper is dead; cannot forward requests.");
        }
        return isoObject.request(request);
    }

    public boolean isAlive() {
        return isAlive;
    }

    public GraceObject findReceiver(String name) {

        return isoObject.findReceiver(name);
    }
}