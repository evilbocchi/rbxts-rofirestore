local module = {}

local function isArray(t)
	if type(t) ~= "table" then return false end

	local count = 0
	for k, _ in pairs(t) do
		if type(k) ~= "number" then
			return false
		end
		if k % 1 ~= 0 or k <= 0 then
			return false
		end
		count += 1
	end

	for i = 1, count do
		if t[i] == nil then
			return false
		end
	end

	return true
end

local function isoToUnix(isoTimestamp: string): number
	local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%.(%d+)Z"
	local year, month, day, hour, min, sec, ms = isoTimestamp:match(pattern)

	if not (year and month and day and hour and min and sec and ms) then
		error("Invalid ISO 8601 format")
	end

	local dateTable = {
		year = tonumber(year),
		month = tonumber(month),
		day = tonumber(day),
		hour = tonumber(hour),
		min = tonumber(min),
		sec = tonumber(sec),
	}

	-- os.time() assumes local time, but ISO is UTC, so use os.time(date) - os.time(os.date("!*t")) + os.time()
	local unixLocal = os.time(dateTable)
	local utcOffset = os.difftime(os.time(), os.time(os.date("!*t")))
	return unixLocal - utcOffset + tonumber(ms) / 1000
end

function module:convertToRoblox(response)
	for key, value in pairs(response.fields) do
		if value.stringValue then
			response.fields[key] = value.stringValue
		elseif value.integerValue then
			response.fields[key] = value.integerValue
		elseif value.doubleValue then
			response.fields[key] = value.doubleValue
		elseif value.floatValue then
			response.fields[key] = value.floatValue
		elseif value.booleanValue then
			response.fields[key] = value.booleanValue
		elseif value.geoPointValue then
			response.fields[key] = value.geoPointValue
		elseif value.mapValue then
			response.fields[key] = module:convertToRoblox(value.mapValue)
		elseif value.timestampValue then
			response.fields[key] = isoToUnix(value.timestampValue)
		elseif value.arrayValue then
			local res = {
				fields = value.arrayValue.values
			}
			response.fields[key] = module:convertToRoblox(res)
		else
			response.fields[key] = nil
		end
	end
	return response.fields
end

function module:convertToGQL(data)
	for key, value in pairs(data) do
		if type(value) == "string" then
			data[key] = {
				stringValue = value
			}
		elseif type(value) == "number" then
			data[key] = {
				doubleValue = value
			}
		elseif type(value) == "boolean" then
			data[key] = {
				booleanValue = value
			}
		elseif typeof(value) == "Color3" then
			data[key] = {
				mapValue = {
					fields = module:convertToGQL({r = value.R, g = value.G, b = value.B})
				}
			}
		elseif typeof(value) == "Vector3" then
			data[key] = {
				mapValue = {
					fields = module:convertToGQL({r = value.X, g = value.Y, b = value.Z})
				}
			}
		elseif typeof(value) == "BrickColor" then
			data[key] = {
				mapValue = {
					fields = module:convertToGQL({r = value.Color.R, g = value.Color.G, b = value.Color.B})
				}
			}
		elseif type(value) == "table" then
			if isArray(value) then
				data[key] = {
					arrayValue = {
						values = module:convertToGQL(value)
					}
				}
			else
				data[key] = {
					mapValue = {
						fields = module:convertToGQL(value)
					}
				}
			end
		end
	end
	return data
end

return module
