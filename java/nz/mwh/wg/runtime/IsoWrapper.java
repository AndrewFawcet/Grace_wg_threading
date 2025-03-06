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

    public boolean isAlive() {
        return isAlive;
    }

    private void checkAlive() {
        if (!isAlive || isoObject == null) {
            throw new RuntimeException("IsoWrapper is dead; cannot forward requests.");
        }
    }

    public synchronized void kill() {
        if (!isAlive) {
            throw new RuntimeException("IsoWrapper has already been killed.");
        }
        this.isoObject = null; // Remove reference
        this.isAlive = false;
    }

    // TODO apply for later killing of wrappers
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

    // All that follows is forwarding duplicates of public methods in BaseObject
    // Forwarding methods to the wrapped isoObject

    public boolean isLocal() {
        checkAlive();
        return isoObject.isLocal();
    }

    public boolean isIsolated() {
        checkAlive();
        return isoObject.isIsolated();
    }

    public boolean isImmutable() {
        checkAlive();
        return isoObject.isImmutable();
    }

    public void setLocal(boolean isLocal) {
        checkAlive();
        isoObject.setLocal(isLocal);
    }

    public void setIsolated(boolean isIsolated) {
        checkAlive();
        isoObject.setIsolated(isIsolated);
    }

    public void setImmutable(boolean isImmutable) {
        checkAlive();
        isoObject.setImmutable(isImmutable);
    }

    public Thread getObjectThread() {
        checkAlive();
        return isoObject.getObjectThread();
    }

    public int getReferenceCount() {
        checkAlive();
        return isoObject.getReferenceCount();
    }

    public void incrementReferenceCount() {
        checkAlive();
        isoObject.incrementReferenceCount();
    }

    public void decrementReferenceCount() {
        checkAlive();
        isoObject.decrementReferenceCount();
    }

    public void setAliasName(String name) {
        checkAlive();
        isoObject.setAliasName(name);
    }

    public String getAliasName() {
        checkAlive();
        return isoObject.getAliasName();
    }

    public void setAliasObject(GraceObject object) {
        checkAlive();
        isoObject.setHoldingObject(object);
    }

    public GraceObject getAliasObject() {
        checkAlive();
        return isoObject.getHoldingObject();
    }

    public boolean isAutoUnlinkingIsoMoves() {
        checkAlive();
        return isoObject.isAutoUnlinkingIsoMoves();
    }

    public boolean isThreadBoundaryLocalChecking() {
        checkAlive();
        return isoObject.isThreadBoundaryLocalChecking();
    }

    @Override
    public String toString() {
        checkAlive();
        return isoObject.toString();
    }

    public void addMethod(String name, Function<Request, GraceObject> method) {
        checkAlive();
        isoObject.addMethod(name, method);
    }

    @Override
    public GraceObject request(Request request) {
        checkAlive();
        return isoObject.request(request);
    }

    public GraceObject findReceiver(String name) {
        checkAlive();
        return isoObject.findReceiver(name);
    }

    public void addField(String name) {
        checkAlive();
        isoObject.addField(name);
    }

    public void addFieldWriter(String name) {
        // when making an (iso) BaseObject as a field it needs to set the IsoWrapper field in the BaseObject as well
        // the IsoWrapper field is used to authenticate outside references as coming only via this IsoWrapper.
        checkAlive();
        isoObject.addFieldWriter(name);
        isoObject.setWrapper(this);
        System.out.println("hi");
    }

    public void setField(String name, GraceObject value) {
        checkAlive();
        isoObject.setField(name, value);
    }

    public GraceObject findReturnContext() {
        checkAlive();
        return isoObject.findReturnContext();
    }
}