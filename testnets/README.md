# Hyperia Testnet

This testnet will start with the node version `v0.0.5`.

## Minimum hardware requirements

- 8-16GB RAM
- 100GB of disk space
- 2 cores

## Genesis Instruction

### Install node

```bash
git clone https://github.com/HyperiaNetwork/hyperia.git
cd eve
git checkout v0.0.5 # TODO
make install
```

### Check Node version

```bash
# Get node version (should be v0.0.5)
hyperiad version

# Get node long version (should be 31f4be4340efe6e6b05b819b83fee1ed1c9b280b)
hyperiad version --long | grep commit
```

### Initialize Chain

```bash
hyperiad init MONIKER --chain-id=hype-1
```

### Download genesis

```bash
curl -s https://raw.githubusercontent.com/eve-network/eve/main/testnets/genesis.json > ~/.hyperiad/config/genesis.json
```

## Create gentx

Create wallet

```bash
hyperiad keys add KEY_NAME
```

Fund yourself `1000000000ueve`

```bash
hyperiad genesis add-genesis-account $(hyperiad keys show KEY_NAME -a) 1000000000ueve
```

Use half (`1000000ueve`) for self-delegation

```bash
hyperiad genesis gentx KEY_NAME 1000000uhype --chain-id=hype-1
```

If all goes well, you will see a message similar to the following:

```bash
Genesis transaction written to "/home/user/.hyperiad/config/gentx/gentx-******.json"
```

### Submit genesis transaction

- Fork this repo
- Copy the generated gentx json file to `testnets/gentx/`
- Commit and push to your repo
- Create a PR on this repo

## Setup validator

Set up your node and add seed-nodes

> TODO
<!-- aad13aee1a9e3f55c16364c2af42832fefb2b735@94.130.64.229:26656 -->
