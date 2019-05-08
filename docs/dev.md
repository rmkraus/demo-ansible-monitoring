# Development Documentation

## Building the Container Image

To build the container image from this source, simply use make:

```bash
make build
```

This will create the image and store it locally as `demo-ansible-monitoring:dev`.

## Pushing the Image to Docker Registry

There are two important files for this:
  * `upstream.txt` is the upstream registry path where the image will be pushed.
  * `version.txt` is the current version number.

Once those two files are set correctly, the image can be published with make.

```bash
make publish
```

This will tag the image with the version number as well as latest. The image is then pushed to the upstream registry.
