package nz.mwh.wg.ast;

import nz.mwh.wg.runtime.GraceObject;

public class ReturnException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    private GraceObject value;
    public GraceObject context;

    public ReturnException(GraceObject context, GraceObject value) {
        this.context = context;
        this.value = value;
    }

    public GraceObject getValue() {
        return value;
    }
}
