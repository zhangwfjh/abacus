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

/// Rational is a template class for rational numbers
struct Rational(size_t nbits)
{
    /// TODO
}
