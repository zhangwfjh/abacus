module scalar.complex;

import scalar.decimal : Float;
import std.math : sqrt;
import std.format;

/++
Complex is a template class for complex numbers.

Params:
nbits : the number of bits for each real component
+/
struct Complex(size_t nbits) 
{
    alias Real = scalar.decimal.Float!nbits;
    Real re, im;

    @safe @nogc pure nothrow this(Real _re, Real _im = 0)
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
        return Complex(re / (re^^2 + im^^2), -im / (re^^2 + im^^2));
    }

    ref Complex opAssign(Real other)
    {
        re = other;
        im = 0;
        return this;
    }

    ref Complex opAssign(Complex other)
    {
        re = other.re;
        im = other.im;
        return this;
    }

    @safe Complex opBinary(string op)(Complex other) const
    {
        static if (op == "+")
            return Complex(re + other.re, im + other.im);
        else static if (op == "-")
            return Complex(re - other.re, im - other.im);
        else static if (op == "*")
            return Complex(re * other.re - im * other.im, re * other.im + im * other.re);
        else static if (op == "/")
            return Complex((re * other.re + im * other.im) / other.abs^^2, (im * other.re - re * other.im) / other.abs^^2);
        else static if (op == "^^")
            ///TODO
        else
            static assert(false, "The type is not supported");
    }

    @safe Complex opUnary(string op)() const
    {
        static if (op == "+")
            return this;
        else static if (op == "-")
            return Complex(-re, -im);
        else static if (op == "~")
            return this.conjugate;
        else
            static assert(false, "The type is not supported");
    }

    @safe bool opEquals(Complex other) const
    {
        return re == other.re && im == other.im;
    }

    @safe Real distance(Complex other) const
    {
        return (this - other).abs;
    }
}