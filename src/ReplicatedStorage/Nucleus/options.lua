local join = require(script.Parent.join);

local options = {}

function options.new(defaults: {[string]: any}, validator: (any) -> boolean)
	local self = {};
	
	self.Values = defaults;
	self.Set = function(options)
		if validator then
			assert(validator(options))
		end
		
		local newValues = join(self.Values, options);
		self.Values = newValues;
		
		return newValues;
	end
	
	return self;
end

return options
