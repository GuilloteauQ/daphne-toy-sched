# Toy Scheduler in DAPHNE

This repo contains a small scheduler for [DAPHNE](https://github.com/daphne-eu/daphne).

## What's in there ?

You can see the patch adding the toy scheduler in `src/cst_sched.patch` 

My notes are available in `notes.org`

## The toy scheduler

This toy scheduler (`CST`) allows end users to determine a fixed task size.

To define the task size, i opted for using the environment variable `DAPHNE_CST_TASK_SIZE`.

```
$ DAPHNE_CST_TASK_SIZE=42 daphne --vec --num-threads=4 --select-matrix-representations --partitioning=CST --args f=\"./data/Amazon0601_0.csv\" --args iterations=1 src/components_read.daphne
```

If you try to use the `CST` scheduling policy without the `DAPHNE_CST_TASK_SIZE` environment variable, the paritionning will be done with MFSC, and an error message will be displayed. 

```
$ daphne --vec --num-threads=4 --select-matrix-representations --partitioning=CST --args f=\"./data/Amazon0601_0.csv\" --args iterations=1 src/components_read.daphne
Env. variable DAPHNE_CST_TASK_SIZE not set! Falling back on MFSC
```

## Reproduce

DAPHNE is not packaged with [Nix](https://nixos.org), which makes it difficult to have reproducible software environments, and thus, also experiments.

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

This repo offers several environments (or shells):

- `nix develop .#daphne-shell`: shell with `daphne v0.2`

- `nix develop .#daphne-cst-shell`: shell with `daphne v0.2` with the `CST` scheduling policy

- `nix develop`: shell with `snakemake` to run experiments (`snakemake -c 1`)

- `nix develop .#rshell`: shell with some R dependencies

### Download the data

The dataset is not in this repository, so we need to download it:

```
nix develop --command snakemake -c2 data/Amazon0601_0.csv data/Amazon0601_0.csv.meta
```

### Run some experiments from the D5.2 delivrable

We do not replay all the commands of the delivrable, but we perform a simple strong scaling experiment where we increase the number of threads for each policy (excluding SS) for the same input size.

```
nix develop --command snakemake -c1 plots/all.pdf
```

You might want to modify the `config/config.yaml` to change some parameters

### Run experiments with the CST policy

We perform a small evaluation of the `CST` scheduling policy.

You can run it with:

```
nix develop --command snakemake -c1 plots/cst.pdf
```

You might want to modify the `config/config.yaml` to change some parameters
