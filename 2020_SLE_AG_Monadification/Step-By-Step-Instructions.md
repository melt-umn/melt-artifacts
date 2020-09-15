
## Monads

Our examples will use two monads implicitly for our monadification,
`Maybe` and `Either`.

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
subtraction, multiplication, and division.  Please open the
`Abstract.sv` file in your preferred editor.

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





## Example:  Simply-Typed Lambda Calculus with Booleans

In the directory for examples, we have an example named `stlc`.  Enter
the directory for this example:
```
cd stlc
```
This example implements typing and evaluation for the simply-typed
lambda calculus with Booleans.  This grammar can be compiled by
running
```
./silver-compile
```
and can be run on examples with the `run` script:
```
./run
```
This will give a prompt, `Enter an expression:`.  The following
example expressions show the syntax of the language:
```
lambda x:Bool. x
true && false
true || true
(lambda x:Bool. x) true
```
The precedence is as expected.

Please open the `Abstract.sv` file in your preferred editor.


### Typing

We have three attributes associated with typing, `gamma`, which
represents the typing context; `typ`, which represents the type of an
expression; and `errors`, a list of type errors.

The `typ` attribute is an implicit attribute, meaning its equations
may take advantage of our monadification process to use monads
implicitly.  As in the `calculator` example above, this means we can
use values without unwrapping them, as we see in the equation for
`typ` in the `abs` production on line 87.  Here `body.typ` is used
implicitly to build the function type for the abstraction.

The type of this attribute is `Either<String Type>`, which allows us
to give an error message in the case an expression is not typable.
For example, in the `app` production, the equation for `typ` (line
112) checks that the prospective function has a function type and that
the argument's type matches the expected argument type.  If one of
these is not true, we give an appropriate error message in the monadic
failure constructor for `Either`, `left`.  For example, if the
argument types do not match, we give `left("Application type
mismatch")`.

By using `Either` implicitly, the errors from the subexpressions are
passed up the abstract syntax tree automatically.  For example, in the
equation for `typ` (line 87) in the `abs` production, if `body.typ`
has the value `left(s)` for some error message `s`, the value of
`top.typ` will also be `left(s)`.

We can use the error messages we generate in the `typ` attribute to
produce a list of type errors in the unrestricted `errors` attribute.
We do this by matching on the value of the `typ` attribute, taking the
error message out of it if it is a `left`.  Because the error messages
of the subexpressions will be passed through the `typ` equation, we
take care to avoid replicating the same error message many times in
the list of errors.  We do this by matching on `left` and `right`
(line 117) to check that the error message is new and is not simply
passed up from the subexpressions.

In implicit equations, we are not able to do case analysis on the
constructors of the monad of the attribute being defined.  For
example, the `typ` attribute cannot match on the `left` and `right`
constructors because `Either` is the `typ` attribute uses the `Either`
monad.  We are able to match on them in equations for the `errors`
attribute because it is an unrestricted attribute.  In equations for
`typ`, however, we can match on any other type, even if that type is a
different monad.  In the `var` production, the equation for `typ`
(line 62) uses a function `lookupType`, returning a value of type
`Maybe<Type>` to find the type of an attribute if it is a known
variable.  We match on the `just` and `nothing` constructors to turn
this `Maybe` into an `Either`.


### Evaluation

We define single-step evaluation using the `nextStep` attribute.  This
is an implicit attribute making use of the `Maybe` monad to represent
potential failure of evaluation.  Because this attribute doesn't
interact with the `typ` attribute, we can use different monads for
them.  If they did interact, they would need to have the same monad.

Some constructs, such as abstractions, cannot take a step of
evaluation.  Monadification provides empty equations for situations
such as this, as seen on line 101.  The empty equation shows that
there is no value which can be assigned to the `nextStep` attribute
for abstractions.  The monadification procedure will rewrite this to
produce a monadic failure (i.e. `nothing`) for the attribute value
instead.  Not requiring an expression to be written here fits in with
not requiring failure cases to be written, as we saw with the
`calculator` grammar above.


### Examples

When running an example, with the provided `run` script, we get
something like the following:
```
Enter an expression:  (lambda x:Bool. x) true
Expression:  (lambda x:Bool. x) (true)
Type:        Bool
Errors:      
SingleSteps Attribute (Evaluation Trace):
   [,  (lambda x:Bool.x) (true),  true]
```
As with the `calculator` grammar, we print out the original
expression; this shows how the entered text was parsed.  The `Type`
line outputs the type of the expression or a type error message.  The
`Errors` line outputs a list of the type errors in the expression,
which may contain more than the single error from the `Type` line.
The final component is the sequence of evaluation steps, either
resulting in a value or an expression which can evaluate no further.

Some possible examples to try:
```
(lambda x:Bool. x) true
true && (lambda x:Bool. x)
(lambda x:Bool. x) && true
(lambda x:Bool. lambda y:Bool. x && y) (true || false) (false && true)
```





## Example: CamlLight

In the directory for examples, we have an example named `camlLight`,
an implementation of type inference for the Caml Light programming
language.  Enter the directory for this example:
```
cd camlLight
```
Because this is a much larger language than the previous two examples,
the abstract syntax is in multiple files in a directory named
`abstractSyntax`.  We will look at a couple of productions in just one
of these files.  Please open `abstractSyntax/Expr.sv` in your
preferred text editor.

In this file, as the name suggests, we are defining type inference for
expressions in Caml Light.  We have several attributes which occur on
expressions for typing, the noteworthy ones here being:

- `gamma : Maybe<[Pair<String Type>]>`:  The typing context containing
  known variable names and their types
- `subst : Maybe<[Pair<String Type>]>`:  The substitution for type
  variables as handed down from constructs higher in the abstract
  syntax tree
- `subst_out : Maybe<[Pair<String Type>]>`:  The substitution after
  typing the current expression
- `type : Maybe<Type>`:  The type of the current expression

We set out with the intention of making only the `type` attribute an
implicit attribute, to make the possible failure of typing implicit.
We found, however, that the implicit `Maybe` from this attribute
spread to other attributes, which `type` relied on and which relied on
`type`.  These were `gamma`, `subst`, and `subst_out`, so they have an
implicit `Maybe` on their types as well, to represent the potential
failure in them which comes from the potential failure to find a type
for an expression.

We will look at two expression productions using monads implicitly
and being monadified along with versions of them which use monads
explicitly.


### Let Expression

On line 14 in `abstractSyntax/Expr.sv`, we have a production for
typing a `let` expression using monads implicitly, which will be
monadified.  On line 26, this allows us to append the list containing
the original context (`top.gamma`) to the list containing the bindings
from the `let`, even though both of these lists are of a `Maybe`
type.  We are able to ignore the potential failure and write the
expression assuming success.

Similarly, in the equation for `type` (line 32), we can treat the
`b.typeOK` attribute as a `Boolean`, even though it is of type
`Maybe<Boolean>`.

We can compare these to the explicit equation (currently commented out
with a block comment delimited by `{-` and `-}`) on line 39.  In the
equation on line 51, the explicit counterpart to line 26, we need to
unwrap the lists inside the `Maybe` constructors to ensure they are
successful before appending them to handle the potential failure.
Similarly, on line 60 we have the counterpart to line 32, which
unwraps the `Boolean` value inside the potential failure from typing
the bound expressions.


#### Let Examples

We have a file of examples of `let` typing, including both typable and
untypable expressions.  This file can be run from the `camlLight`
directory with
```
./run sample_programs/let_examples.demo
```
This will give the following output:
```
Expression:
   let (x) = 3 and  in (x) + (8)
Type:
   int

Expression:
   let (x) = (3)::((4)::([])) and (y) = 5 and  in (y)::(x)
Type:
   (int) list

Expression:
   let (x) = (3) + (true) and  in x
Type:
   Type does not exist

Expression:
   let ((x : Bool)) = 3 and  in x
Type:
   Type does not exist
``
The first two `let` expressions are typable, with types `int` and `int
list`, respectively.  The latter two are not typable because their
bindings are not typable.

We get the same result if we uncomment the explicit `letExpr`
production (remove `{-` and `-}` on lines 37 and 67) and comment out
the implicit `letExpr` production (add `{-` on line 12 and `-}` on
line 36).  Run
```
./silver-compile
```
in the `camlLight` directory, then run
```
./run sample_programs/let_examples.demo
```
The output with the explicit production will be the same as when using
the implicit version.



### If-Then-Else Expression

On line 239, we have another production using monads implicitly, this
time for `if-then-else`, with a commented-out version on line 269.  On
line 259 we have the implicit equation for `subst_out`.  The
`typeUnify` function expects two arguments of type `Type` and a third
argument for a type substitution (`[Pair<String Type>]`).  Because we
can ignore the `Maybe` on the types, treating them as always
successful, we can pass them as arguments directly to the unification
function.

The explicit counterpart is on line 289, where we need to unwrap the
types and substitution to ensure they are successful before we can
carry out the unification.

We have another interesting implicit equation, this one for `type`, on
line 262.  We match on the substituted condition's type (substituted
so it sees the effects of being unified with the `Boolean` type) to
check that it is a Boolean type, and check whether the types of the
two branches are equal under the substitution with which they were
unified.  We are able to leave out any failure cases and avoid any
explicit unwrapping due to the monadification procedure.

The counterpart to this equation is on line 295.  Here we must not
only unwrap the types and substitution from the `Maybe` constructors
to test if they were successfully constructed, but we must match a
second time on whether the substituted condition type is a `Boolean`
type or not.  If it is `Boolean`, we must then test whether the
branches have the same type.


#### If-Then-Else Examples

We have a file of examples of `if-then-else` typing, including both
typable and untypable expressions.  This file can be run from the
'camlLight' directory with
```
./run sample_programs/if_examples.demo
```
This will give the following output:
```
Expression:
   if true then (3) else 4
Type:
   int

Expression:
   if ((3) > (4)) or ((5.0) <=. (6.0)) then ([]) else [3.0; ]
Type:
   (float) list

Expression:
   if (3.0) +. (4.0) then ("Yes") else "No"
Type:
   Type does not exist

Expression:
   if false then ("Yes") else 5
Type:
   Type does not exist

Expression:
   if (3.0) + (true) then ("Yes") else "No"
Type:
   Type does not exist
```
The first two expressions are typable, typing to `int` and `float
list`.  The latter three expressions are untypable, one for a
condition that isn't a `Boolean`, one for different types in the
branches, and one for an untypable condition.

We get the same result if we uncomment the explicit `ifthenelse`
production and comment out the implicit `ifthenelse` production.  Run
```
./silver-compile
```
in the `camlLight` directory, then run
```
./run sample_programs/let_examples.demo
```
The output with the explicit production will be the same as when using
the implicit version.



### Other Examples

We have an example in `sample_programs/btree.demo` defining a type for
binary trees and defining functions over it.  This can be run with
```
./run sample_programs/btree.demo
```
resulting in the following output:
```
Type Def:
btree : Inductive type with 1 parametetrs; 

Expression:
   let rec (insert) = [...] in insert
Type:
   (('a) btree) -> (int) -> ('a) -> ('a) btree

Type Def:
Maybe : Inductive type with 1 parametetrs; 

Expression:
   let rec (find) = [...] in find
Type:
   (('a) btree) -> (int) -> ('a) Maybe

Type Def:
Error in defining types [btree2]
```
This shows that the `btree` and `Maybe' types were successfully
defined and the two functions were typable, but the type `btree2`
could not be defined.  This is because, as we can see by examining the
file, it attempts to define a constructor named `Node`, which is
invalid because a constructor named `Node` already exists as part of
`btree`.


