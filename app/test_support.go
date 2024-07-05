package app

import (
	"github.com/cosmos/cosmos-sdk/baseapp"
	authkeeper "github.com/cosmos/cosmos-sdk/x/auth/keeper"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	stakingkeeper "github.com/cosmos/cosmos-sdk/x/staking/keeper"

	capabilitykeeper "github.com/cosmos/ibc-go/modules/capability/keeper"
	ibckeeper "github.com/cosmos/ibc-go/v8/modules/core/keeper"

	wasmkeeper "github.com/CosmWasm/wasmd/x/wasm/keeper"
)

func (app *HyperiaApp) GetIBCKeeper() *ibckeeper.Keeper {
	return app.IBCKeeper
}

func (app *HyperiaApp) GetScopedIBCKeeper() capabilitykeeper.ScopedKeeper {
	return app.ScopedIBCKeeper
}

func (app *HyperiaApp) GetBaseApp() *baseapp.BaseApp {
	return app.BaseApp
}

func (app *HyperiaApp) GetBankKeeper() bankkeeper.Keeper {
	return app.BankKeeper
}

func (app *HyperiaApp) GetStakingKeeper() *stakingkeeper.Keeper {
	return &app.StakingKeeper
}

func (app *HyperiaApp) GetAccountKeeper() authkeeper.AccountKeeper {
	return app.AccountKeeper
}

func (app *HyperiaApp) GetWasmKeeper() wasmkeeper.Keeper {
	return app.WasmKeeper
}
