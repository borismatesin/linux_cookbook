# GZIPper

Change "+7" to another value if you want to affect files older than that.

```sh
find . ! -name "*.gz" -mtime +7 -type f -exec sudo tar -czf {}.tar.gz {} \; -exec sudo rm {} \;
```

# Eraser

```sh
find . -mtime +30 -type f -exec sudo rm {} \;
```
