# Hyperia Network Testnet ( soon&#8482; )

This testnet will start with the node version `0.0.2`.

## Minimum hardware requirements

- 8-16GB RAM
- 100GB of disk space
- 2 cores

## Genesis Instruction

### Install node

```bash
git clone https://github.com/HyperiaNetwork/hyperia.git
cd hyperia
git checkout v0.0.2 # TODO
make install
```

### Check Node version

```bash
# Get node version (should be v0.0.2) # TODO
hyperiad version

# Get node long version (should be 25e1602d5a29e4ab49addda7e4178b50894999df)
hyperiad version --long | grep commit
```

### Initialize Chain

```bash
rm -rf ~/.hyperiad
hyperiad init develop --chain-id=hype-1
```

### Replace pre-genesis

```bash
# Download the file
curl -s https://raw.githubusercontent.com/HyperiaNetwork/hyperia/main/testnets/genesis.json > ~/.hyperiad/config/genesis.json

# Calculate the SHA256 checksum
calculated_checksum=$(shasum -a 256 ~/.hyperiad/config/genesis.json | awk '{ print $1 }')

# Compare with the expected checksum
expected_checksum="244d5a3999dd0851eb338b032a57fbea24a89b4016a7907a9d20c2045c689857"
if [ "$calculated_checksum" = "$expected_checksum" ]; then
    echo "---> Checksum is CORRECT."
else
    echo "---> Checksum is INCORRECT."
fi
```

## Run node

### Setup seeds

```bash
export PERSISTENT_SEEDS=""
```

### Run node with persistent peers

```bash
hyperiad start --p2p.persistent_peers=$PERSISTENT_SEEDS
```
