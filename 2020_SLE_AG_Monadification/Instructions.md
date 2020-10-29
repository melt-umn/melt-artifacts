# Monadification of Attribute Grammars - Software Artifact

To evaluate this software artifact, please see the following
documents included in the artifact:

1. The [Getting-Started.md](Getting-Started.md) file has instructions on
   installing and testing the artifact to see that it can be run
   correctly on evaluators' computers.
2. The [Step-By-Step-Instructions.md](Step-By-Step-Instructions.md)
   file has instruction to walk though the examples to carry out the
   actual evaluation.

A copy of the submitted SLE paper is also included, it will be
replaced with the final version of the paper when it is complete.

Please note that the artifact download site is a temporary one.  Once
we have taken any feedback from the evaluators into account a final
version will be prepared and place in the Data Repository for the
University of Minnesota:
[https://conservancy.umn.edu/](https://conservancy.umn.edu/).  The
data and other artifacts placed here are archived by the University of
Minnesota libraries in perpetuity and are assigned digital object
identifier numbers (DOIs).  A previous software artifact for a paper
at OOPSLA is archived there now, with the DOI/url of
[https://doi.org/10.13020/D6VQ25](https://doi.org/10.13020/D6VQ25).
We will follow the same process for this artifact.  The DOI for it
will be included in the final version of our paper. If the evaluators
would like to see this done sooner so that the "artifact available"
badge can be assigned we would be happy to do so.  Please let us know
if a DOI is needed now to acquire this badge.







## Getting Started Guide

The instructions below will show evaluators how to "kick the tires" of
the artifact to demonstrate that it works.  The
[Step-By-Step-Instructions.md](Step-By-Step-Instructions.md) describe
the steps to take to carry out the actual evaluation.

### Obtaining the Archive

The archive containing the Docker image and associated files can be
obtained from
[melt.cs.umn.edu/melt-artifacts/](http://melt.cs.umn.edu/melt-artifacts/).
The correct archive is
```
2020_SLE_AG_Monadification.tar.gz
```
Download this archive and inflate it.



### Setting Up Docker

The Docker image needs to be loaded so Docker can find it.  To do
this, run the following command in the directory containing the
contents of the archive:
```
docker load -i melt-umn-implicit-monads.docker
```
This may require superuser privileges (`sudo` on Linux).  This step
only needs to be done once; the Docker image may then be run
(explained in the next paragraph) without doing this step again.


Once the image has been loaded, you can enter the Docker image with
the following command, replacing `{{PATH/TO/examples/}}` with the
absolute path to the `examples` directory from the archive (this can
be done with `$PWD/examples/` on Linux and Mac):
```
docker run -i -t -v {{PATH/TO/examples/}}:/root/examples/ melt-umn/implicit-monads
```
This command may also require superuser privileges.  This will bring
you to a shell in the Docker image, with the prompt
```
implicit-monads:~ >
```
This shows you are working inside the Docker image.



### Basic Testing

Try listing the files in the current directory:
```
ls
```
This should list three directories:
```
bin  examples  silver
```
Enter the `examples` directory:
```
cd examples
```
List the files in this directory:
```
ls
```
This should list three directories:
```
calculator  camlLight  stlc
```
This shows the `examples` directory has been correctly mounted in the
Docker image.


Enter the `calculator` directory:
```
cd calculator
```
Compile the calculator grammar:
```
./silver-compile
```
The output of this command should end with `BUILD SUCCESSFUL` and the
build time.  Once the build has ended, run
```
./run
```
This will bring up a prompt
```
Enter an expression: 
```
Enter the following two expressions and check that the output is as
expected, then enter a blank line at the third prompt to exit:
```
Enter an expression:  3 + 4
Expression:  (3.0) + (4.0)
Value:  7.0
Implicit Value:  7.0

Enter an expression:  3 / 0
Expression:  (3.0) / (0.0)
Value:  no value
Implicit Value:  no value

Enter an expression: 
```
If the output was as expected, the Docker image is working correctly.



### Continuing

Now that the Docker image is working and the `examples` directory is
mounted correctly, you can continue to the step-by-step walkthrough of
the artifact.  This was included in the archive, is in the
`Step-By-Step-Instructions.md` document, and follows here.  It can
also be viewed online at
[here](https://github.com/melt-umn/melt-artifacts/blob/master/2020_SLE_AG_Monadification/Step-By-Step-Instructions.md),
where the markdown is rendered to HTML.


Because the `examples` directory is mounted in the Docker image rather
than being part of the Docker image, changes made to the files in the
`examples` directory will be available in the Docker image.  This
allows any files from this directory to be viewed and edited using a
text editor installed on the current machine rather than one in the
Docker image.  Only the commands need to be run in the Docker image.







## Step-By-Step Instructions





### Attribute Grammars

Attribute grammars describe the semantics of languages by associating
semantic attributes with nodes in an abstract syntax tree.  The values
of these attributes are given by equations associated with grammatical
productions.  For example, in typing the simply-typed lambda calculus,
we would have attributes for the typing context and the type of an
expression.





### Notational Differences

In the paper, we used notation independent of any particular
attribute-grammar system, notation which would be recognizable to
those generally familiar with functional programming.

Some notation is different in Silver.  The primary differences:
- Equations need a marker at the beginning to note whether they are
  for restricted or implicit attributes; we did not include these in
  figures in the paper.  This limitation on the implementation was
  noted in Section 6 in the paper.
- `match ... with` for pattern matching from the paper becomes
  `case ... of` in Silver
- Parameterized types replace parentheses with angle brackets, turning
  `Maybe(T)` from the paper into `Maybe<T>` in Silver
- Pair types, written `(A, B)` in the paper, become a parameterized
  type `Pair<A B>` in Silver

Other notational differences will be pointed out as they are
encountered.





### Monads

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





### Monadification

Our monadification is a rewriting which allows us to use monads
implicitly in attribute equations.  Implicit use of a monad means that
we are ignoring the presence of the monad.  This allows us to act as
if attributes of a monadic type `M<T>` actually have type `T`.  We can
use them where an expression of type `T` is expected and we can use
expressions of type `T` in equations defining them.

Monadification also allows us to write only the success cases.  For
example, if we are typing a language including an `if-then-else`
construct, we would be able to write the equation for the `type`
attribute such that it only gives a type to the construct when the
condition has a `Boolean` type and the two branches have the same
type, rather than writing the equation to explicitly fill in the error
cases as well.





### Example:  Calculator

In the directory for examples, we have an example named `calculator`.
Enter the directory for this example:
```
cd calculator
```
This example implements a simple calculator with addition,
subtraction, multiplication, and division.  The grammar can be
compiled with
```
./silver-compile
```
Examples can be run with
```
./run
```
This will bring up a REPL for the calculator.  Entering an expression
will evaluate it and print out the result.  For example:
```
Enter an expression:  3 + 4
Expression:  (3.0) + (4.0)
Value:  7.0
Implicit Value:  7.0
```
If an expression is entered which cannot evaluate, we get that there
is no value:
```
Enter an expression:  3 / 0
Expression:  (3.0) / (0.0)
Value:  no value
Implicit Value:  no value
```
To exit the loop, enter a blank line.

This grammar is composed of three files.  `Concrete.sv` defines the
concrete syntax of the calculator.  `Main.sv` drives the grammar.
Neither of these files uses implicit monads, and thus we do not
discuss them.  `Abstract.sv` does use implicit monads.  Please open
the `Abstract.sv` file in your preferred editor to view the equations
in this grammar.

In our calculator, we have two attributes for evaluation, `imp_value`
and `value`.  Both of which have the type `Maybe<Float>` to represent
potential failure due to division by zero.  In the output from the
calculator, a result of `just(x)` outputs the number `x` and a result
of `nothing()` outputs the response `no value`.  Both attributes
compute the value of the expression, as can be seen in the output from
the calculator, but `imp_value` is an implicit attribute, which uses
monads implicitly, and `value` uses standard equations.

The simplest example of the benefits of monadification can be seen in
the `num` production on line 32, where the value from evaluation is
simply the number, as expected when not thinking about the monad
`Maybe`.  On line 37, we have the implicit equation for
`top.imp_value`, and on line 39, we have the equation for `top.value`.
On line 39, we give the value `just(n)` because we need the expression
to have type `Maybe<Float>`.  On line 37, in the implicit equation, we
can simply have the expression `n`, ignoring the `Maybe` monad
representing potential failure since there is no possibility of
failure here.

To see more complex uses, let's examine the equations for `imp_value`
and `value` in the `plus` production on line 42.  The equation for
`top.value` on line 49 uses `case` to test whether the addends
evaluated to values or not (`t1.value` and `t2.value` are `just`s),
then add the values if they were values or give a failure (give a
`nothing`).  The implicit equation for `top.imp_value` on line 47
simply adds together the `imp_value` attributes of the addends, making
the intention of the equation clearer.  This is an example of using
the `Maybe` monad implicitly, where we use expressions of type
`Maybe<Float>` as if they had type `Float`.  If we wrote the equation
on line 73 without implicit monads, a subexpression not evaluating
would cause an error, halting evaluation, rather than allowing us to
continue evaluation and declare there was no result.  These two
equations will end up evaluating the same way, but the implicit one is
easier to write and easier to read.

The `minus` and `mult` productions are similar to the `plus`
production.  The `div` production (line 81) has an equation which
shows more benefits of monadification.  Division should successfully
evaluate only if the divisor is non-zero.  On line 86, in the implicit
equation for `top.imp_value` we check if the divisor's value
(`t2.imp_value`) is non-zero and then carry out the division.  We
don't need to write out the error cases in implicit equations, since
the monadification will fill them in.  The equation for `top.value` on
line 89 needs to unwrap the values as in the `plus` production, but it
then also needs to check that the divisor is non-zero, giving the
monadic failure `nothing()` for when the divisor is zero.  We can see
this in the `3 / 0` example above, where we get the result of `no
value`.

The monadic equations for `imp_value` will pass through any failures,
just as the standard equations for `value` will pass them through.  We
can see this by trying the following examples:
```
(4 / 0) + 3
3.0 + 4.3 - 8.8 * 5 / (3 - 4 + 1)
```
We can also see that these two attributes are evaluating the same
basic arithmetic operations and thus will always have the same numeric
value; however, as we saw in the source code, the implicit equations
for `imp_value` are much simpler to read and write than the standard
equations used for `value`.





### Example:  Simply-Typed Lambda Calculus with Booleans

In the directory for examples (`examples/` in the directory where the
archive was inflated), we have an example named `stlc`.  Enter the
directory for this example:
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
This will give a prompt, `Enter an expression:`.  Entering an
expression will output the type of the expression and any type errors,
along with the evaluation steps when evaluating the expression:
```
Enter an expression:  lambda x:Bool. x
Expression:  lambda x:Bool. x
Type:        (Bool) -> Bool
Errors:      
SingleSteps Attribute (Evaluation Trace):
   [,  lambda x:Bool. x]
```
The following example expressions show the syntax of the language:
- `lambda f:Bool -> Bool. f` : a function taking an argument of type
  `Bool -> Bool` named `f`
- `true && false` : conjunction of the constants `true` and `false`
- `true || true` : disjunction of the constant `true` with itself
- `(lambda x:Bool. x) true` : a function applied to the constant
  `true`

The precedence is as expected.

This grammar contains files with the same names and purposes as in the
calculator example above.  Please open the `Abstract.sv` file in your
preferred editor.


#### Typing

We have three attributes associated with typing, `gamma`, which
represents the typing context; `type`, which represents the type of an
expression; and `errors`, a list of type errors.

The `type` attribute is an implicit attribute, so its equations
may take advantage of our monadification process and use monads
implicitly.  As in the `calculator` example above, this means we can
use values without unwrapping them, as we see in the equation for
`type` in the `abs` production on line 87, with the expression
```
arrow(ty, body.type)
```
This is the same equation as seen on line 15 in Figure 2 in the paper,
which uses monads implicitly.  (Capitalization of `Ty` versus `ty` is
different due to constraints on capitalization in Silver).  Here
`body.type` is used implicitly to build the function type for the
abstraction.  For example, if we run the expression (`./run` and enter
it at the prompt for an expression)
```
lambda x : Bool -> Bool. x && true
```
we do not get an actual type, but rather a type error because the body
of the function is untypable.  This error was passed through the `abs`
production in the `type` equation without our needing to explicitly
write the passing through.

We get a type error as the type for untypable expressions because the
type of this attribute is `Either<String Type>`, which allows us to
give an error message in the case an expression is not typable.  For
example, in the `app` production, the equation for `type` (line 112)
checks that the prospective function has a function type and that the
argument's type matches the expected argument type.  This equation
matches the one found on line 2 in Figure 3 of the paper, modulo the
syntax differences mentioned above.  If one of these conditions is not
true, we give an appropriate error message in the monadic failure
constructor for `Either`, `left`.  For example, if the argument types
do not match, we give `left("Application type mismatch")`.  This can
be seen in trying to type
```
(lambda x:Bool. x) (lambda x:Bool. x)
```

By using `Either` implicitly, the errors from the subexpressions are
passed up the abstract syntax tree automatically.  Thus we get the
error from the body of the applied function when we try to type the
following expression (using the function from above):
```
(lambda x : Bool -> Bool. x && true) (lambda x:Bool. x)
```

We can use the error messages we generate in the `type` attribute to
produce a list of type errors in the unrestricted `errors` attribute,
as seen in Figure 3 in the paper.  We do this by matching on the value
of the `type` attribute, taking the error message out of it if it is a
`left`.  Because the error messages of the subexpressions will be
passed through the `type` equation, we take care to avoid replicating
the same error message many times in the list of errors.  We do this
by matching on `left` and `right` (line 117) to check that the error
message is new and is not simply passed up from the subexpressions.

In implicit equations, we are not able to do case analysis on the
constructors of the monad of the attribute being defined.  For
example, the `type` attribute cannot match on the `left` and `right`
constructors because `Either` in the `type` attribute uses the `Either`
monad.  We are able to match on them in equations for the `errors`
attribute because it is an unrestricted attribute.  In equations for
`type`, however, we can match on any other type, even if that type is
also a monad.  In the `var` production, the equation for `type` (line
62) uses a function `lookupType`, returning a value of type
`Maybe<Type>` to find the type of an attribute if it is a known
variable.  We match on the `just` and `nothing` constructors to turn
this `Maybe` into an `Either`.


#### Evaluation

We define single-step evaluation using the `nextStep` attribute.  This
is an implicit attribute making use of the `Maybe` monad to represent
potential failure of evaluation.  Because this attribute doesn't
interact with the `type` attribute, we can use different monads for
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





### Example: Caml Light

In the directory for examples, we have an example named `camlLight`,
an implementation of type inference for the [Caml Light programming
language](https://ocaml.org/caml-light/).  This language is a subset
of the OCaml language.  Enter the directory for this example:
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
We found, as discussed in Section 6 of the paper, that the implicit
`Maybe` from this attribute spread to other attributes, which `type`
relied on and which relied on `type`.  These were `gamma`, `subst`,
and `subst_out`, so they have an implicit `Maybe` on their types as
well, to represent the potential failure in them which comes from the
potential failure to find a type for an expression.

We will look at two expression productions using monads implicitly
and being monadified, along with versions of them which use monads
explicitly.


#### Let Expression

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


##### Let Examples

We have a file of examples of `let` typing, including both typable and
untypable expressions.  To run this example, first we will need to
compile the grammar from the `camlLight` directory with
```
./silver-compile
```
We can then run the file with the examples using
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
```
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



#### If-Then-Else Expression

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


##### If-Then-Else Examples

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



#### Another Example

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
This shows that the `btree` and `Maybe` types were successfully
defined and the two functions were typable, but the type `btree2`
could not be defined.  This is because, as we can see by examining the
file, it attempts to define a constructor named `Node`, which is
invalid because a constructor named `Node` already exists as part of
`btree`.


