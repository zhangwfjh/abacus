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

    ///overload operators +=, -=, *=, /= and ^^=
    ref Complex opOpAssign(string op)(Complex other)
    {
        static if (op == "+")
        {
            re = re + other.re;
            im = im + other.im;
        }
        else static if (op == "-")
        {
            re = re - other.re;
            im = im - other.im;
        }
        else static if (op == "*")
        {
            re = re * other.re - im * other.im;
            im = re * other.im + im * other.re;
        }
        else static if (op == "/")
        {
            re = (re * other.re + im * other.im) / other.abs^^2;
            im = (im * other.re - re * other.im) / other.abs^^2;
        }
        else static if (op == "^^")
        {
            ///TODO:
        }

        return this;
    }

    ///overload operators +=, -=, *=, /= and ^^= for decimal
    ref Complex opOpAssign(string op)(Real other)
    {
        return opOpAssign!op(Complex(other, 0));
    }

    ///overload binary operators +,-,*,/ and ^^ for complex on the right
    @safe Complex opBinary(string op)(Complex other) const
    {
        auto res = Complex(this);
        return res.opOpAssign!op(other);
    }

    ///overload binary operators +,-,*,/ and ^^ for decimal on the right
    @safe Complex opBinary(string op)(Real other) const
    {
        auto res = Complex(this);
        return res.opBinary!op(Complex(other, 0));
    }

    ///overload binary operators +,-,*,/ and ^^ for complex on the left
    @safe Complex opBinaryRight(string op)(Complex other) const
    {
        return opBinary!op(other);
    }

    ///overload binary operators +,-,*,/ and ^^ for decimal on the left
    @safe Complex opBinaryRight(string op)(Real other) const
    {
        return opBinaryRight!op(Complex(other, 0));
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
    }

    ///overload the operator == 
    @safe bool opEquals(Complex other) const
    {
        return re == other.re && im == other.im;
    }
}
