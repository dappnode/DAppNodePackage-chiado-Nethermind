ARG UPSTREAM_VERSION
FROM debian:buster-slim as binary

RUN DEBIAN_FRONTEND=noninteractive \
    apt update && apt install --assume-yes --no-install-recommends wget ca-certificates && \
    wget -q https://raw.githubusercontent.com/gnosischain/nethermind-client/main/chiado/nethermind_config.cfg -O /usr/config.cfg && \
    wget -q https://raw.githubusercontent.com/gnosischain/nethermind-client/main/chiado/nethermind_genesis.json -O /usr/genesis.json



FROM nethermind/nethermind:${UPSTREAM_VERSION}

# Download chiado config files
COPY --from=binary /usr/genesis.json /usr/genesis.json
COPY --from=binary /usr/config.cfg //usr/config.cfg

#Copy jwt secret
COPY jwtsecret.hex /jwtsecret

ENTRYPOINT [ "sh", "-c", "exec ./Nethermind.Runner \ 
    --config=/usr/config.cfg \
    --Init.ChainSpecPath=/usr/genesis.json \
    --JsonRpc.Enabled=true \
    --JsonRpc.JwtSecretFile=/jwtsecret \
    --Init.BaseDbPath=/data \
    --Init.LogDirectory=/data/logs \
    $EXTRA_OPTS" ]