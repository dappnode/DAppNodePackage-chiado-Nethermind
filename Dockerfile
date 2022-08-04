ARG UPSTREAM_VERSION
FROM nethermind/nethermind:${UPSTREAM_VERSION}

# Download chiado config files
RUN apt-get update && apt-get install -y wget && \
    wget -q https://raw.githubusercontent.com/gnosischain/nethermind-client/main/chiado/nethermind_config.cfg -O /config.cfg && \
    wget -q https://raw.githubusercontent.com/gnosischain/nethermind-client/main/chiado/nethermind_genesis.json -O /genesis.json

#Copy jwt secret
COPY jwtsecret.hex /jwtsecret

ENTRYPOINT [ "sh", "-c", "exec ./Nethermind.Runner \ 
    --config=/config.cfg \
    --Init.ChainSpecPath=/genesis.json \
    --JsonRpc.Enabled=true \
    --JsonRpc.JwtSecretFile=/jwtsecret \
    --Init.BaseDbPath=/data \
    --Init.LogDirectory=/data/logs \
    $EXTRA_OPTS" ]