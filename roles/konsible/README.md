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

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `konsible_app_name` | `"app"` | The name of the container and prefix for Traefik labels |
| `konsible_app_env` | `{}` | Environment variables to pass to the container |
| `konsible_domain` | `"{{ domain }}"` | The domain for the Traefik router |
| `konsible_docker_network` | `traefik` | The Docker network Traefik is connected to |
| `konsible_package` | `"."` | The Go package name to build |
| `konsible_platform` | `"linux/arm64"` | The platform to build for |
| `konsible_port` | `"8080"` | The port the app listens on inside the container |
| `konsible_labels` | `{}` | Additional labels to add to the container |

### Example with environment variables

```yaml
- name: Deploy my app
  hosts: all
  roles:
    - role: suhlig.foundation.konsible
      vars:
        konsible_package: "github.com/example/myapp"
        konsible_app_name: "myapp"
        konsible_app_env:
          DATABASE_URL: "postgres://user:pass@db.example.com:5432/mydb"
          LOG_LEVEL: "info"
```
