module scalar.decimal;

/// Float is a wrapper template class for float numbers
template Float(size_t nbits)
{
    static if (nbits == 16)
        alias Float = float;
    else static if (nbits == 32)
        alias Float = double;
    else static if (nbits == 64)
        alias Float = real;
    else
        static assert(false, "The type is not supported");
}

import std.typecons;
import std.math;

/// Rational is a template class for rational numbers
struct Rational(size_t nbits)
{
    long num;
    long den;

    this(long n, long d = 1)
    {
        num = n;
        den = d;
    }

    @safe string toString() const
    {
        import std.format;
        return format!"%s/%s"(num, den);
    }

    @safe pure long gcd(long a, long b) const
    {
        if (b==0)
            return a;

        return gcd (b,a%b);
    }
    @safe pure long lcm(long a, long b) const
    {
        return a/gcd(a,b)*b;
    }

    ref Rational opAssign (long n)
    {
        num = n;
        den = 1;

        return this;
    }

    bool opEquals (long n) const
    {
        return n == num && den == 1;
    }

    bool opEquals (Rational other) const
    {
        return other.num == num && other.den == den;
    }

    Rational opUnary (string op)() const 
    {
        static if (op == "+")
            return Rational (num,den);
        else static if (op == "-")
            return Ratioanl (-num,-den);
        else static if (op == "~")
            return Rational (den,num);
    }
    
    ref Rational opOpAssign (string op)(Ratioanl other)
    {
        static if (op == "+" || op == "-")
        {
            long llcm = lcm(den, other.den);
            num *= (llcm / den);
            other.num *= (llcm / other.den);
            mixin("num"~op~"=other.num");
            long lgcd = gcd(num, llcm);
            num /= lgcd;
            den = llcm / lgcd;
            return this;
        }
        else static if (op == "*")
        {
            long lgcd = gcd(num,other.den);
            long llgcd = gcd(other.num,den);
            num /= lgcd;
            other.den /= lgcd;
            den /= llgcd;
            other.num /= llgcd;
            num *= other.num;
            den *= other.den;
            return this;
        }
        else static if (op == "/")
        {
            long lgcd = gcd (num,other.num);
            long llgcd = gcd (den,other.den);
            num /= lgcd;
            other.num /= lgcd;
            den /= llgcd;
            other.den /= llgcd;
            num *= other.den;
            den *= other.num;
            return this;
        }
    }
    Rational opBinary(string op)(Rational other) const
    {
            auto res = Rational (this);
            return res.opOpAssign!op (other);
            
    }
}