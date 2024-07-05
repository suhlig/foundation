# Ansible Collection `suhlig.foundation`

Foundation of my Ansible roles

# CI

One instance of the pipeline for each of {`major`, `minor`, `patch`}

Tasks of publish job:

1. Bump the version in `galaxy.yml`

    ```command
    $ bump="patch" yq --inplace '.version |= (split(".") | .[ {"major": -3, "minor": -2, "patch": -1}[env(bump)] ] |= ((. tag = "!!int") + 1) | join("."))' galaxy.yml
    ```

1. Make a commit
1. Add the git tag as per `galaxy.yml`

    ```command
    $ version=$(yq .version galaxy.yml)
    $ git tag -a $version -m "Release $version"
    ```

1. Build the collection

    ```command
    $ ansible-galaxy collection build --force
    ```

1. Publish the collection

    ```command
    $ ansible-galaxy collection publish suhlig-foundation-*.tar.gz --token $(cat ~/.ansible-galaxy-token); rm suhlig-foundation-*.tar.gz
    ```

1. Push the repo

    ```command
    $ git push --follow-tags
    ```

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
