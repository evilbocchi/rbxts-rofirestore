local HttpService = game:GetService('HttpService')

firestore = function(userInfo, debug)
	debug = debug or false
	local signInUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=' .. tostring(userInfo.apikey)
	local payload = {
		["email"] = userInfo.email,
		["password"] = userInfo.password,
		["returnSecureToken"] = true
	}
	
	local status, response = pcall(function()
		return HttpService:PostAsync(signInUrl, HttpService:JSONEncode(payload))
	end)
	
	if status then
		if debug then
			print("Signed in to firebase authentication")
		end
		
		return require(script.App):init(HttpService:JSONDecode(response), userInfo, debug)
	else
		warn("Error while signing in!: "..tostring(response))
		warn("Error Response:")
		if debug then
			warn("Error Info:")
			warn("Endpoint:",signInUrl)
			warn("Payload:")
			warn(payload)
			warn("User Info: "..tostring(userInfo))
			warn("Http Enabled: "..tostring(HttpService.HttpEnabled))
		end
		return
	end
end

return firestore