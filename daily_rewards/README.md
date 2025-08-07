# Daily Rewards Script for ESX Legacy

A comprehensive daily rewards system for FiveM ESX Legacy servers with a beautiful ox_lib interface.

## Features

- ✅ 7-day reward cycle system
- ✅ Beautiful ox_lib interface
- ✅ Configurable rewards (money, weapons, items)
- ✅ Database storage for player progress
- ✅ Automatic reset after missed days
- ✅ Optimized for low resource usage
- ✅ Easy configuration system

## Requirements

- ESX Legacy Framework
- ox_lib (for UI)
- oxmysql (for database)

## Installation

1. Download and extract the `daily_rewards` folder to your server's resources directory
2. Import the SQL file `daily_rewards.sql` into your database
3. Add `ensure daily_rewards` to your server.cfg
4. Restart your server

## Configuration

Edit `config.lua` to customize:
- Reward types and amounts
- UI text and styling
- Database settings
- Reset timers

## Usage

- **Command**: `/dailyrewards`
- **Keybind**: F7 (default)
- Players can claim one reward per day
- Progress resets if a day is skipped (more than 48 hours)
- Completes a full 7-day cycle then repeats

## Default Rewards

- Day 1: $5,000
- Day 2: 1x Pistol .50
- Day 3: $10,000
- Day 4: 10x Armor
- Day 5: 2x Pistol .50
- Day 6: $5,000
- Day 7: 1x Combat PDW

## ESX Initialization

This script uses the specific ESX initialization required:
```lua
ESX = exports["kissmyass"]:getSharedObject()
```

## Support

For issues or suggestions, please create an issue on the repository.

## License

MIT License - Feel free to modify and distribute.