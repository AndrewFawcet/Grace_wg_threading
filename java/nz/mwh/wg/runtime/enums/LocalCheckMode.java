package nz.mwh.wg.runtime.enums;

public enum LocalCheckMode {
    OFF,                        // threadBoundaryLocalChecking = false, dereferencingLocalCheck = false
    THREAD_BOUNDARY,            // threadBoundaryLocalChecking = true, dereferencingLocalCheck = false
    DEREFERENCING,              // threadBoundaryLocalChecking = false, dereferencingLocalCheck = true
    DEREFERENCING_AND_THREAD_BOUNDARY    // threadBoundaryLocalChecking = true, dereferencingLocalCheck = true
}
