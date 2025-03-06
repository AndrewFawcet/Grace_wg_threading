package nz.mwh.wg.runtime;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Consumer;
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
        return accessBaseObjectWithReturn(BaseObject::isLocal);
    }

    public boolean isIsolated() {
        return accessBaseObjectWithReturn(BaseObject::isIsolated);
    }

    public boolean isImmutable() {
        return accessBaseObjectWithReturn(BaseObject::isImmutable);
    }

    public void setLocal(boolean isLocal) {
        accessBaseObjectWithoutReturn(obj -> obj.setLocal(isLocal));
    }

    public void setIsolated(boolean isIsolated) {
        accessBaseObjectWithoutReturn(obj -> obj.setIsolated(isIsolated));
    }

    public void setImmutable(boolean isImmutable) {
        accessBaseObjectWithoutReturn(obj -> obj.setImmutable(isImmutable));
    }

    public Thread getObjectThread() {
        return accessBaseObjectWithReturn(BaseObject::getObjectThread);
    }

    public int getReferenceCount() {
        return accessBaseObjectWithReturn(BaseObject::getReferenceCount);
    }

    public void incrementReferenceCount() {
        accessBaseObjectWithoutReturn(BaseObject::incrementReferenceCount);
    }

    public void decrementReferenceCount() {
        accessBaseObjectWithoutReturn(BaseObject::decrementReferenceCount);
    }

    public void setAliasName(String name) {
        accessBaseObjectWithoutReturn(obj -> obj.setAliasName(name));
    }

    public String getAliasName() {
        return accessBaseObjectWithReturn(BaseObject::getAliasName);
    }

    public void setAliasObject(GraceObject object) {
        accessBaseObjectWithoutReturn(obj -> obj.setHoldingObject(object));
    }

    public GraceObject getAliasObject() {
        return accessBaseObjectWithReturn(BaseObject::getHoldingObject);
    }

    public boolean isAutoUnlinkingIsoMoves() {
        return accessBaseObjectWithReturn(BaseObject::isAutoUnlinkingIsoMoves);
    }

    public boolean isThreadBoundaryLocalChecking() {
        return accessBaseObjectWithReturn(BaseObject::isThreadBoundaryLocalChecking);
    }

    @Override
    public String toString() {
        return accessBaseObjectWithReturn(BaseObject::toString);
    }

    public void addMethod(String name, Function<Request, GraceObject> method) {
        accessBaseObjectWithoutReturn(obj -> obj.addMethod(name, method));
    }

    @Override
    public GraceObject request(Request request) {
        return accessBaseObjectWithReturn(obj -> obj.request(request));
    }

    public GraceObject findReceiver(String name) {
        return accessBaseObjectWithReturn(obj -> obj.findReceiver(name));
    }

    public void addField(String name) {
        accessBaseObjectWithoutReturn(obj -> obj.addField(name));
    }

    public void addFieldWriter(String name) {
        accessBaseObjectWithoutReturn(obj -> obj.addFieldWriter(name));
    }

    public void setField(String name, GraceObject value) {
        accessBaseObjectWithoutReturn(obj -> obj.setField(name, value));
    }

    public GraceObject findReturnContext() {
        return accessBaseObjectWithReturn(BaseObject::findReturnContext);
    }

    private <T> T accessBaseObjectWithReturn(Function<BaseObject, T> action) {
        checkAlive();
        isoObject.setIsAccessAllowed(true);
        try {
            return action.apply(isoObject);
        } finally {
            isoObject.setIsAccessAllowed(false);
        }
    }
    
    private void accessBaseObjectWithoutReturn(Consumer<BaseObject> action) {
        checkAlive();
        isoObject.setIsAccessAllowed(true);
        try {
            action.accept(isoObject);
        } finally {
            isoObject.setIsAccessAllowed(false);
        }
    }
}