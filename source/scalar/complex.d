module scalar.complex;

/// Complex is a template class for complex numbers
struct Complex(size_t nbits, string components = "a, b")
{
    import scalar.decimal : Float;

    alias Real = scalar.decimal.Float!nbits;

    union
    {
        ///
        Real[2] _ = [0, 0];
        mixin(`struct { Real ` ~ components ~ `; }`);
        struct
        {
            ///
            Real re, im;
        }
    }
}
