# helm-docker

[![Docker Pulls](https://img.shields.io/docker/pulls/devth/helm.svg?style=flat-square)](https://hub.docker.com/r/devth/helm/)

Removed gcloud stuff
Added Rancher support with cattlectl
Added kustomize / kapp for managing deployments
Added kubeval to check yaml

## Usage

This Docker image includes `helm` along with:

- `kubectl`
- `kustomize`
- `kapp`
- `kubeval`
- `cattlectl` for Rancher
- `envsubst`
- `jq`

And `helm` plugins:

- `databus23/helm-diff`
- `helm/helm-2to3`

## Docker

Docker images are automatically built on [Docker
Hub](https://hub.docker.com/r/devth/helm/):

- Docker tags correspond to [Helm
  release](https://github.com/helm/helm/releases) versions.
- `latest` is always the latest fully released version (non-beta/RC).
- `master` is always the latest commit on master.

### Building

To test a local build:

```bash
docker build -t devth/helm .
```

## Release procedure

Use the following to:

- Bump `VERSION` in the [Dockerfile](Dockerfile)
- Commit and create tag matching the version

NB: the `sed` syntax works with MacOS built-in `sed`.

```bash
gh issue list
VERSION=v3.2.0
ISSUE=88
# works on macOS
sed -i '' "3s/.*/ENV VERSION $VERSION/" Dockerfile
git diff # ensure it looks good
git commit -am "Bump to $VERSION; fix #$ISSUE"
git tag $VERSION
git push && git push --tags
```

Optionally test building the image before pushing:

```bash
docker build .
```

### Re-release

To re-build a particular tag we need to delete the git tag locally and remotely:

```bash
git push origin :$VERSION
git tag -d $VERSION
```

Then re-tag and push:

```bash
git tag $VERSION
git push --tags
```
