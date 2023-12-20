# RSS2Email Container Image

This repository contains the Containerfile and associated scripts for a container image that runs [rss2email](https://github.com/skx/rss2email).

The Containerfile is heavily based on the Dockerfile provided by [rss2email](https://github.com/skx/rss2email).

## Author

- Dominik Meyer <dmeyer@federationhq.de>


## Prerequisites

- Buildah

## Usage

### Building the Container Image

You can build the container image using the following command:

\```bash
buildah bud -t rss2email:latest .
\```

### Running the Container

You can create and run a container from this image with the following command:

\```bash
podman run -d --name rss2email rss2email:latest
\```

### Pushing the Container Image to a Registry

With Buildah:

\```bash
buildah push rss2email:latest docker://<registry>/<username>/rss2email:latest
\```

Replace `<registry>` with the name of your Docker registry and `<username>` with your username on that registry.

## Configuration

The configuration of rss2email is done via environment variables. You can specify these on the Docker run command line with the `-e` option or define them in an environment variable file and specify that with the `--env-file` option.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
