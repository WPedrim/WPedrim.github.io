# ESX Aircraft Rental System

A FiveM script for ESX framework that implements an aircraft rental system with cooldown management.

## Features

- **Blip Markers**: Display aircraft rental locations on the map
- **Visual Markers**: Show interactive markers when players are near rental locations
- **ESX Menu Integration**: Uses esx_menu_default for a consistent user experience
- **Aircraft Rental**: Multiple aircraft options with different prices
- **Cooldown System**: 5-minute cooldown per player between rentals
- **Automatic Spawning**: Aircraft are automatically spawned near the rental location

## Requirements

- ESX Framework
- esx_menu_default

## Installation

1. Copy the `esx_aircraft_rental` folder to your FiveM server's resources directory
2. Add `ensure esx_aircraft_rental` to your server.cfg
3. Restart your server or start the resource with `start esx_aircraft_rental`

## Configuration

Edit `config.lua` to customize:

- **Locations**: Aircraft rental locations with coordinates and blip settings
- **Aircraft**: Available aircraft models, prices, and display names
- **Cooldown Time**: Time between rentals (default: 5 minutes)
- **Interaction Distance**: Distance required to interact with markers
- **Marker Settings**: Visual appearance of interaction markers

## Usage

1. Approach any aircraft rental location (marked with a blip on the map)
2. When near the location, you'll see a visual marker and help text
3. Press E to open the aircraft rental menu
4. Select an aircraft and confirm the rental
5. The aircraft will be spawned nearby and you'll be placed inside

## Default Locations

- Los Santos Airport
- Sandy Shores Airfield

## Default Aircraft

- Dodo - $5,000
- Maverick - $7,500
- Buzzard - $10,000
- Luxor - $15,000

## Technical Details

- **Client-side**: Handles blips, markers, menu interactions, and aircraft spawning
- **Server-side**: Manages player cooldowns, money transactions, and validation
- **Shared**: Configuration settings accessible to both client and server

## License

This script is released under MIT License.