# givt-app-kids

## Prerequisites

To get started with this project please install [rbenv][rbenv_repo] to ensure the correct podfiles are generated.


### Makefile support

Alternatively, we have a `Makefile` to help with these commands, as well as other frequent commands:

```sh
# Run Development Flavor
make run_dev

# Run Staging Flavor
make run_staging

# Run Production Flavor
make run_prod

# Run Linter
make lint

# Gets Packages
make get

# Installs Custom Packages
make melos

# Runs All Tests
make test
```