# Building OpenCV with Docker

## Decisions

- No gui, this is for an embeded system
    - Disabled: gapi, highgui, QT, gtk
- OpenGL is installed to `/opt/vc`
- Only c++ and python3
- Only simple image formats: png, jpeg, tiff
- Video is only v4l/v4l2


## Build

1. `docker-compose build`
2. `docker-compose up`

---

# Old

**not working yet**

1. Enable ARM emulation: `docker run --rm --privileged hypriot/qemu-register`
1. Build image: `./sdock.sh build`
1. Run container: `./sdock.sh run`

## Notes:

- it seems really slow ... almost as fast just to run on a Pi
