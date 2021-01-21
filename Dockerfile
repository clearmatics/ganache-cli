FROM mhart/alpine-node:10 as builder

RUN apk --update --no-cache add \
    make \
    gcc \
    g++ \
    python \
    git \
    bash \
    cmake \
    libressl-dev \
    gmp-dev \
    procps-dev \
    pkgconfig \
    build-base \
    boost-dev \
    libxslt-dev \
    rsync

WORKDIR /app
COPY . .

# See: https://github.com/npm/npm/issues/17346
RUN npm config set unsafe-perm true && npm install
RUN npx webpack-cli --config ./webpack/webpack.docker.config.js

## TODO: Uncomment and fix the lines below to have a more efficient
## multi-stage build (to shrink the image size)
#FROM mhart/alpine-node:10 as runtime
#
#WORKDIR /app
#
#COPY --from=builder "/app/node_modules/scrypt/build/Release" "./node_modules/scrypt/build/Release/"
#COPY --from=builder "/app/node_modules/sha3/build/Release" "./node_modules/sha3/build/Release/"
#COPY --from=builder "/app/node_modules/ganache-core/node_modules/websocket/build/Release" "./node_modules/ganache-core/node_modules/websocket/build/Release/"
#COPY --from=builder "/app/build/ganache-core.docker.cli.js" "./ganache-core.docker.cli.js"
#COPY --from=builder "/app/build/ganache-core.docker.cli.js.map" "./ganache-core.docker.cli.js.map"

# Set the docker environment to listen on 0.0.0.0
# https://github.com/clearmatics/ganache-cli/blob/v6.10.1-clearmatics/args.js#L15
ENV DOCKER true

EXPOSE 8545

# Further flags can be passed when starting the container (see README.md)
ENTRYPOINT ["node", "cli.js"]
