package nz.mwh.wg.ast.grace;

import nz.mwh.wg.runtime.GraceDone;
import nz.mwh.wg.runtime.GraceObject;
import nz.mwh.wg.runtime.Request;

public class Wrapper implements GraceObject {
    private Object value;

    Wrapper(Object value) {
        this.value = value;
    }

    public Object getValue() {
        return value;
    }

    @Override
    public GraceObject request(Request request) {
        return GraceDone.done;
    }

    @Override
    public GraceObject findReceiver(String name) {
        return null;
    }

}


