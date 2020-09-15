# Instructions for building this artifact

(Lucas, if you don't have a ``make-tarball`` script, then adapt this
accordingly. What follows is from your toplevel README)

The container, examples folder and artifact tarball may be built by running the `./build-artifact` script.
Note that this may need to be run as `sudo ./build-artifact` if your user is not a member of the `docker` group.


(What follows is from Dawn's version)

The ``make-tarball`` script will collect the requisite files and run
Docker to create the container.
```
./make-tarball
```

The tar file should then be published on the http://melt.cs.umn.edu
website in the ``melt-artifacts`` directory.  It should be named
``2020_SLE_Strategy_Attributes.tar.gz`` to match the directory name
here.

(See http://melt.cs.umn.edu/melt-artifacts where I created 2 empty
files named in this manner.)
