# 🅱️ bootstrap

A shell script that will bootstrap the 🅱️ compiler by incrementally building each version from `v0.0.1` to the latest. To update an existing compiler instead of rebuilding use the `--update` option.

```Bash
Usage: ./bootstrap.sh [argument, ...]
Options:
  -h, --help               Show help
  --update                 Update existing B compiler
  --keep-old               Preserve each build (eg. bc-0.0.1)
```
