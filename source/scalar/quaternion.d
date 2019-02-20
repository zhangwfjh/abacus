module scalar.quaternion;

import std.typecons;

/++
Quaternion is a template class for quaternion numbers.

Params:
nbits : the number of bits for each real component
components: the name of each component
+/
struct Quaternion(size_t nbits, string components = "a, b, c, d")
{
    import scalar.decimal : Float;

    alias Real = Float!nbits;

    union
    {
        ///
        Real[4] _ = [0, 0, 0, 0];
        mixin(`struct { Real ` ~ components ~ `; }`);
    }

    ///
    @safe string toString() const
    {
        import std.format : format;

        // FIXME: Improve readability
        return format!"%s+%si+%sj+%sk"(_[0], _[1], _[2], _[3]);
    }

@safe @nogc pure nothrow:

    // Constructors
    /// this(real)
    this(Real _0)
    {
        _[0] = _0;
    }

    /// this(quaternion)
    this(Real _0, Real _1, Real _2, Real _3)
    {
        _[0] = _0;
        _[1] = _1;
        _[2] = _2;
        _[3] = _3;
    }

    // Assignment
    /// this = real
    ref Quaternion opAssign(Real r)
    {
        _[0] = r;
        _[1] = 0;
        _[2] = 0;
        _[3] = 0;
        return this;
    }

    // Equality comparison
    /// this == real
    bool opEquals(Real r) const
    {
        return _[0] == r && _[1] == 0 && _[2] == 0 && _[3] == 0;
    }

    /// this == quaternion
    bool opEquals(Quaternion q) const
    {
        return _[] == q._[];
    }

    // Unary operators
    /// +quaternion
    Quaternion opUnary(string op)() const if (op == "+")
    {
        return this;
    }

    /// -quaternion
    Quaternion opUnary(string op)() const if (op == "-")
    {
        return Quaternion(-_[0], -_[1], -_[2], -_[3]);
    }

    // Binary operators
    /// += -= quaternion
    ref Quaternion opOpAssign(string op)(Quaternion q) if (op == "+" || op == "-")
    {
        mixin(`_[] ` ~ op ~ `= q._[];`);
        return this;
    }

    /// *= quaternion
    ref Quaternion opOpAssign(string op)(Quaternion q) if (op == "*")
    {
        _[0] = _[0] * q._[0] - _[1] * q._[1] - _[2] * q._[2] - _[3] * q._[3];
        _[1] = _[0] * q._[1] + _[1] * q._[0] + _[2] * q._[3] - _[3] * q._[2];
        _[2] = _[0] * q._[2] + _[2] * q._[0] + _[3] * q._[1] - _[1] * q._[3];
        _[3] = _[0] * q._[3] + _[3] * q._[0] + _[1] * q._[2] - _[2] * q._[1];
        return this;
    }

    /// /= quaternion
    ref Quaternion opOpAssign(string op)(Quaternion q) if (op == "/")
    {
        immutable qInvMod2 = 1 / q.mod2;
        _[0] = (_[0] * q._[0] + _[1] * q._[1] + _[2] * q._[2] + _[3] * q._[3]) * qInvMod2;
        _[1] = (-_[0] * q._[1] + _[1] * q._[0] - _[2] * q._[3] + _[3] * q._[2]) * qInvMod2;
        _[2] = (-_[0] * q._[2] + _[2] * q._[0] - _[3] * q._[1] + _[1] * q._[3]) * qInvMod2;
        _[3] = (-_[0] * q._[3] + _[3] * q._[0] - _[1] * q._[2] + _[2] * q._[1]) * qInvMod2;
        return this;
    }

    /// ^^= quaternion
    ref Quaternion opOpAssign(string op)(Quaternion q) if (op == "^^")
    {
        /// TODO:
        return this;
    }

    /// *= /= real
    ref Quaternion opOpAssign(string op)(Real r) if (op == "*" || op == "/")
    {
        mixin(`_[] ` ~ op ~ `= r;`);
        return this;
    }

    /// ^^= real
    ref Quaternion opOpAssign(string op)(Real r) if (op == "^^")
    {
        /// TODO:
        return this;
    }

    /// quaternion + - * / ^^ quaternion
    Quaternion opBinary(string op)(Quaternion q) const
    {
        auto res = Quaternion(this);
        return res.opOpAssign!op(q);
    }

    /// quaternion + - * / ^^ real
    Quaternion opBinary(string op)(Real r) const
    {
        auto res = Quaternion(this);
        return res.opOpAssign!op(r);
    }

    /// real + * quaternion
    Quaternion opBinaryRight(string op)(Real r) const if (op == "+" || op == "*")
    {
        return opBinary!op(r);
    }

    /// real - quaternion
    Quaternion opBinaryRight(string op)(Real r) const if (op == "-")
    {
        return Quaternion(r - _[0], -_[1], -_[2], -_[3]);
    }

    /// real / quaternion
    Quaternion opBinaryRight(string op)(Real r) const if (op == "/")
    {
        return inverse * r;
    }

    /// real ^^ quaternion
    Quaternion opBinaryRight(string op)(Real r) const if (op == "^^")
    {
        // TODO:
        return Quaternion();
    }

    // Properties
@property:
    /// scalar part
    Real scalar() const
    {
        return _[0];
    }

    /// vector part
    Tuple!(const Real, const Real, const Real) vector() const
    {
        return tuple(_[1], _[2], _[3]);
    }

    /// mod2
    Real mod2() const
    {
        return _[0] * _[0] + _[1] * _[1] + _[2] * _[2] + _[3] * _[3];
    }

    /// mod
    Real mod() const
    {
        import std.math : sqrt;

        return sqrt(mod2);
    }

    /// conjugate
    Quaternion conjugate() const
    {
        return Quaternion(_[0], -_[1], -_[2], -_[3]);
    }

    /// inverse
    Quaternion inverse() const
    {
        return conjugate /= mod2;
    }

    @safe pure nothrow unittest
    {
        // TODO:
    }
}
