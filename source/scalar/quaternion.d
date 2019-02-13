module scalar.quaternion;

/++
Quaternion is a template class for quaternion numbers.

Params:
nbits : the number of bits for each real component
components: the name of each component
+/
struct Quaternion(size_t nbits, string components = "a, b, c, d")
{
    static if (nbits == 16)
        alias Real = float;
    else static if (nbits == 32)
        alias Real = double;
    else static if (nbits == 64)
        alias Real = real;
    else
        static assert(false, "The type is not supported");

    union
    {
        ///
        Real[4] _ = [0, 0, 0, 0];
        mixin(`struct { Real ` ~ components ~ `; }`);
    }

    ///
    @safe @nogc pure nothrow this(Real _0, Real _1, Real _2, Real _3)
    {
        static foreach (i; 0 .. 4)
        {
            mixin(`_[` ~ i.stringof ~ `] = _` ~ i.stringof ~ `;`);
        }
    }

    ///
    @safe string toString() const
    {
        return _[0].stringof ~ `+` ~ _[1].stringof ~ `i+` ~ _[2].stringof ~ `j+`
            ~ _[3].stringof ~ `k`;
    }

    @safe pure nothrow unittest
    {
        auto quat = Quaternion!(32, "x, y, z, w")(1, 0, 0, 0);
        assert(quat.x == 1);
    }
}
