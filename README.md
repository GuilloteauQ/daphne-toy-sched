# Toy Scheduler in DAPHNE

This repo contains a small scheduler for DAPHNE.

## What's in there ?

You can see the patch in `src/cst_sched.patch` 

My notes are available in `notes.org`

## Reproduce

DAPHNE is not packaged with Nix, which makes it difficult to have reproducible experiments.

### Nix

```
# Install Nix
bash <(curl -L https://nixos.org/nix/install)

# Activate flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Daphne package

My (quick and dirty) package of DAPHNE (v0.2) is available at https://github.com/GuilloteauQ/daphne-nix

You can enter a shell with `daphne` with `nix shell github:GuilloteauQ/daphne-nix#daphne`.

As `daphne` requires to build some specific versions of MLIR, ANTLR, etc., you can use this binary cache to not recompile everything: https://daphne-nix.cachix.org

```
# Install cachix
nix-env -iA cachix -f https://cachix.org/api/v1/install

# Enable the binary cache for your builds
cachix use daphne-nix
```

### Available Shells

- `nix develop .#daphne-shell`: shell with `daphne v0.2`

- `nix develop .#daphne-cst-shell`: shell with `daphne v0.2` with the `CST` scheduling policy

- `nix develop`: shell with `snakemake` to run experiments (`snakemake -c 1`)

- `nix develop .#rshell`: shell with some R dependencies
