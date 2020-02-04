# Small & Secure Containers with Go

This repository tells a story of reaching small and secure containers with go

The example is a very basic application, not using a whole bunch of features but 2 carefully selected ones.

## Steps

Create all examples by `for i in 1 2 3 4 5 6; do docker build -t small_$i -f $i/Dockerfile .; done;`. 
Run a single one then by using `docker run small-$EXAMPLE_NUMBER`.

### 1

Just plain containerization, no security hardening 

* Very big resulting image >390MB

### 2

Using Multistage Build (Alpine), no security hardening

* Small image, no build environment
* but no timezone data, so application not running as expected

### 3

Using Multistage Build (Alpine), providing timezone, no security hardening

* Small image (~15MB)
* Application fine

### 4

Switching to scratch (empty image for base), so no further tooling on container (good for security)

* NOT USABLE (in our case as `http` needs dynamic linked libraries)

### 5

using `ldd` to find applications dynamic dependencies, copying them via `/dist` on the final container

* Small Image
* No further tools in container (restricts misuse in case of application problems)

### 6

further hardening by running application as unprivileged user, further optimization by stripping debug information IN BUILD.

* Smallest Image
* No further tools in container (restricts misuse in case of application problems)
* Application running as a unprivileged user in container

## Final Result

`\Dockerfile` has one more optimization, as it also works if the application has no dynamic dependencies, and could be used as a template

Size Results:
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
small_6             latest              36aefe8e63f7        11 minutes ago      7.13MB
small_5             latest              2868e743db3f        11 minutes ago      9MB
small_4             latest              d1a539d38de3        12 minutes ago      8.17MB
small_3             latest              16eb9d6f6a01        About an hour ago   15.5MB
small_2             latest              41ad7c65456d        About an hour ago   12.6MB
small_1             latest              d929945c0314        12 minutes ago      391MB
```

## Further security hardening:

Basically two more points are still open for securing your application:
* Trust the images! Secure Trust by sha256 sums instead of tags. You can find those via `docker image inspect $your_image`
* Trust for dependencies (vendoring, modules from trusted sources, ...)

## Disclaimer

Use at own risk, I have not done a thorough security analysis of the containers, so think of your own strategies for hardening. Hardening containers is not sufficient for achieving secure applications. Always secure your applications on multiple layers.

## Acknowledgement
Based on the following blog posts:

* [Create the smallest and secured golang docker image based on scratch](https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324)
* [Go — build a minimal docker image in just three steps](https://dev.to/ivan/go-build-a-minimal-docker-image-in-just-three-steps-514i)