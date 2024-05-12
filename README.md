# Nucleus Framework

Nucleus is meant to be a module script importer predominantly used in the Roblox ecosystem. This is a direct fork from vocksel's importer => [vocksel_import](https://github.com/vocksel/import/)

I take no credit whatsoever of how the importer is structured, all credit goes to its respective authors. However, there are some slight modifications to the structure in regards to how it fetches
module scripts, splitting the behaviour in what is defined as **'Cores'**, there are **three** different ones:

- **SharedCore**: All module scripts that will be replicated between server and client.
- **ServerCore**: All module scripts that will be only replicated to the server.
- **ClientCore**: All module scripts that will be only replicated to the client.

By having this separation, it allows the user to have multiple folders where the content will be searched for, this is the difference with vocksel's where it only allowed to have one specific root service to search from.
(Not a big difference, imo).

# Usage

Initially the user will need to go to the **environment** script to be able to modify the folder structure, an example structure would be:

```lua
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local ServerScriptService = game:GetService("ServerScriptService");
local ServerStorage = game:GetService("ServerStorage");

local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts");
local StarterCharacterScripts = game:GetService("StarterPlayer"):WaitForChild("StarterCharacterScripts");

-- Add Instances (Folders) for each context:

local Environment = {
    ["SharedCore"] = {
        ReplicatedStorage.SharedCore,
        ReplicatedFirst.SharedCore,
    },
    ["ServerCore"] = {
        ServerScriptService.ServerCore
    },
    ["ClientCore"] = {
        StarterPlayerScripts.ClientCore
    }
};

return Environment
```

An example module is created within the Replicated Storage under its SharedCore folder with the following code:
```lua
local ExampleModule = {}

ExampleModule.Foo = function()
    print("Foo!");
end

ExampleModule.Bar = function()
    print("Bar!");
end

ExampleModule.NucleusPrint = function()
    print("Nucleus!");
end

return ExampleModule
```

Afterwards one can attempt to import an **ExampleModule** within the SharedCore environment:
```lua

local Import = require(game.ReplicatedStorage.Nucleus);

local ExampleModule = Import("SharedCore/ExampleModule");

ExampleModule.Foo();

```

Likewise this still keeps the **destructuring** nature of Vocksel's importer with the following example being able to extract two specific functions from the example module:
```lua
local Import = require(game.ReplicatedStorage.Nucleus);

local Foo, Bar = Import("SharedCore/ExampleModule", {"Foo", "Bar"});

Foo();
Bar();

```

## Other

- **Created by: iDarkGames**
- **Direct fork from:** https://github.com/vocksel/import/
- **Last Update: 12/05/2024 15:23 (GMT+1)**
