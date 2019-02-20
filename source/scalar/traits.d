/++
This module contains the traits of scalar type. 
+/

module scalar.traits;
import std.meta : AliasSeq, anySatisfy;
import std.traits : allSameType;
import scalar;

alias IntegerTypes = AliasSeq!(Integer!8, Integer!16, Integer!32, Integer!64);
alias NaturalTypes = AliasSeq!(Natural!8, Natural!16, Natural!32, Natural!64);
alias FloatTypes = AliasSeq!(Float!16, Float!32, Float!64);
alias RationalTypes = AliasSeq!(Rational!8, Rational!16, Rational!32, Rational!64);
alias ComplexTypes = AliasSeq!(Complex!16, Complex!32, Complex!64);
alias QuaternionTypes = AliasSeq!(Quaternion!16, Quaternion!32, Quaternion!64);

alias ScalarTypes = AliasSeq!(IntegerTypes, NaturalTypes, FloatTypes,
        RationalTypes, ComplexTypes, QuaternionTypes);
alias FieldTypes = AliasSeq!(RationalTypes, FloatTypes, ComplexTypes, QuaternionTypes);

/// Mixin to generate codes to detect whether T is typename type
private mixin template isSomeType(string typename)
{
    mixin(`
    template is` ~ typename ~ `(T)
    {
        enum bool isSameType(S) = allSameType!(T, S);
        enum bool is` ~ typename
            ~ ` = anySatisfy!(isSameType, ` ~ typename ~ `Types);
    }
    `);
}

static foreach (T; ["Integer", "Natural", "Float", "Rational", "Complex",
        "Quaternion", "Scalar", "Field"])
{
    mixin isSomeType!T;
}

@safe unittest
{
    static assert(isScalar!Integer!16);
    static assert(!isScalar!bool);
    static assert(!isField!Integer!16);
    static assert(isField!Rational!16);
}
