local app = {}

local HttpService = game:GetService('HttpService')

function app._renewAuth()
	if app._debug then
		print("Registered refresh token loop")
	end

	while true do
		task.wait(app._refreshFrequency)

		print("Refreshing token")

		local refreshUrl = "https://securetoken.googleapis.com/v1/token?key=" .. app._apiKey
		local payload = {
			grant_type = "refresh_token",
			refresh_token = app._refreshToken
		}

		local status, response = pcall(function()
			return HttpService:PostAsync(refreshUrl, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
		end)

		if status then
			local newAuth = HttpService:JSONDecode(response)
			app._token = newAuth.id_token
			app._refreshToken = newAuth.refresh_token
			app._refreshFrequency = tonumber(newAuth.expires_in) - 100
			if app._debug then
				print("Token refreshed successfully")
			end
		else
			if app._debug then
				warn("Failed to refresh token: " .. tostring(response))
			end
		end
	end
end

function app:collection(collectionName: string)
	return require(script.Collection)(app, collectionName, app._debug)
end

function app:_appendUri(uri: string)
	return app._baseUrl .. uri
end

function app:init(authentication, userInfo, debug)
	app._token = authentication.idToken
	app._refreshToken = authentication.refreshToken
	app._refreshFrequency = tonumber(authentication.expiresIn)
	app._apiKey = userInfo.apikey
	app._projectId = userInfo.projectId
	app._debug = debug
	app._baseUrl = "https://firestore.googleapis.com/v1/projects/"..app._projectId.."/databases/(default)"

	if app._debug then
		print("App created")
	end

	task.spawn(app._renewAuth)

	return self
end

return app