
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
