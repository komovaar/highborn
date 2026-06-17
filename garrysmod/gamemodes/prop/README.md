# prop
A roleplay framework for Garry's Mod.

## Jobs

Jobs are registered from addons after `prop.Ready`:
registration validates the job name, category, color, model, weapons, salary,
booleans, and callbacks before storing the job.

```lua
prop.onReady("my_addon.Jobs", function()
    prop.category.register("civilians", {
        name = "Civilians",
        color = Color(100, 180, 120),
        sortOrder = 10
    })

    prop.team.register("Citizen", {
        description = "Default public role.",
        category = "civilians",
        color = Color(100, 180, 120),
        model = "models/player/Group01/male_07.mdl",
        weapons = {},
        salary = 50,
        default = true,
        adminOnly = false,
        onCanChange = function(ply, oldTeamID, newTeamID, oldJob, newJob)
            return true
        end,
        onChanged = function(ply, oldTeamID, newTeamID, oldJob, newJob) end,
        onSpawn = function(ply) end
    })
end)
```

Server API:

- `prop.team.set(ply, teamID)` changes a player's job with permission and hook checks.
- `prop.team.apply(ply, teamID, noSpawn)` applies a job directly for internal restore/default flows.
- `prop.team.restore(ply)` restores `team_id` from player data or falls back to the default job.
- `prop.team.assignDefault(ply, noSpawn)` applies the registered default job.
- `prop.team.setDefault(teamID)`, `prop.team.getDefaultID()`, and `prop.team.getDefault()` manage the default job.
- `prop.team.getCategories()` returns a list of currently used category names.
- `prop.team.getByCategory(category)` returns all jobs in a category.
- `prop.category.register(key, data)` registers metadata for a job category.
- `prop.category.get(key)`, `prop.category.all()`, and `prop.category.sorted()` read registered categories.

Change checks run in this order: job exists, unchanged check, `adminOnly`, `prop.CanPlayerChangeTeam`, job `onCanChange`, apply job, job `onChanged`, then `prop.PlayerTeamChanged`.

## Data

Player data is private by default and is stored in `ply.prop`.

Server API:

- `prop.data.get(ply, key, default)` reads stored player data.
- `prop.data.set(ply, key, value)` stores private server-side data only.
- `prop.data.setPublic(ply, key, value)` stores data and syncs that key to the owning client.
- `prop.data.markPublic(ply, key)` marks an existing key as public for that player.
- `prop.data.syncPublic(ply, key)` syncs one public key to the owning client.
- `prop.data.syncPublicAll(ply)` syncs all keys marked public for that player.
- `prop.data.save(ply)` persists data immediately.

Client API:

- `prop.data.localGet(key, default)` reads public data synced to the local player.

## Networking

The framework networking layer is whitelist-based and avoids table serialization for hot paths.

Supported public data value types:

- `nil`
- `boolean`
- `number`
- `string`
- `Color`
- `Vector`
- `Angle`

Limits:

- data keys are limited by `netMaxKeyLength`.
- synced strings are limited by `netMaxStringLength`.
- chat messages are limited by `netMaxChatParts`.

Chat networking only accepts strings, numbers, booleans, and colors. Tables, functions, entities, and arbitrary userdata are rejected instead of being serialized.

## Config

Configuration is shared and available through `prop.config`.

Defaults:

```lua
prop.config.defaults = {
    commandPrefix = "/",
    dataAutosaveInterval = 300,
    defaultJobCategory = "Uncategorized",
    netMaxKeyLength = 64,
    netMaxStringLength = 512,
    netMaxChatParts = 32,
    logLevel = "warn",
    debug = false
}
```

API:

- `prop.config.get(key, default)` reads a configured value or default.
- `prop.config.set(key, value)` changes a value and runs `prop.ConfigChanged`.
- `prop.log(level, message)` prints `debug`, `info`, `warn`, and `error` messages based on `logLevel`.
- `prop.log(message)` is shorthand for a debug message.

## Errors

Addon callbacks are isolated with `prop.safeCall`.

API:

- `prop.safeCall(context, callback, ...)` runs a callback with `pcall` and returns `success, ...`.
- `prop.handleError(context, err)` logs an error and runs `prop.Error`.
- `prop.onReady(identifier, callback)` uses `prop.safeCall` when running callbacks.

Commands and job callbacks also run through `prop.safeCall`, so addon errors are reported without taking down the whole framework.

## Addons

prop is designed to be extended with regular Garry's Mod addons. Put shared addon code in `lua/autorun/sh_my_addon.lua` and wait for `prop.Ready` before registering framework objects:

```lua
if SERVER then AddCSLuaFile() end

prop.onReady("my_addon.Register", function()
    prop.team.register("Worker", {
        description = "Basic worker role.",
        category = "Workers",
        model = "models/player/Group01/male_04.mdl",
        weapons = {"weapon_physgun"}
    })

    if SERVER then
        prop.command.add("worker", {
            description = "Become a worker.",
            usage = "/worker",
            onRun = function(ply)
                return prop.team.set(ply, 2)
            end
        })
    end
end)
```

Addon guidelines:

- Use `prop.onReady` instead of assuming load order.
- Use prop APIs and hooks instead of overriding `GM:*`.
- Store private player data with `prop.data.set`.
- Use `prop.data.setPublic` only for values the owning client should see.
- Keep networking values inside the supported whitelist.

Addon-facing hooks:

- `prop.Initialized`
- `prop.Ready`
- `prop.PostReady`
- `prop.ConfigChanged`
- `prop.PlayerInitialSpawn`
- `prop.PlayerDisconnected`
- `prop.PlayerDataLoaded`
- `prop.PlayerDataSaved`
- `prop.PlayerDataSavedAll`
- `prop.PlayerDataChanged`
- `prop.PlayerLoadout`
- `prop.PlayerSetModel`
- `prop.PlayerSpawn`
- `prop.ChatMessageSent`
- `prop.CanRunCommand`
- `prop.CommandRan`
- `prop.CanPlayerChangeTeam`
- `prop.PlayerTeamChanged`
- `prop.CharacterLoaded`
- `prop.CharacterSaved`
- `prop.CharacterCallsignChanged`
- `prop.MoneyChanged`
- `prop.MoneyTransferred`
- `prop.SalaryPaid`
- `prop.SalaryTick`
- `prop.PlayerArrested`
- `prop.PlayerReleased`
- `prop.Error`

## Commands

Commands are registered on the server:

```lua
prop.command.add("job", {
    description = "Changes your job.",
    category = "Jobs",
    usage = "/job <id>",
    aliases = {"setjob"},
    adminOnly = false,
    onRun = function(ply, args, rawText, commandName)
        return true, "Command ran."
    end
})
```

Server API:

- `prop.command.add(name, data)` registers a chat command.
- `prop.command.get(name)` returns a command by name or alias.
- `prop.command.resolve(name)` returns a command plus its canonical name.
- `prop.command.exists(name)` checks whether a command or alias exists.
- `prop.command.all()` returns the command table.
- `prop.command.sorted()` returns commands sorted by name.
- `prop.command.parse(rawText)` parses a command line into `commandName, args`.

Built-in commands:

- `/help` lists visible commands.
- `/help <command>` shows usage, description, and aliases for one command.

Registration validates command names, descriptions, usage text, aliases, booleans, and callbacks before storing the command.
