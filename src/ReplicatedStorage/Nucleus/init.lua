local t = require(script.t);
local createImporter = require(script.createImporter);
local options = require(script.options);
local join = require(script.join);
local NucleusEnvironment = require(script.environment);

warn ("\n\t@> [START] Nucleus Engine {v1.0.0}\n\t@> Created by iDarkGames\n\t@> github repo: https://github.com/iDarkGames/Nucleus_Framework \
  \n\
  This importer is a fork from vocksel. [https://github.com/vocksel/import/] with slight modifications in regards to folder structure and path traverse fetching. \
  \n Nucleus splits the folders into cores, 'SharedCore', 'ServerCore' and 'ClientCore', under those cores, you can have multiple folders of any kind for module fetching.");

local ImporterConfig = options.new(
	{
		root = game,
		useWaitForChild = false,
		waitForChildTimeout = 1,
		scriptAlias = "script"
	},
	t.strictInterface({
		root = t.optional(t.Instance),
		useWaitForChild = t.optional(t.boolean),
		waitForChildTimeout = t.optional(t.number),
		scriptAlias = t.optional(t.string)
	})
);

local aliases = options.new({}, t.map(t.string, t.array(t.Instance)))

local check = t.tuple(t.string, t.optional(t.array(t.string)));


local function importWithCallingScript(caller: BaseScript, path: string, exports: ({string})?)
	assert(check(path, exports))
	
	local import = createImporter(ImporterConfig.Values.root, caller, {
		useWaitForChild = ImporterConfig.Values.useWaitForChild,
		waitForChildTimeout = ImporterConfig.Values.waitForChildTimeout,
		scriptAlias = ImporterConfig.Values.scriptAlias,
		aliases = join(aliases.Values, {
			[ImporterConfig.Values.scriptAlias] = caller
		}, NucleusEnvironment)
	});
	
	return import(path, exports);
end

local function getCallerInstance(root : Instance, callerPath : string)
	local splitPath = callerPath:split(".");
	local instanceName = splitPath[#splitPath];
	
	local current = root;
	for index, value in pairs(splitPath) do
		current = current[value];
	end
	
	return current;
end

local api = setmetatable({
	setConfig = ImporterConfig.Set,
	import = function(path: string, exports: ({ string })?)
		local callerFullPath = debug.info(2, "s");
		local callerInstance = getCallerInstance(game, callerFullPath);
		return importWithCallingScript(callerInstance, path, exports)
	end,
}, {
	__call = function(_, path: string, exports: ({string})?)
		local callerFullPath = debug.info(2, "s");
		local callerInstance = getCallerInstance(game, callerFullPath);
		return importWithCallingScript(callerInstance, path, exports);
	end,
})


return api
