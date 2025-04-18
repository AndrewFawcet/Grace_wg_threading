package nz.mwh.wg.runtime.enums;

public enum IsoCheckMode {
    OFF,          // assignmentIsoCheck = false, dereferencingIsoCheck = false
    ASSIGNMENT,   // assignmentIsoCheck = true, dereferencingIsoCheck = false
    DEREFERENCING,  // assignmentIsoCheck = false, dereferencingIsoCheck = true
    THREAD_BOUNDARY,
    DEREFERENCING_AND_THREAD_BOUNDARY
}
