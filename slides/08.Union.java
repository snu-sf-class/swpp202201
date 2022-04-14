class AUB {
    Boolean isA() { throw ...; }
    op0() { throw ...; }
    op1() { throw ...; }
    op2() { throw ...; }
    op3() { throw ...; }
}

class A extends AUB {
    isA() { return true; }
    op0() { ... };
    op1() { ... };
    op2() { ... };
}

class B extends AUB {
    isA() { return false; }
    op0() { ... };
    op3() { ... };
}

----------------------

interface AUB {
    Boolean isA();
    op0();
    op1();
    op2();
    op3();
}

class A implements AUB {
    isA() { return true; }
    op0() { ... };
    op1() { ... };
    op2() { ... };
    op3() { throw ... };
}

class B implements AUB {
    isA() { return false; }
    op0() { ... };
    op1() { throw ... };
    op2() { throw ... };
    op3() { ... };
}

-------------------------

What is the problem with the above approaches?   

f(AUB u) {
    u.op0();
    u.op1();  // may trigger exception
}

f(AUB u) {
    u.op0();
    // but has to know op1, op2 are available when isA(); also op3 when not isA().
    if (u.isA()) { u.op1(); u.op2(); } 
    else { u.op3(); }
}

-----------------------

interface AUB {
    op0();
    AI getA();
    BI getB();
}

interface AI extends AUB {
    op1();
    op2();
}

interface BI extends AUB {
    op3();
}

class A implements AI {
    AI getA() { return this; }
    BI getB() { return null; }
    op0() { ... };
    op1() { ... };
    op2() { ... };
}

class B implements BI {
    AI getA() { return null; }
    BI getB() { return this; }
    op0() { ... };
    op3() { ... };
}

f(AUB u) {
    AI a;
    BI b;
    u.op0();
    if ((a = u.getA()) != null) {
	a.op1(); a.op2();
    } else if ((b = u.getB()) != null) {
	b.op3();
    } else { throw ...; } // impossible case
}
