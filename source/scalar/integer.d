module scalar.integer;

/// Integer is a wrapper template class for integers
template Integer(size_t nbits)
{
    static if (nbits == 8)
        alias Integer = byte;
    else static if (nbits == 16)
        alias Integer = short;
    else static if (nbits == 32)
        alias Integer = int;
    else static if (nbits == 64)
        alias Integer = long;
    else
        static assert(false, "The type is not supported");
}

/// Natural is a wrapper template class for natural number
template Natural(size_t nbits)
{
    static if (nbits == 8)
        alias Natural = ubyte;
    else static if (nbits == 16)
        alias Natural = ushort;
    else static if (nbits == 32)
        alias Natural = uint;
    else static if (nbits == 64)
        alias Natural = ulong;
    else
        static assert(false, "The type is not supported");
}
