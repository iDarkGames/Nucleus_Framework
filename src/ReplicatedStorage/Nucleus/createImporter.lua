local t = require(script.Parent.t);
local destructure = require(script.Parent.destructure);
local createPathTraverser = require(script.Parent.createPathTraverser);

type Options = {
	useWaitForChild: boolean?,
	waitForChildTimeout: number?,
	scriptAlias: string?,
	aliases: ({ [string]: Instance })?
}

local Options = t.strictInterface({
	useWaitForChild = t.optional(t.boolean),
	waitForChildTimeout = t.optional(t.number),
	scriptAlias = t.optional(t.string),
	aliases = t.optional(t.table)
});

local checkOuter = t.tuple(t.Instance, t.Instance, t.optional(Options));
local checkInner = t.tuple(t.string, t.optional(t.array(t.string)));

local function createImporter(root: Instance, start: Instance, options: Options)
	assert(checkOuter(root, start, options));
	
	options = options or {};
	
	return function(path: string, exports: ({string})?)
		assert(checkInner(path, exports));
		
		local traverse = createPathTraverser(root, start, options.aliases)
		local instance = traverse(path);
		
		if instance then
			if instance:IsA("ModuleScript") then
				local source = require(instance);
				
				if exports then
					return destructure(source, exports);
				else
					return source;
				end
			else
				return instance;
			end
		end
	end
end


return createImporter;
