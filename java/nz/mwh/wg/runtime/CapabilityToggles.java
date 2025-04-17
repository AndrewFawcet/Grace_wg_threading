package nz.mwh.wg.runtime;

import nz.mwh.wg.runtime.enums.IsoCheckMode;
import nz.mwh.wg.runtime.enums.IsoMoveMode;
import nz.mwh.wg.runtime.enums.LocalCheckMode;

public class CapabilityToggles {
    private static IsoCheckMode isoCheckMode = IsoCheckMode.ASSIGNMENT;
    private static IsoMoveMode isoMoveMode = IsoMoveMode.OFF;
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
        return isoCheckMode == IsoCheckMode.DEREFERENCING ||
                isoCheckMode == IsoCheckMode.DEREFERENCING_AND_THREAD_BOUNDARY;
    }

    public static boolean isThreadBoundaryIsoCheckEnabled() {
        return isoCheckMode == IsoCheckMode.THREAD_BOUNDARY ||
                isoCheckMode == IsoCheckMode.DEREFERENCING_AND_THREAD_BOUNDARY;
    }

    public static boolean isLatestIsoReferenceOnlyDereferencing() {
        return isoCheckMode == IsoCheckMode.LATEST_REFERENCE_ONLY_DEREFERENCING;
    }

    // Iso Move Checks
    public static boolean isUsingIsoWrapper() {
        return isoMoveMode == IsoMoveMode.WRAPPER;
    }

    public static boolean isAutoUnlinkingIsoMoves() {
        return isoMoveMode == IsoMoveMode.AUTO_UNLINK;
    }

    // Local Checks
    public static boolean isThreadBoundaryLocalCheckingEnabled() {
        return localCheckMode == LocalCheckMode.THREAD_BOUNDARY ||
                localCheckMode == LocalCheckMode.DEREFERENCING_AND_THREAD_BOUNDARY;
    }

    public static boolean isDereferencingLocalCheckEnabled() {
        return localCheckMode == LocalCheckMode.DEREFERENCING ||
                localCheckMode == LocalCheckMode.DEREFERENCING_AND_THREAD_BOUNDARY;
    }

    // vanilla Dala
    public static void resetDefaults() {
        isoCheckMode = IsoCheckMode.ASSIGNMENT;
        isoMoveMode = IsoMoveMode.OFF;
        localCheckMode = LocalCheckMode.DEREFERENCING;
    }

    public static void printCurrentSettings() {
        // System.out.println("===== Capability Toggles =====");
        // System.out.println("Iso Check Mode: " + isoCheckMode);
        // System.out.println("Iso Move Mode: " + isoMoveMode);
        // System.out.println("Local Check Mode: " + localCheckMode);
        // System.out.println("=============================");

        // need a bigger print out as there could be more than one Iso Check or Local
        // check
        System.out.println("===== Capability Toggles =====");
        System.out.println("Iso Check Mode: " + isoCheckMode);
        System.out.println("  - Assignment Check: " + isAssignmentIsoCheckEnabled());
        System.out.println("  - Dereferencing Check: " + isDereferencingIsoCheckEnabled());
        System.out.println("  - Thread Boundary Check: " + isThreadBoundaryIsoCheckEnabled());
        System.out.println("  - Latest Iso Only Dereferencing Check: " + isLatestIsoReferenceOnlyDereferencing());
        System.out.println("Iso Move Mode: " + isoMoveMode);
        System.out.println("  - Using Iso Wrapper: " + isUsingIsoWrapper());
        System.out.println("  - Auto-Unlink Moves: " + isAutoUnlinkingIsoMoves());
        System.out.println("Local Check Mode: " + localCheckMode);
        System.out.println("  - Thread Boundary Check: " + isThreadBoundaryLocalCheckingEnabled());
        System.out.println("  - Dereferencing Check: " + isDereferencingLocalCheckEnabled());
        System.out.println("=============================");
    }
}
