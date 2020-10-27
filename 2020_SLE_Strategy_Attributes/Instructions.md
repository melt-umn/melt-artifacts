# Strategic Tree Rewriting in Attribute Grammars - software artifact

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

# Getting Started Guide

The instructions below will show evaluators how to "kick the tires" of
the artifact to demonstrate that it works.  The The
[Step-By-Step-Instructions.md](Step-By-Step-Instructions.md) describe
the steps to take to carry out the actual evaluation.

### Obtaining the Archive

The archive containing the Docker image and associated files can be
obtained from
[melt.cs.umn.edu/melt-artifacts/](http://melt.cs.umn.edu/melt-artifacts/).
The correct archive is
```
2020_SLE_Strategy_Attributes.tar.gz
```
Download this archive and inflate it:
```
% tar xzf 2020_SLE_Strategy_Attributes.tar.gz
```
(On Windows there may not be this ``tar`` command and something else
will need to be used.)


## Setting Up Docker

The saved container extracted from the artifact tarball may be loaded by running
```
% docker load -i melt-umn-strategy-attributes.docker
```

The container may be run with the examples folder mounted by running
```
% docker run -itv $PWD/examples:/root/examples melt-umn/strategy-attributes
```
from the directory in which the artifact was extracted.  (Note on Windows you may
need to change `$PWD` to the full path to the directory in which the artifact
was extracted.

This will mount the local `examples/` folder in the home directory of the container,
such that the example files may be viewed and edited with the editor of your choice,
while any changes made are reflected in the container.

## Basic Testing

The home directory of the container contains several folders:
* `silver/` contains an installation of Silver
* `ableC/` contains an installation of ableC
* `extensions/` contains an installation of silver-ableC and 
* `bin/` contains the locally-installed executable scripts added on `PATH` to run `silver` and `silver-ableC`
* `examples/` contains the actual examples corresponding to the strategy attributes paper:
  * `rewriting-optimization-demo/` is an example use of strategy attributes for a simple functional language used as a running example in the paper
  * `rewriting-lambda-calculus/` is an implementation of the lambda calculus using strategy attributes and a comparison with an earlier mechanism for rewriting on undercoated terms in Silver, both based on an example from Kiama
  * `rewriting-regex-matching/` contains an implementation of regex matching using Brozozowski derivatives, with alternative mechanisms for simplifying intermediate regexes using both strategy attribute and term rewriting
  * `ableC-halide` is an ableC extension based on the Halide EDSL for specifying optimizing transformations on nested `for`-loops; strategy attributes are used in normalizing loops to have the expected form before transformations are applied.

The optimization demo example can be tested using the container by changing into
the `examples/rewriting-optimization-demo/` directory and running `./build && ./run-tests`.

This should generate the following output:
```
Compiling edu:umn:cs:melt:rewritedemo:driver
	[grammars/edu.umn.cs.melt.rewritedemo/driver/]
	[Main.sv]
Found core:monad
	[/root/silver/generated/src/core/monad/Silver.svi]
Found silver:langutil
	[/root/silver/generated/src/silver/langutil/Silver.svi]
Found silver:langutil:pp
	[/root/silver/generated/src/silver/langutil/pp/Silver.svi]
Compiling edu:umn:cs:melt:rewritedemo:abstractsyntax
	[grammars/edu.umn.cs.melt.rewritedemo/abstractsyntax/]
	[Optimize.sv AbstractSyntax.sv]
Compiling edu:umn:cs:melt:rewritedemo:concretesyntax
	[grammars/edu.umn.cs.melt.rewritedemo/concretesyntax/]
	[ConcreteSyntax.sv]
...

Testing e6.demo
fun e6() =
  (1 + 2) + foo(3 + 4, 5 - 6);

==============

Free variables: 

==============

fun e6() =
  3 + foo(7, -1);

==============

fun e6() =
  3 + foo(7, -1);
exit code 0
```
If this is what is displayed then the artifact should be working.

## Continuing

Step-by-step instructions explaining each of the examples can be found in [Step-By-Step-Instructions.md](Step-By-Step-Instructions.md).


Because the `examples` directory is mounted in the Docker image rather
than being part of the Docker image, changes made to the files in the
`examples` directory will be available in the Docker image.  This
allows any files from this directory to be viewed and edited using a
text editor installed on the current machine rather than one in the
Docker image.  Only the commands need to be run in the Docker image.

# Step by Step Instructions

Before running these examples, follow the instructions in `Getting-Started.md` to initialize the docker container.

The examples are all located in the top-level `examples/` folder; the other directories contain clones of dependency Git repositories and may be ignored.

## Optimization demo example
This example demonstrates the use of strategy attributes to perform optimizations on a simple functional language, as seen in the paper, specifically in Figures 1, 3, 6, and 7. Change into the `examples/rewriting-optimization-demo/` directory:
```
cd ~/examples/rewriting-optimization-demo/
```

The Silver specification of this example language is provided in the `grammars/` subdirectory.  The abstract syntax, consisting of top-level function declarations, expressions and let-binding declarations, is given in `grammars/edu.umn.melt.rewritedemo/abstractsyntax/AbstractSyntax.sv`.  Figure 1 of the paper shows some of the attributes and productions that are to be found in this file.  Additional attributes, such as ``wrapPP`` are included here that are not seen in that figure. 
Another minor difference is that equations for the ``defs`` attribute are actually in another file, `grammars/edu.umn.melt.rewritedemo/abstractsyntax/Optimize.sv` that contains the strategies and attributes used to perform optimizations and seen in Figures 3, 6, and 7.

Concrete syntax for building a parser is given in `grammars/edu.umn.melt.rewritedemo/concretesyntax/` and a driver program performing I/O operations is defined in ``grammars/edu.umn.melt.rewritedemo/driver``; you do not need to consider these as the paper and examples are concerned with transformations on abstract syntax.

To compile the Silver specification, run
```
./build
```
This may take a few seconds, and should produce an executable jar file named `rewritedemo.jar`.

A number of example programs of the demo language with the name `*.demo` are provided in the directory.  For simplicity, each program in this demo language consists of a single top-level function declaration, with an expression as the body.

The compiled program can be run on a particular example (e.g. `e2_free.demo`) by running

```
java -jar rewritedemo.jar e2_free.demo
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
Here the function body references variables `foo` and `bar` that have no definition, thus they are reported as free variables (in a real language this could be an error message of some kind.)

In the first optimization pass (implemented by the `optimize` strategy attribute on line 14 in `grammars/edu.umn.melt.rewritedemo/abstractsyntax/Optimize.sv`), all expressions involving numeric operations are simplified as much as possible.  The `optimizeStep` strategy attribute on line 5 of this file encode the rewrite rules in the second column of page 2 of the paper and realized as strategy attributes in Figure 3 of the paper.  In this example `foo - (-bar)` is simplified to `foo + bar` and `a + (10 - 4)` becomes `a + 6`.  However all `let`-bindings are left intact, despite having only one reference.

In the second optimization pass (implemented by the `optimizeInline` strategy attribute in the same file on line 77), deeper structural transformations are performed.  These can be seen in the paper in Figures 6 and 7. The body of `e6` is further reduced to `(foo + bar) + 6`, by observing that the `let`-variables are only referenced in at most one place each, and thus the let-bindings can be safely inlined without duplicating any computations.

All of the examples may be easily be run at once by executing
```
% ./run-tests
```


## Lambda calculus example
This example is an implementation of the untyped lambda-calculus, as seen in Section 5.1 and Figure 13 of Appendix B.1 of the paper. Change into the `examples/rewriting-optimization-demo/` directory:
```
% cd ~/examples/rewriting-lambda-calculus/
```

The directory structure is similar to the previous example.  The strategy attributes for normalization to head-normal form are defined in `grammars/edu.umn.cs.melt.lambdacalc/abstractsyntax/EvalStrategyAttr.sv` (a prior implementation of the same rewrite rules using a reflection-based mechanism for rewriting undecorated terms in Silver is given in `grammars/edu.umn.cs.melt.lambdacalc/abstractsyntax/EvalTermRewrite.sv`.)

To compile the Silver specification, run
```
% ./build
```
This may take a few seconds, and should produce an executable jar file named `lambdacalculus.jar`.

A number of example terms with the name `*.lambda` are provided in the directory.  For simplicity, each program in this demo language consists of a single top-level function declaration, with an expression as the body.

The compiled program can be run on a particular example (e.g. `e3.lambda`) by running
```
% java -jar rewritedemo.jar e3.lambda
```
This pretty prints the original term and the term following normalization, for example with the above (corresponding to a computation of 2 + 3 using Church numerals):
```
(\m n f x. m f (n f x)) (\f x. f (f x)) (\f x. f (f (f x)))

\a0 a10. a0 (a0 (a0 (a0 (a0 a10))))
```

All of the examples may be easily be run at once by executing
```
% ./run-tests
```

The default definition of the `eval` strategy on line 55 of `grammars/edu.umn.cs.melt.lambdacalc/abstractsyntax/EvalTermRewrite.sv` is `evalInnermost`; this can be changed to `evalOutermost`, `evalEager` or `evalLazy`.  After re-running `./build`, observe the change in the output of running the examples.  For some examples with `evalEager` and `evalLazy`, unreduced `let` terms are left in the output.  The `evalOutermost` strategy is much less efficient than `evalInnermost`, so much so that evaluating the large test case in `e4.lambda` with this strategy may result in a stack overflow error.  


## Regex matching with Brzozowski derivatives
This example demonstrates an implementation of regex matching using Brzozowski derivatives, as seen in Section 5.2 and Figure 14 of Appendix B.2 of the paper.  Change into the `examples/rewriting-regex-matching/` directory:
```
% cd ~/examples/rewriting-regex-matching/
```

The directory structure is similar to the previous examples.  The abstract syntax of regular expressions, and attributes for matching and simplification, are defined in `grammars/edu.umn.cs.melt.rewritingRegexMatching/abstractsyntax/AbstractSyntax.sv`.  Here the function `matches` (line 83) drives the matching process, by repeatedly computing the Brzozowski derivative of the regex with respect to each character of the string (implemented by the `deriv` and `wrt` attributes) and simplifying the resulting regular expression.  The original regex matches the string if and only if the final regex is nullable (implemented by the `nullable` attribute.)

Two implementations of regex simplification are included: one using an earlier reflection-based rewriting library/extension to Silver, and one using strategy attributes (`simpl` and `simplDeriv`.)

To compile the Silver specification, run
```
% ./build
```
This may take a few seconds, and should produce an executable jar file named `regex.jar`.

The compiled program may be run with two command line arguments, a regex and a string to match, such as
```
% java -jar regex.jar '(ab)*' ababab
```
The program will either print `Match success` or `Match failure`.

If a second argument is not provided the string to match will be read from stdin.  Two large randomly-generated alphanumeric files are provided as examples.  Note that on large input files additional stack and heap space must be specified as command-line arguments to Java; for example to search for the string `1q3mNBHB1zM` in `test2.txt` one might run
```
% java -Xss500M -Xmx2G -jar regex.jar '.*1q3mNBHB1zM.*' < test2.txt
```

A test script is also provided containing a number of additional test cases as examples.  These may be tested by running
```
% ./run-tests
```


## Loop normalization in the ableC-Halide extension
The ableC-Halide extension is a sophisticated extension to ableC for specifying optimizing transformations on nested `for`-loops, inspired by the Halide C++ embedded domain-specific language.  Before loops can be transformed they must have the correct form; this normalization process is accomplished by strategy attributes.  This extension is discussed in Section 5.3 of the paper with a portion of the implementation shown in Figure 15 of Appendix B.3.

Change into the `examples/ableC-halide/` directory:
```
% cd ~/examples/ableC-halide/
```

The extension directory contains several subdirectories.  The
specification of the extension is defined in the `grammars/` folder;
the use of strategy attribute for normalization occurs in
`grammars/edu.umn.cs.melt.exts.ableC.halide/abstractsyntax/IterStmt.sv`.  
To implement the translations of extension constructs into plain C
code a number of strategy attributes are used.  These include the
`simplifyNumericExprStep` strategy starting on line 43 and
`preprocessLoop` starting on line 75.  This last strategy normalizes
for-loops to simplify later stages of the translation.
A number of example programs using the extension are provided in the `examples/` folder, the `tests/` folder contains more tests programs (including some with semantic errors), and the `modular_analyses/` folder contains specifications of analyses to ensure that composing with independent extensions will not introduce parser table conflicts or missing equations.  All of the examples and test cases may be built and run by running `make -j` at the top level, however this will take several minutes and is not required to run the examples.

Change into the `examples/` directory:
```
% cd examples/
```

A nontrivial example use of the extension is in `matmul.xc`.  This program provides two implementations of a matrix multiplication, one unoptimized and the other with a number of optimizing transformations applied.  This may be built and run by typing
```
% make matmul.out
% ./matmul.out
```
The `make` command will automatically perform a number of steps to compile the program:
1. Invoke `silver` to compile the Silver specification into a jar file `ableC.jar`
2. Run `java -jar ableC.jar matmul.xc` to translate the extended C program `matmul.xc` into an unextended C program `matmul.c`
3. Run `cc -fopenmp -g   -c -o matmul.o matmul.c` to compile `matmul.c` into an object file `matmul.o` (the `-fopenmp` flag enables the use of OpenMP pragmas, used by the extension to implement parallelism)
4. Run `cc  matmul.o  -lgomp -o matmul.out` to link `matmul.o` into an executable binary `matmul.out`
When the program is run it will build a pair of large random matrices filled with random values, multiply them using both the optimized and unoptimized implementations while printing the total runtime for each, and compare the results for correctness.

In the `matmul.xc` program all for-loops were defined using an additional `forall` statement provided by the extension, which forwards (translates) to a set of already-normal `for`-loops that start at 0 and use the `<` and `++` operators in their condition and update expressions.  However, consider `irregular.xc`; this program defines and transforms several loops that do not fit this pattern.  Here the strategy attributes come in to play, initially simplifying and normalizing the loop expressions into a form that can be transformed.  To run compile and run this example type
```
% make irregular.out
% ./irregular.out
```

You may also try editing `irregular.xc` to change the loop expressions within the `transform {}` block, to see how effective the strategies are in normalizing complex loop conditions.


## Use of strategy attributes in optimizing strategies for translation
The last use of strategy attributes described in the paper is their use in optimizing strategy expressions for more efficient translation, as a part of their implementation in the Silver compiler.  This is described in Section 5.4 and Figure 16 of Appendix B.4 in the paper.  As this use of strategy attributes is tightly coupled with the Silver compiler (and is run for every Silver build that involves strategy attributes) it is difficult to provide a straightforward demo.  However the complete source code of this application can be found in the `silver/` repository folder at `silver/grammars/silver/extension/strategyattr/StrategyExpr.sv`
