package nz.mwh.wg.runtime;

import java.util.UUID;

public class Scope {
    private final String id;
    private final Scope parent;

    public Scope(Scope parent) {
        this.id = UUID.randomUUID().toString(); // Unique identifier for the scope
        this.parent = parent;
    }

    public Scope getParent() {
        return parent;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Scope scope = (Scope) obj;
        return id.equals(scope.id);
    }

    @Override
    public int hashCode() {
        return id.hashCode();
    }
}