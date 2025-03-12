package nz.mwh.wg.runtime;

public class CapabilityAdjuster {
    
    public static void changeCapability(BaseObject object, boolean local, boolean iso, boolean immutable) {
        // Get current capability status
        boolean isCurrentlyLocal = object.isLocal();
        boolean isCurrentlyIso = object.isIsolated();
        boolean isCurrentlyImmutable = object.isImmutable();
        int refCount = object.getReferenceCount();

        // Enforce capability transition rules
        if (isCurrentlyImmutable) {
            throw new RuntimeException("Cannot change capability of an immutable object.");
        }

        if (isCurrentlyIso && refCount > 1) {
            throw new RuntimeException("Cannot change capability of an isolated object with multiple references.");
        }

        if (immutable && refCount > 1) {
            throw new RuntimeException("Cannot make an object immutable while it has multiple references.");
        }
        // this will require objects to track how many threads they are on in order to have a transitional object check for local appropriateness
        // this will not be required for locals enforced by dereferencing, as an error will be created when the local is dereferenced on the wrong thread.

        // Removes the previous capability (if there was one)
        if (isCurrentlyImmutable){
            object.setImmutable(false);
        }
        if (isCurrentlyIso){
            object.setIsolated(false);
        }
        if (isCurrentlyLocal){
            object.setLocal(false);
        }

        // If being assigned to local will change the object thread to the thread at point of change.
        if (local) {
            Thread thread = Thread.currentThread();
            object.setObjectThread(thread);
        }

        // Apply new capability settings (if there is one, can be set to unsafe)
        object.setLocal(local);
        object.setIsolated(iso);
        object.setImmutable(immutable);
    }
}
