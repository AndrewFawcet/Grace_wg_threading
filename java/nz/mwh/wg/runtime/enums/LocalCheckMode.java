package nz.mwh.wg.runtime.enums;

public enum LocalCheckMode {
    OFF,         // threadBoundaryLocalChecking = false, dereferencingLocalCheck = false
    THREAD,      // threadBoundaryLocalChecking = true, dereferencingLocalCheck = false
    DEREFERENCING, // threadBoundaryLocalChecking = false, dereferencingLocalCheck = true
    THREAD_AND_DEREFERENCING // threadBoundaryLocalChecking = true, dereferencingLocalCheck = true
}
