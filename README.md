# Ansible Collection `suhlig.foundation`

Foundation of my Ansible roles

# Publishing the Collection

```command
$ ansible-galaxy collection build --force
$ ansible-galaxy collection publish suhlig-foundation-"$version".tar.gz --token $(cat ~/.ansible-galaxy-token)
```
