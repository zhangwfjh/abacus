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

    ///Constructor
    @safe @nogc pure nothrow this(Real _re, Real _im = 0)
    {
        re = _re;
        im = _im;
    }

    ///return the string "a+bi" or "a-bi" or only "a" when b is zero
    @safe string toString() const
    {
        if (im > 0)
        {
            return format!("%s+%si")(re, im);
        }
        else if (im < 0)
        {
            return format!("%s%si")(re, im);
        }
        else
        {
            return format!("%s")(re);
        }
    }

    ///calculate the square of absolute value of complex
    @safe pure Real abs2() const @property
    {
        return re^^2 + im^^2;
    }

    ///calculate the absolute value of complex
    @safe pure Real abs() const @property
    {
        return sqrt(this.abs2());
    }

    

    ///return the conjugate complex
    @safe pure Complex conjugate() const @property
    {
        return Complex(re, -im);
    }

    ///return the multiplicative inverse of complex
    @safe pure Complex inverse() const @property
    {
        return Complex(re / (re^^2 + im^^2), -im / (re^^2 + im^^2));
    }

    ///overload operator =, and ref Complex opAssign(Complex other) is also available
    ref Complex opAssign(Real other)
    {
        re = other;
        im = 0;
        return this;
    }

    ///overload binary operators +,-,*,/ and ^^
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

    ///overload unary operators +,- and ~
    @safe Complex opUnary(string op)() const
    {
        static if (op == "+")
            return Complex(re, im);
        else static if (op == "-")
            return Complex(-re, -im);
        else static if (op == "~")
            return this.conjugate;
        else
            static assert(false, "The type is not supported");
    }

    ///overload the operator == 
    @safe bool opEquals(Complex other) const
    {
        return re == other.re && im == other.im;
    }
}