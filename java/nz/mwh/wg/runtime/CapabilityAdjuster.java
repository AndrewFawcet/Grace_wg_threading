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

        // Removes the previous capability (is there was one)
        if (object.isImmutable()){
            object.setImmutable(false);
        }
        if (object.isIsolated()){
            object.setIsolated(false);
        }
        if (object.isLocal()){
            object.setLocal(false);
        }

        // Apply new capability settings
        object.setLocal(local);
        object.setIsolated(iso);
        object.setImmutable(immutable);
    }
}
