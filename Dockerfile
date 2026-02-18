# Created by Ashley Watmough - M8WAT
# Maintainer of XLX178 Multi-Mode Reflector - https://xlx.buxton.radio/
#
# Date First Created: 2026-02-17
# Date Last Modified: 2026-02-17
#
# This is my Dockerfile to create a vlmcsd Docker image. It is created in two
# stages to create a smaller final image without the need to "clean-up" the
# vlmcsd source code or installed compilation tools.

# Stage 1 - Download the source code and compile the executable.

FROM alpine:latest as builder

WORKDIR /root

RUN apk add --no-cache git make build-base && \
    git clone --branch master --single-branch https://github.com/M8WAT/vlmcsd.git && \
    cd vlmcsd/ && \
    make

# Stage 2 - Pull the compiled executable from builder & expose TCP port 1688.

FROM alpine:latest

WORKDIR /root/

COPY --from=builder /root/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd

EXPOSE 1688/tcp

CMD [ "/usr/bin/vlmcsd", "-D", "-d" ]