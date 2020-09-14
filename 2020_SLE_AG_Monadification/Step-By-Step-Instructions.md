
## Background


### Monads

Our examples will use two monads, `Maybe` and `Either`.

The `Maybe<T>` monad represents potential failure.  It has two
constructors:
```
just : T -> Maybe<T>
nothing : Maybe<T>
```
The `just` constructor holds a value, representing a success, and
`nothing` represents a failure.

The `Either<S T>` monad also represents potential failure with two
constructors:
```
right : T -> Either<S T>
left : S -> Either<S T>
```
The `right` constructor holds a value, representing a success, and
`left` holds some sort of error message for a failure.  For example,
Either<String T> would contain a descriptive error message, while
Either<Int T> would contain an error code.





## Example:  Calculator

In the directory for examples, we have an example named `calculator`.
Enter the directory for this example:
```
cd calculator
```
This example implements a simple calculator with addition,
subtraction, multiplication, and division.  Look at the `Abstract.sv`
file in your preferred editor.

In our calculator, we have three attributes, `pp`, `imp_value`, and
`value`.  The `pp` attribute simply builds a string showing the
current expression.  The interesting attributes are `imp_value` and
`value`, both of which have the type `Maybe<Float>` to represent
potential failure.  These both compute the value of the expression,
but `imp_value` is an implicit attribute, which uses implicit
equations, and `value` uses standard equations.

The simplest example of the benefits of monadification can be seen in
the `num` production on line 32, where the value from evaluation is
simply the number.  On line 37, we have the implicit
equation for `top.imp_value`, and on line 39, we have the equation for
`top.value`.  On line 39, we give the value `just(n)` because we need
the expression to have type `Maybe<Float>`.  On line 37, in the
implicit equation, we can simply have the expression `n`, ignoring the
`Maybe` monad representing potential failure since there is no
potential failure here.

To see more complex uses, let's examine the equations for `imp_value`
and `value` in the `plus` production on line 42.  The equation for
`top.value` on line 49 uses `case` to test whether the addends
evaluated to values or not (`t1.value` and `t2.value` are `just`s),
then add the values if they were values or give a failure (give a
`nothing`).  The implicit equation for `top.imp_value` on line 47
simply adds together the `imp_value` attributes of the addends, making
the intention of the equation clearer.  These two equations will end
up evaluating the same way, but the implicit one is easier to write
and easier to read.

The `minus` and `mult` productions are similar to the `plus`
production.  The `div` production (line 81) has equations which show
more benefits of monadification.  Division should successfully
evaluate only if the divisor is non-zero.  On line 86, in the implicit
equation for `top.imp_value` we check if the divisor's value
(`t2.imp_value`) is non-zero and then carry out the division.  We
don't need to write out the error cases in impliict equations, since
the monadification will fill them in.  The equation for `top.value` on
line 89 needs to unwrap the values as in the `plus` production, but it
then also needs to check that the divisor is non-zero, including the
monadic failure `nothing()` for when the divisor is zero.

To try using the calculator, run
```
./silver-compile
```
to compile this example, then run
```
./run
```
to get a REPL for the calculator.  When you give it an example, enter
the expression you want to evaluate.  For example, entering `3 + 4`
will give you the following:
```
Enter an expression:  3 + 4
Expression:  (3.0) + (4.0)
Value:  7.0
Implicit Value:  7.0
```
This prints out the expression entered using the `pp` attribute, then
prints out the values of the `value` and `imp_value` attributes.  If
the value is `just(x)`, it will output `x`; if the value is
`nothing()`, it will output `no value`.  Some possible examples to
try:
```
3 + 8 - 24
3 / 0
(4 / 0) + 3
```
We can see that the `imp_value` and `value` attributes will both
always have the same value, but, as we saw in the source code, the
implicit equations for `imp_value` are much simpler to read and write
than the standard equations for `value`.

