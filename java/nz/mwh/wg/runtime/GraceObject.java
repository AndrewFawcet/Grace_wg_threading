package nz.mwh.wg.runtime;

public interface GraceObject {
    GraceObject request(Request request);
    GraceObject findReceiver(String name);

    default GraceObject beReturned() {
        return this;
    };
    default boolean isBeingReturned() {
        return false;
    };
    default void discard() {};
    default void incRefCount() {};
    default void decRefCount() {};
}
