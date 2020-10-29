# Getting Started Guide

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

