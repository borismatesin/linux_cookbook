# GZIPper

Traverses current directory and subdirectories to grab all `f`iles older than `+7` days (that are not `.gz`ips), compresses them and deletes the originals.

```sh
find . ! -name "*.gz" -mtime +7 -type f -exec sudo tar -czf {}.tar.gz {} \; -exec sudo rm {} \;
```

# Eraser

Traverses current directory and subdirectories to grab all `f`iles older than `+30` days and deletes them.

```sh
find . -mtime +30 -type f -exec sudo rm {} \;
```
