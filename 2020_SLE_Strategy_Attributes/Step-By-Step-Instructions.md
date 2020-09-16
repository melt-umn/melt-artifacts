# Step by step instructions for artifact evaluation

Before running these examples, follow the instructions in `Getting-Started.md` to initialize the docker container.

The examples are all located in the top-level `examples/` folder; the other directories contain clones of dependency git repositories and may be ignored.

## Optimization demo example
This example demonstrates the use of strategy attributes to perform optimizations on a simple functional language, as seen in the paper. Change into the `examples/rewriting-optimization-demo/` directory:
```
cd ~/examples/rewriting-optimization-demo/
```

The Silver specification of this example language is provided in the `grammars/` subdirectory.  The abstract syntax, consisting of top-level function declarations, expressions and let-binding declarations, is given in `grammars/edu.umn.melt.rewritedemo/abstractsyntax/AbstractSyntax.sv` while the strategies and attributes used to perform optimizations are defined in `grammars/edu.umn.melt.rewritedemo/abstractsyntax/AbstractSyntax.sv`.
Concrete syntax for building a parser is given in `grammars/edu.umn.melt.rewritedemo/concretesyntax/` and a driver program performing I/O operations is defined in ``grammars/edu.umn.melt.rewritedemo/driver`; you do not need to carefully examine these as the examples here are mainly concerned with transformations on abstract syntax.

To compile the Silver specification, run
```
./build
```
This may take a few seconds, and should produce an executable jar file named `rewritedemo.jar`.

A number of example programs of the demo language with the name `*.demo` are provided in the directory.  For simplicity, each program in this demo language consists of a single top-level function declaration, with an expression as the body.

The compiled program can be run on a particular example (e.g. `e2_error.demo`) by running
```
java -jar rewritedemo.jar e2_error.demo
```
This pretty-prints the original program, the list of free (unbound) variables in the program, and the program after two different optimization passes; for example the above should print
```
fun e2() =
  let 
    a = foo - (-bar);
    b = a + (10 - 4);
  in b end;

==============

Free variables: foo, bar

==============

fun e2() =
  let 
    a = foo + bar;
    b = a + 6;
  in b end;

==============

fun e2() =
  (foo + bar) + 6;
```
Here the function body references variables `foo` and `bar` that have no definition, thus they are reported as free.

In the first optimization pass (implemented by the `optimize` strategy attribute in `grammars/edu.umn.melt.rewritedemo/abstractsyntax/AbstractSyntax.sv`), all expressions involving numeric operations are simplified as much as possible.  In this case `foo - (-bar)` is simplified to `foo + bar` and `a + (10 - 4)` becomes `a + 6`.  However all `let`-bindings are left intact, despite having only one reference.

In the second optimization pass (implemented by the `optimizeInline` strategy attribute in the same file), deeper structural transformations are performed.  The body of `e6` is further reduced to `(foo + bar) + 6`, by observing that the `let`-variables are only referenced in at most one place each, and thus the let-bindings can be safely eliminated without duplicating any computations.

All of the examples may be easily be run at once by executing
```
./run-tests
```

## Lambda calculus example
This example is an implementation of the untyped lambda-calculus, as seen in Appendix B.1 of the paper. Change into the `examples/rewriting-optimization-demo/` directory:
```
cd ~/examples/rewriting-optimization-demo/
```

The directory structure is similar to the previous example.  The strategy attributes for normalization to head-normal form are defined in `grammars/edu.umn.cs.melt.lambdacalc/abstractsyntax/EvalStrategyAttr.sv` (a prior implementation of the same rewrite rules using a reflection-based mechanism for rewriting undecorated terms in Silver is given in `grammars/edu.umn.cs.melt.lambdacalc/abstractsyntax/EvalTermRewrite.sv`.)

To compile the Silver specification, run
```
./build
```
This may take a few seconds, and should produce an executable jar file named `lambdacalculus.jar`.

A number of example terms with the name `*.lambda` are provided in the directory.  For simplicity, each program in this demo language consists of a single top-level function declaration, with an expression as the body.

The compiled program can be run on a particular example (e.g. `e3.lambda`) by running
```
java -jar rewritedemo.jar e3.lambda
```
This pretty prints the original term and the term following normalization, for example with the above (corresponding to a computation of 2 + 3 using Church numerals):
```
(\m n f x. m f (n f x)) (\f x. f (f x)) (\f x. f (f (f x)))

\a0 a10. a0 (a0 (a0 (a0 (a0 a10))))
```

All of the examples may be easily be run at once by executing
```
./run-tests
```

The default definition of the `eval` strategy on line 55 of `grammars/edu.umn.cs.melt.lambdacalc/abstractsyntax/EvalTermRewrite.sv` is `evalInnermost`; this can be changed to `evalOutermost`, `evalEager` or `evalLazy`.  After re-running `./build`, observe the change in the output of running the examples.  For some examples with `evalEager` and `evalLazy`, unreduced `let` terms are left in the output.  The `evalOutermost` strategy is much less efficient than `evalInnermost`, so much so that evaluating the large test case in `e4.lambda` with this strategy may result in a stack overflow error.  


## Regex matching with Brzozowski derivatives
*write this*

## Loop normalization in the ableC-Halide extension
*write this*
