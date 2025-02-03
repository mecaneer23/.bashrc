# .bashrc

This is my personal bashrc.

## Install as standalone file

```bash
mv ~/.bashrc ~/.bashrc.old; curl -f https://raw.githubusercontent.com/mecaneer23/.bashrc/main/.bashrc -o ~/.bashrc && source ~/.bashrc
```

## Install as repository

Make sure curl is installed. If not, install curl.

```bash
curl -V || sudo apt install curl
```

Install .bashrc as repository.

```bash
source <(curl -s -L https://raw.githubusercontent.com/mecaneer23/.bashrc/main/.bashrc) && install-bashrc
```
