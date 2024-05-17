local LogCore = require("../Vendor/LogCore")

local Task = require("../Std/Task")
local Stdio = require("../Std/Stdio")
local Datetime = require("../Std/Datetime")

local DATE_COLOR_PREFIX = `\27[1;37m`

local implementor
local writer
local formatter

local Logger = {}

local function log(level: number, ...)
	local source = debug.info(level + 2, "s")
	local sourceSplit = string.split(source, "/")

	local sourceName = string.match(sourceSplit[#sourceSplit], "(%S+)\"")

	implementor:log(
		sourceName,
		debug.info(level + 1, "n"),
		writer,
		nil, -- todo: seems like 'toTruncate' doesn't do anyting atm.
		nil,
		...
	)
end

local function err(level: number, ...)
	log(level + 1)

	local thread = coroutine.running()

	Task.defer(function()
		Task.cancel(thread)
	end)

	coroutine.yield()
end

function Logger.trace(...)
	log(1, ...)
end

function Logger.debug(...)
	log(1, ...)
end

function Logger.log(...)
	log(1, ...)
end

function Logger.warn(...)
	log(1, ...)
end

function Logger.error(...)
	err(1, ...)
end

function Logger.critical(...)
	err(1, ...)
end

function Logger.assert(condition, ...)
	if not condition then
		Logger.error(...)
	end
end

function Logger.setEnabled(enabled: boolean)
	writer.flush = enabled
end

return (function()
	writer, formatter = {} :: any, {} :: any

	writer.flush = true

	function writer.writeAll(_, ...)
		return Stdio.format(...)
	end

	function writer.enabled()
		return true
	end

	function formatter.fmt(_, object)
		print(object)

		-- return `{
		-- 	DATE_COLOR_PREFIX
		-- }[{
		-- 	Datetime.fromUnixTimestamp(object.timestamp):formatUniversalTime()
		-- }][{
		-- 	object.target
		-- }]`

		return ``
	end

	implementor = LogCore.Implementor.register(
		writer :: any, -- fixme: fix types!
		formatter :: any, -- fixme: fix types!

		{}
	)

	return Logger
end)()