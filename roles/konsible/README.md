# konsible

An opinionated Ansible role to build and deploy Go HTTP servers as Docker containers behind Traefik.

# Prerequisites

- **Docker** must be installed and running on the target host
- **`pussh` Docker Plugin** must be installed on the control machine to push images directly to the target host's Docker daemon via SSH
- **Traefik** must be installed and running on the target host, acting as the ingress router
- **Go** must be installed on the control machine
- **`ko`** must be available control machine, preferrably added as tool dependency using `go get -tool github.com/google/ko`

# Usage

```yaml
- name: Deploy my app
  hosts: all
  roles:
    - role: suhlig.foundation.konsible
      vars:
        konsible_package: "github.com/example/myapp"
        konsible_app_name: "myapp"
```
