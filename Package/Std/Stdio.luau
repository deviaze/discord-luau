return setmetatable({ }, {
	__index = require("@lune/stdio")
})