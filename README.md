# Ansible Collection `suhlig.foundation`

Foundation of my Ansible roles

# CI

TODO - not yet fully spec'd out

1. "bump" job

    - bumps the version (`major`, `minor` or `patch`) in galaxy.yml

      ```command
      $ bump="patch" yq --inplace '.version |= (split(".") | .[ {"major": -3, "minor": -2, "patch": -1}[env(bump)] ] |= ((. tag = "!!int") + 1) | join("."))' galaxy.yml
      ```

    - commits the file and pushes the repo

1. "build" job

    - loads the newly discovered tag as `$version`
    - sets `version` in `galaxy.yml` to `$version`
    - builds the collection
    - stores the collection tarball in an S3 bucket

1. "publish" job

    - triggered by new versions
    - makes the commit for bumping the version
    - creates the git tag with `$version` for this ^^^ commit
    - publishes the collection tarball to Galaxy

# CI Alternative

One instance of the pipeline for each of {`major`, `minor`, `patch`}

Tasks of publish job:

1. Bump the version in `galaxy.yml`
1. Make a commit
1. Add the git tag as per `galaxy.yml`
1. Build the collection
1. Publish the collection
1. Push the repo

That way we do not push the tag unless publishing the collection succeeded, and we don't have to store the tarball between build and publish.
Pipeline instances allow re-use of the very same pipeline config.

# Publishing the Collection Manually

```command
$ ansible-galaxy collection build --force \
  && ansible-galaxy collection publish suhlig-foundation-*.tar.gz --token $(cat ~/.ansible-galaxy-token) \
  ; rm suhlig-foundation-*.tar.gz
```

# Testing the Collection

```command
$ ansible-galaxy collection install suhlig.foundation # append e.g. :==1.2.2 for a specific version
$ ansible-pull --url=https://github.com/suhlig/foundation roles/main/example/local.yml
```
