package v1

import (
	feemarkettypes "github.com/skip-mev/feemarket/x/feemarket/types"

	store "cosmossdk.io/store/types"

	"github.com/HyperiaNetwork/hyperia/app/upgrades"
)

const (
	// UpgradeName defines the on-chain upgrade name.
	UpgradeName = "v0.1.0"
)

var Upgrade = upgrades.Upgrade{
	UpgradeName:          UpgradeName,
	CreateUpgradeHandler: CreateUpgradeHandler,
	StoreUpgrades: store.StoreUpgrades{
		Added: []string{
			feemarkettypes.ModuleName,
		},
	},
}
