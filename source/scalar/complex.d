module scalar.complex;

import std.math : sqrt;
import std.format;

/++
Complex is a template class for complex numbers.

Params:
nbits : the number of bits for each real component
+/
struct Complex(size_t nbits) 
{
    static if (nbits == 16)
        alias Real = float;
    else static if (nbits == 32)
        alias Real = double;
    else static if (nbits == 64)
        alias Real = real;
    else
        static assert(false, "The type is not supported");

    Real re, im;

    @safe @nogc pure nothrow this(Real _re, Real _im)
    {
        re = _re;
        im = _im;
    }

    @safe string toString() const
    {
        return format!("%s+(%si)")(re, im);
    }

    @safe pure Real abs() const @property
    {
        return sqrt(re^^2 + im^^2);
    }

    @safe pure Complex conjugate() const @property
    {
        return Complex(re, -im);
    }

    @safe pure Complex inverse() const @property
    {
        if (re != 0 || im != 0)
            return Complex(re / (re^^2 + im^^2), -im / (re^^2 + im^^2));
        else
            assert(false, "The zero value doesn't have inverse");
    }

    @safe Complex opBinary(string op)(Complex other) const
    {
        if (op == "+")
            return Complex(re + other.re, im + other.im);
        else if (op == "-")
            return Complex(re - other.re, im - other.im);
        else if (op == "*")
            return Complex(re * other.re - im * other.im, re * other.im + im * other.re);
        else if (op == "/")
            return Complex((re * other.re + im * other.im) / other.abs^^2, (im * other.re - re * other.im) / other.abs^^2);
        else
            assert(false, "The type is not supported");
    }

    @safe Complex opUnary(string op)()
    {
        if (op == "+")
            return this;
        else if (op == "-")
            return Complex(-re, -im);
        else if (op == "~")
            return this.conjugate;
        else
            assert(false, "The type is not supported");
    }

    @safe bool equal(Complex other) const
    {
        return re == other.re && im == other.im;
    }

    @safe bool equal(Real other) const
    {
        return re == other && im == 0;
    }

    @safe Real distance(Complex other) const
    {
        return (this - other).abs;
    }
}