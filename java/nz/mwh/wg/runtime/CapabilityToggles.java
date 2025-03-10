package nz.mwh.wg.runtime;

public class CapabilityToggles {
    public static boolean isoWrapper = false;
    public static boolean autoUnlinkingIsoMoves = false;
    public static boolean assignmentIsoCheck = false; // vanilla Dala
    public static boolean dereferencingIsoCheck = true;
    public static boolean threadBoundaryLocalChecking = false;
    public static boolean dereferencingLocalCheck = true; // vanilla Dala

    public static void resetDefaults() {
        isoWrapper = false;
        autoUnlinkingIsoMoves = false;
        assignmentIsoCheck = false;
        dereferencingIsoCheck = true;
        threadBoundaryLocalChecking = false;
        dereferencingLocalCheck = true;
    }

}
