# Getting Started Guide
The instructions below provide an overview of how to set up the artifact, build run and run the software.

## Obtaining the Archive

The archive containing the Docker image and associated files can be
obtained from
[melt.cs.umn.edu/melt-artifacts/](http://melt.cs.umn.edu/melt-artifacts/).
The correct archive is
```
2023_SLE_Forwarding_Tree_Sharing.tar.gz
```
Download this archive and inflate it:
```
% tar xzf 2023_SLE_Forwarding_Tree_Sharing.tar.gz
```
(On Windows there may not be this ``tar`` command and something else
will need to be used.)

A permanent archival version can also be found at [https://doi.org/10.13020/badh-qf44](https://doi.org/10.13020/badh-qf44).

## Organization

The archive contains several folders with various examples:
* `example-language/` is a full implementation of the example language used as an example in the paper
* `ableC-extensions-no-sharing/` contains the versions of the ableC extensions that were evaluated in the paper,
prior to the use of any new sharing features
* `ableC-extensions-with-sharing/` contains some of these extensions that have been updated to make use of tree sharing features
* `melt-umn-tree-sharing.docker` is a docker image from which these examples can be built and run

## Setting Up Docker

The saved container extracted from the artifact tarball may be loaded by running
```
% docker load -i melt-umn-tree-sharing.docker
```

The container may be run with
```
% docker run -it melt-umn/tree-sharing
```
from the directory in which the artifact was extracted.

## Basic Testing

The home directory of the container contains several folders:
* `silver/` contains an installation of Silver
* `ableC/` contains an installation of ableC
* `bin/` contains the locally-installed executable scripts added on `PATH` to run `silver` and `silver-ableC`
* `example-language/` contains the implementation of the example language from the paper
* `extensions/` contains the updated ableC extensions and their dependencies

The example language can be tested using the container by changing into
the `example-language/` directory and running `./build && ./run-tests`.

This should generate the following output:
```
Compiling edu:umn:cs:melt:sharedemo:composed:with_all
	[grammars/edu.umn.cs.melt.sharedemo/composed/with_all/]
	[Artifact.sv]
Compiling edu:umn:cs:melt:sharedemo:host
	[grammars/edu.umn.cs.melt.sharedemo/host/]
	[Project.sv]
Compiling edu:umn:cs:melt:sharedemo:driver
	[grammars/edu.umn.cs.melt.sharedemo/driver/]
	[Main.sv]
Compiling edu:umn:cs:melt:sharedemo:exts:forloop
	[grammars/edu.umn.cs.melt.sharedemo/exts/forloop/]
	[Project.sv]
Compiling edu:umn:cs:melt:sharedemo:exts:condtable
	[grammars/edu.umn.cs.melt.sharedemo/exts/condtable/]
	[Project.sv]
...

Testing e4.demo
11

Testing e5.demo
0
1
1
1
0
0
1
0
```
If this is what is displayed then the artifact should be working.

To build an ableC extension, cd into the extension folder and run `make` (or `make -j` for parallelism.)
