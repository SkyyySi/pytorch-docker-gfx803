# Pytorch on RX590

This was created in order to be able to use stable diffusion on my RX590 with ROCm hardware acceleration.

After building this image, you can run it with

```
docker run -it -v $HOME:/data --privileged --rm --device=/dev/kfd --device=/dev/dri --group-add video <IMAGE_NAME>
```

where `<IMAGE_NAME>` should be printed by `docker build .` after finishing to run in this directory.
