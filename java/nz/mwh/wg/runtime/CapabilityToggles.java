package nz.mwh.wg.runtime;

import nz.mwh.wg.runtime.enums.IsoCheckMode;
import nz.mwh.wg.runtime.enums.IsoMoveMode;
import nz.mwh.wg.runtime.enums.LocalCheckMode;

public class CapabilityToggles {
    private static IsoCheckMode isoCheckMode = IsoCheckMode.DEREFERENCING;
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

    public static void resetDefaults() {
        isoCheckMode = IsoCheckMode.DEREFERENCING;
        isoMoveMode = IsoMoveMode.OFF;
        localCheckMode = LocalCheckMode.DEREFERENCING;
    }
}
