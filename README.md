# 🏴‍☠️ op-tcg-auto-scripts

Collection of bash scripts to farm cards on [op-tcg website](https://github.com/Lambpaul/op-tcg)

## Setup

### ⚠️ Required

These dependencies are required for all scripts to function properly:
- **Bash:** https://en.wikipedia.org/wiki/Bash_(Unix_shell)
- **jq:** https://github.com/jqlang/jq

### 🌈 Optional

These dependencies are only for making things prettier:
- **gum:** https://github.com/charmbracelet/gum
- **figlet:** https://github.com/cmatsuoka/figlet
- **lolcat:** https://github.com/busyloop/lolcat

> [!NOTE]
> With a tiny bit of tweaking, you can remove all usages of `gum`, `figlet` and `lolcat` and the script will continue working well.

## Usage

Two automatic scripts:
- [auto-open-boosters.sh](auto-open-boosters.sh): opens the configured booster in a loop
- [auto-seller.sh](auto-seller.sh): sell cards by sorting them by most valuable gain

The other scripts are sub-scripts that are called by the two main scripts.

### 🃏 auto-open-boosters.sh

1. Open [auto-open-boosters.sh](auto-open-boosters.sh)
2. Set `PACK_ID` to the pack you want to farm
3. Run:
```console
bash auto-open-boosters.sh
```

### 🃏 auto-seller.sh

1. Simply run and it will do all the work for you:
```console
bash auto-seller.sh
```

> [!NOTE]
> Some info on how it behaves:
> - Automatically sells cards of the following rarities: `common`, `uncommon`, `rare`, `leader`, `super_rare`
> - Sells card by sorting them by most profit (`(.quantity - 1) * .sell_price`)
> - Stops selling when profit of a sell order is not greater than 10
> - Will always keep at least one copy of any given card (imposed by the op-tcg server)

### ⏳ Wait and Rate limiting

Both automatic scripts rely on a very specific timeout between automated actions:
- **WAIT_LONG**: Based on per-hour action limit
- **WAIT_MEDIUM** Based on per-minute action limit
- **WAIT_LOW** Based on min delay action limit

The longer the wait, the slower the script will execute. But if you do things slowly, you also reduce the chances
of the server imposing rate limiting on you. If the server deems you too suspicious, your account can get blocked for some time.

If you stick to `WAIT_LONG`, you should be able to run these scripts forever without the server detecting anything.

If you want to switch gears, it's at your own risk 💀

<img width="400" height="224" alt="image" src="https://github.com/user-attachments/assets/5430fb99-ce49-4389-8633-fad69f88e360" />
