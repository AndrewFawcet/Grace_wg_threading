print "Banking test start-------------------------------------------------------------------"
print "Hello beautiful bank-----------------------------------------------------------------"

print "Grace Example Start------------------------------------------------"

// Immutable (IMM) object
var myImmutable := object is imm {
    var immVar := "I am immutable"
    method getImmVar -> String {
        immVar
    }
}

// Local (LOC) object
var myLocal := object is loc {
    var locVar := 42
    method getLocVar -> Number {
        locVar
    }
    method updateLocVar(newValue: Number) {
        locVar := newValue
    }
}

// Isolated (ISO) object
var myIsolated := object is iso {
    var isoVar := 100
    method getIsoVar -> Number {
        isoVar
    }
    method updateIsoVar(newValue: Number) {
        isoVar := newValue
    }
}

// Main program
print "Immutable variable: {myImmutable.getImmVar}"
print "Local variable before update: {myLocal.getLocVar}"
myLocal.updateLocVar(84)
print "Local variable after update: {myLocal.getLocVar}"
print "Isolated variable before update: {myIsolated.getIsoVar}"
myIsolated.updateIsoVar(200)
print "Isolated variable after update: {myIsolated.getIsoVar}"

print "Grace Example End--------------------------------------------------"
