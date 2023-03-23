# Pytorch on gfx803-based GPUs

This was created in order to be able to use Stable Diffusion on my RX590 with ROCm hardware acceleration.

This was only tested with Arch Linux. WSL most likely won't work.

After building this image, you can run it with

```
docker run -it -v $HOME:/data --privileged --rm --device=/dev/kfd --device=/dev/dri --group-add video <IMAGE_NAME>
```

where `<IMAGE_NAME>` should be printed by `docker build .` after finishing to run in this directory.

**Note:** My screen goes dark when running this on my system directly. However, it works when used through an SSH
connection, at least after killing the X server and switching to a TTY.
This seems to be due to an issue with ROCm >4.0, which doesn't officially support gfx803 cards anymore.
Unfortunately, the older 3.5 version provided by @xuhuisheng doesn't appear to work for Stable Diffusion (I'd be glad to be proven wrong, however).

- **Update**: As it turned out, there were 2 other reasons:
  1. I had a bug (as in, a litteral insect) stuck in my power connector
  2. My PC was overheating - as it turned out, my PC fans suck and didn't push enough air

  After adressing both of these, it worked for the most part.

- **Final update**

I decided to just get a new GPU, an RTX 2060 12 GB. Even that one runs *waaay* faster than my RX 590, and it does so without issues. For that reason, I cannot maintain this repo (feel free to fork it). You may also consider a Tesla P40, which will probably cost you about the same if you buy it used, and, from what I've read, seems to provide performance comparable to an RTX 3090 (though keep in mind that a lot of the cheap ones were used for crypto mining, as well as the other caviats that come with using a Tesla GPU in your PC).
