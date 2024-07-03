# Ansible Collection `suhlig.foundation`

Foundation of my Ansible roles

# CI

TODO - not yet fully spec'd out

1. "bump" job

    - bumps the version (major, minor or patch)
    - publishes the new version number (represented in metadata branch or by name of the collection in S3 bucket)

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

# Publishing the Collection Manually

```command
$ ansible-galaxy collection build --force \
  && ansible-galaxy collection publish suhlig-foundation-*.tar.gz --token $(cat ~/.ansible-galaxy-token) \
  ; rm suhlig-foundation-*.tar.gz
```
