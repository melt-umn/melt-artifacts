
## Getting Started Guide


### Obtaining the Archive

The archive containing the Docker image and associated files can be
obtained from
[melt.cs.umn.edu/melt-artifacts/](melt.cs.umn.edu/melt-artifacts/).
The correct archive is
```
2020_SLE_AG_Monadification.tar.gz
```
Download this archive and inflate it.



### Setting Up Docker

The Docker image needs to be loaded so Docker can find it.  To do
this, run the follwing command in the directory where you inflated the
archive:
```
docker load -i melt-umn-implicit-monads.docker
```
This may require superuser privileges.  This step only needs to be
done once; the Docker image may then be run (explained in the next
paragraph) without doing this step again.


Once the image has been loaded, you can enter the Docker image with
```
docker run -i -t -v $PWD/examples/:/root/examples/ melt-umn/implicit-monads
```
This command may also require superuser privileges.  This will bring
you to a shell in the Docker image, with the prompt
```
implicit-monads:~ >
```
This shows you are working in the Docker image.



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
the artifact.  This was included in the archive and is in the
`Step-Bi-Step-Instructions.md` document.  It can also be viewed
online, where the markdown is rendered to HTML,
[here](https://github.com/melt-umn/melt-artifacts/blob/master/2020_SLE_AG_Monadification/Step-By-Step-Instructions.md).


Because the `examples` directory is mounted in the Docker image rather
than being part of the Docker image, changes made to the files in the
`examples` directory will be available in the Docker image.  This
allows any files from this directory to be viewed and edited using a
text editor installed on the current machine rather than one in the
Docker image.

