/++
This module contains several scalar types, including:
- Natural numbers
- Integers
- Rational numbers
- Real numbers
- Complex numbers
- Quaternion numbers
+/

module scalar;

public import scalar.integer;
public import scalar.decimal;
public import scalar.complex;
public import scalar.quaternion;

/// default number of bits for integers
private enum intbits = 32;
/// default number of bits for decimals
private enum fltbits = 64;

alias Int = scalar.integer.Integer!intbits;
alias Nat = scalar.integer.Natural!intbits;
alias Real = scalar.decimal.Float!fltbits;
alias Rat = scalar.decimal.Rational!intbits;
alias Comp = scalar.complex.Complex!fltbits;
alias Quat = scalar.quaternion.Quaternion!fltbits;
