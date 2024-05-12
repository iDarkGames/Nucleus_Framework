local splitPath = require(script.Parent.splitPath);
local t = require(script.Parent.t);

local COULD_NOT_RESOLVE_PATH = "'%s' is not the name of a service, alias, or child of current dataModel";
local COULD_NOT_FIND_CHILD = "could not resolve a child %q in %q";

local function createPathTraverser(root: Instance, start: Instance, aliases: table)
	local bHasAscended = false;
	
	aliases = aliases or {};
	
	return function(path: string)
		if path == "/" then
			return root;
		end
		
		local current = start;
		local parts = splitPath(path, root)
		
		for index, pathParth in pairs(parts) do
			local nextInstance = nil;
			
			if index == 1 then
				local coreTable = aliases[pathParth];
				
				if pathParth == root then
					current = root;
					continue;
				elseif pathParth == "." then
					nextInstance = current.Parent;
				elseif coreTable then
					nextInstance = coreTable;
				end
			end
			
			if pathParth == ".." then
				if bHasAscended or index > 1 then
					nextInstance = current.Parent;
				else
					nextInstance = current.Parent.Parent;
					bHasAscended = true;
				end
			end
			
			if not nextInstance then
				if (t.table(current)) then
					for index, coreFolder in pairs(current) do
						local foundInstance = coreFolder:FindFirstChild(pathParth);
						if (foundInstance) then
							nextInstance = foundInstance;
							break;
						end
					end
				elseif (t.Instance(current)) then
					nextInstance = current:FindFirstChild(pathParth);
						
				end
				assert(nextInstance, COULD_NOT_FIND_CHILD:format(pathParth, path));
				
			end
			
			current = nextInstance;
		end
		
		assert(current, COULD_NOT_RESOLVE_PATH:format(path));
		return current;
	end
end

return createPathTraverser;