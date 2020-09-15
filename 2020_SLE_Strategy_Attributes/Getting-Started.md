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
Download this archive, inflate it, and change into the directory:
```
% tar xzf 2020_SLE_Strategy_Attributes.tar.gz
% cd 2020_SLE_Strategy_Attributes
```


## Setting Up Docker

The saved container extracted from the artifact tarball may be loaded by running
```
% docker load -i dockerimage.tar
```

The container may be run with the examples folder mounted by running
```
% docker run -itv $PWD/examples:/root/examples melt-umn/strategy-attributes
```
from the directory in which the artifact was extracted.

## Basic Testing

This will mount the local `examples/` folder in the home directory of the container,
such that the example files may be viewed and edited with the editor of your choice,
while any changes made are reflected in the container.

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







... run a few basic tests, mabye see that the optimization demo works ... 


## Continuing


The generated files and image may be removed by running `./clean`.

Step-by-step instructions explaining each of the examples can be found in `Step-By-Step-InstructionsS.md`.
