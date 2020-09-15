
## Getting Started Guide

The Docker image needs to be loaded so Docker can find it.  To do
this, run
```
docker load -i melt-umn-implicit-monads.docker
```
in the directory where you inflated the archive.  This may require
superuser privileges.


Once the image has been loaded, you can enter the Docker image with
```
docker run -i -t -v /path/to/examples/:/root/examples/ melt-umn/implicit-monads
```
In the above command, replace `/path/to/examples/` with the absolute
path to the `examples/` directory from the archive.  This command may
also require superuser privileges.  This will bring you to a shell in
the Docker image, with the prompt
```
implicit-monads:~ |-
```
This shows you are working in the Docker image.


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

