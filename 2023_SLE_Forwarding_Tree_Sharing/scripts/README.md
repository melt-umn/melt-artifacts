# Instructions for building this artifact

The ``make-tarball`` script will collect the requisite files and run
Docker to create the container.
```
./make-tarball
```
Note that this may need to be run as `sudo ./make-tarball` if you are
not a member of the `docker` group.

The tar file should then be published on the http://melt.cs.umn.edu
website in the ``melt-artifacts`` directory.  It should be named
``2020_SLE_Strategy_Attributes.tar.gz`` to match the directory name
here.
