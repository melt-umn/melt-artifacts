# Getting Started Guide

The instructions below provide an overview of how to build and run the artifact.

## Obtaining the Archive

The archive containing the Docker image can be obtained from [melt.cs.umn.edu/melt-artifacts/2023_SLE_Nanopass_Attribute_Grammars.tar.gz](http://melt.cs.umn.edu/melt-artifacts/2023_SLE_Nanopass_Attribute_Grammars.tar.gz).

Download this file.

## Setting Up Docker

The Docker image may be loaded by running:

```console
$ docker load -i 2023_SLE_Nanopass_Attribute_Grammars.tar.gz
```

The container may then be run with:

```console
$ docker run -itp 8000:80 melt-umn/nanopass-ags
```

If TCP port 8000 is already in use on your system, you can choose another one.
However, port 80 should not be changed, as this is the port inside the container.

## Basic Testing

Open a web browser and navigate to [http://localhost:8000/](http://localhost:8000/).

If you changed the port above, you should change the port in the URL as well.

If you get a "Connection denied" error, but the Docker container appears to have started successfully, a local firewall may be preventing the connection.
Contact your system administrator for assistance.

You should see a directory listing of files in the container.

These should include:

- `nag/`: The browser-runnable artifact.
- `src/`: The extracted and compiled source code of the artifact.
- `src.tar.gz`: The compressed source code of the artifact.

Navigating into the `nag` link should load the artifact, with our Go demo loaded.

The left-hand side pane is the attribute grammar specification.

TODO
