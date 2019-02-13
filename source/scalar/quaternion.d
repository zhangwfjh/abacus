module scalar.quaternion;

/++
Quaternion is a template class for quaternion numbers.

Params:
nbits : the number of bits for each real component
components: the name of each component
+/
struct Quaternion(size_t nbits, string components = "a, b, c, d")
{
    import scalar.decimal : Float;

    alias Real = scalar.decimal.Float!nbits;

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

        // TODO
        return format!"%s+%si+%sj+%sk"(_[0], _[1], _[2], _[3]);
    }

@safe @nogc pure nothrow:

    // Constructors
    ///
    this(Real _0)
    {
        _[0] = _0;
    }

    ///
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

    /// this = quaternion
    ref Quaternion opAssign(Quaternion q)
    {
        _[] = q._[];
        return this;
    }

    // Equality comparison
    /// this = real
    bool opEquals(Real r) const
    {
        return _[0] == r && _[1] == 0 && _[2] == 0 && _[3] == 0;
    }

    /// this = quaternion
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
    ///
    ref Quaternion opOpAssign(string op)(Quaternion q) if (op == "+" || op == "-")
    {
        mixin(`_[] ` ~ op ~ `= q._[];`);
        return this;
    }

    ///
    ref Quaternion opOpAssign(string op)(Quaternion q) if (op == "*")
    {
        _[0] = _[0] * q._[0] - _[1] * q._[1] - _[2] * q._[2] - _[3] * q._[3];
        _[1] = _[0] * q._[1] + _[1] * q._[0] + _[2] * q._[3] - _[3] * q._[2];
        _[2] = _[0] * q._[2] + _[2] * q._[0] + _[3] * q._[1] - _[1] * q._[3];
        _[3] = _[0] * q._[3] + _[3] * q._[0] + _[1] * q._[2] - _[2] * q._[1];
        return this;
    }

    ///
    ref Quaternion opOpAssign(string op)(Quaternion q) if (op == "/")
    {
        return this *= inverse;
    }

    ///
    ref Quaternion opOpAssign(string op)(Quaternion q) if (op == "^^")
    {
        /// BAD
        return this;
    }

    ///
    ref Quaternion opOpAssign(string op)(Real r) if (op == "*" || op == "/")
    {
        mixin(`_[] ` ~ op ~ `= r;`);
        return this;
    }

    ///
    ref Quaternion opOpAssign(string op)(Real r) if (op == "^^")
    {
        /// BAD
        return this;
    }

    ///
    Quaternion opBinary(string op)(Quaternion q) const
    {
        auto res = Quaternion(this);
        return res.opOpAssign!op(q);
    }

    ///
    Quaternion opBinary(string op)(Real r) const
    {
        auto res = Quaternion(this);
        return res.opOpAssign!op(r);
    }

    ///
    Quaternion opBinaryRight(string op)(Real r) const if (op == "+" || op == "*")
    {
        return opBinary!op(r);
    }

    ///
    Quaternion opBinaryRight(string op)(Real r) const if (op == "-")
    {
        return Quaternion(r - _[0], -_[1], -_[2], -_[3]);
    }

    ///
    Quaternion opBinaryRight(string op)(Real r) const if (op == "/")
    {
        return inverse * r;
    }

    ///
    Quaternion opBinaryRight(string op)(Real r) const if (op == "^^")
    {
        // BAD
        return Quaternion();
    }

    // Operations
    ///
    @property Real mod2() const
    {
        return _[0] * _[0] + _[1] * _[1] + _[2] * _[2] + _[3] * _[3];
    }

    ///
    @property Real mod() const
    {
        import std.math : sqrt;

        return sqrt(mod2);
    }

    ///
    @property Quaternion conjugate() const
    {
        return Quaternion(_[0], -_[1], -_[2], -_[3]);
    }

    ///
    @property Quaternion inverse() const
    {
        return conjugate /= mod2;
    }

    @safe pure nothrow unittest
    {
        auto quat = Quaternion!(32, "x, y, z, w")(1, 0, 0, 0);

        assert(quat.x == 1);
        // TODO
    }
}
