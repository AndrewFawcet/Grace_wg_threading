package nz.mwh.wg.runtime.enums;

public enum IsoMoveMode {
    OFF,          // isoWrapper = false, autoUnlinkingIsoMoves = false
    WRAPPER,      // isoWrapper = true, autoUnlinkingIsoMoves = false
    AUTO_UNLINK,   // isoWrapper = false, autoUnlinkingIsoMoves = true
    LATEST_REFERENCE_ONLY_DEREFERENCING // not fully implemented
}
