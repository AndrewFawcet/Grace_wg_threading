package nz.mwh.wg.runtime;

import nz.mwh.wg.runtime.enums.IsoCheckMode;
import nz.mwh.wg.runtime.enums.IsoMoveMode;
import nz.mwh.wg.runtime.enums.LocalCheckMode;

public class CapabilityToggles {
    private static IsoCheckMode isoCheckMode = IsoCheckMode.ASSIGNMENT;
    private static IsoMoveMode isoMoveMode = IsoMoveMode.WRAPPER;
    private static LocalCheckMode localCheckMode = LocalCheckMode.DEREFERENCING;

    public static void setIsoCheckMode(IsoCheckMode mode) {
        isoCheckMode = mode;
    }

    public static void setIsoMoveMode(IsoMoveMode mode) {
        isoMoveMode = mode;
    }

    public static void setLocalCheckMode(LocalCheckMode mode) {
        localCheckMode = mode;
    }

    public static IsoCheckMode getIsoCheckMode() {
        return isoCheckMode;
    }

    public static IsoMoveMode getIsoMoveMode() {
        return isoMoveMode;
    }

    public static LocalCheckMode getLocalCheckMode() {
        return localCheckMode;
    }

    // Iso Checks
    public static boolean isAssignmentIsoCheckEnabled() {
        return isoCheckMode == IsoCheckMode.ASSIGNMENT;
    }

    public static boolean isDereferencingIsoCheckEnabled() {
        return isoCheckMode == IsoCheckMode.DEREFERENCING;
    }

    // Iso Move Checks
    public static boolean isUsingIsoWrapper() {
        return isoMoveMode == IsoMoveMode.WRAPPER;
    }

    public static boolean isAutoUnlinkingIsoMoves() {
        return isoMoveMode == IsoMoveMode.AUTO_UNLINK;
    }

    // Local Checks
    public static boolean isThreadBoundaryLocalChecking() {
        return localCheckMode == LocalCheckMode.THREAD_BOUNDARY ||
               localCheckMode == LocalCheckMode.THREAD_AND_DEREFERENCING;
    }

    public static boolean isDereferencingLocalCheckEnabled() {
        return localCheckMode == LocalCheckMode.DEREFERENCING ||
               localCheckMode == LocalCheckMode.THREAD_AND_DEREFERENCING;
    }

    // vanilla Dala
    public static void resetDefaults() {
        isoCheckMode = IsoCheckMode.ASSIGNMENT;
        isoMoveMode = IsoMoveMode.OFF;
        localCheckMode = LocalCheckMode.DEREFERENCING;
    }

    public static void printCurrentSettings() {
        System.out.println("===== Capability Toggles =====");
        System.out.println("Iso Check Mode: " + isoCheckMode);
        System.out.println("Iso Move Mode: " + isoMoveMode);
        System.out.println("Local Check Mode: " + localCheckMode);
        System.out.println("=============================");
    }
}
