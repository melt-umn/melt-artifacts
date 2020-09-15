# Artifact for Strategic Tree Rewriting in Attribute Grammars

The container, examples folder and artifact tarball may be built by running the `./build-artifact` script.
Note that this may need to be run as `sudo ./build-artifact` if your user is not a member of the `docker` group.

The container may be run with the examples folder mounted by running
```
docker run -itv $PWD/examples:/root/examples melt-umn/strategy-attributes
```

Step-by-step instructions explaining each of the examples can be found in `INSTRUCTIONS.md`.
