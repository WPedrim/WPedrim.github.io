# Installation Guide - Daily Rewards Script

## Step-by-Step Installation

### 1. Prerequisites
Ensure your server has the following resources installed and working:
- ESX Legacy Framework
- ox_lib (latest version)
- oxmysql

### 2. Download and Setup
1. Download the `daily_rewards` folder from this repository
2. Place it in your server's `resources` folder
3. The structure should look like this:
   ```
   resources/
   └── daily_rewards/
       ├── fxmanifest.lua
       ├── config.lua
       ├── server.lua
       ├── client.lua
       ├── daily_rewards.sql
       └── README.md
   ```

### 3. Database Setup
1. Open your database management tool (phpMyAdmin, HeidiSQL, etc.)
2. Select your ESX database
3. Import or execute the SQL file: `daily_rewards.sql`
4. Verify the table `daily_rewards` was created successfully

### 4. Server Configuration
Add the following line to your `server.cfg` file:
```
ensure daily_rewards
```

### 5. Restart Server
Restart your FiveM server completely to load the new resource.

## Verification

### Test the Installation
1. Join your server
2. Use the command `/dailyrewards` or press `F7`
3. The daily rewards menu should appear
4. Try claiming Day 1 reward
5. Check your money/inventory to confirm the reward was given

### Common Issues

#### "Script Error" or "Resource Failed to Start"
- Check your server console for error messages
- Ensure all dependencies (ESX, ox_lib, oxmysql) are running
- Verify the fxmanifest.lua syntax

#### Database Errors
- Make sure the SQL table was created successfully
- Check database connection in your server
- Verify oxmysql is properly configured

#### UI Not Showing
- Ensure ox_lib is up to date
- Check browser console (F12) for JavaScript errors
- Verify ESX initialization is correct

## Configuration

### Customizing Rewards
Edit `config.lua` to change:
- Reward types (money, items, weapons)
- Reward amounts
- Reward descriptions
- UI text and colors

### ESX Compatibility
This script uses the specific ESX initialization:
```lua
ESX = exports["kissmyass"]:getSharedObject()
```

If your server uses a different export name, update both `server.lua` and `client.lua` files.

## Support

If you encounter issues:
1. Check the server console for error messages
2. Verify all prerequisites are met
3. Review the troubleshooting section above
4. Create an issue on the repository with detailed error information