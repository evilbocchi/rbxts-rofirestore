local HttpService = game:GetService('HttpService')
local FieldsFixer = require(script.Parent.FieldsFixer)

collection = function (app, collectionId: string)
	local collectionClass = {}

	-- Gets a specific doc
	function collectionClass:getDocument(docId: string)
		local headers = {
			["Authorization"] = "Bearer " .. app._token
		}

		local status, response = pcall(function()
			return HttpService:GetAsync(app:_appendUri("/documents/" .. collectionId .. "/" .. docId .. "/"), true, headers)
		end)

		if status then 
			if response then
				response = HttpService:JSONDecode(response)
				response.fields = FieldsFixer:convertToRoblox(response)

				if app._debug then
					print("GetDoc Response:")
					print("URL: " .. app:_appendUri("/documents/" .. collectionId .. "/" .. docId .. "/"))
					print("Headers: " .. HttpService:JSONEncode(headers))
					print("Response: " .. HttpService:JSONEncode(response))
				end

				return response
			else
				if app._debug then
					print("GetDoc Response was empty")
				end
				return
			end
		else
			if app._debug then
				warn("Error while getting document: " .. error)
			end
		end
	end

	-- Lists all docs
	function collectionClass:getDocuments()
		local headers = {
			["Authorization"] = "Bearer " .. app._token
		}

		local status, response = pcall(function()
			return HttpService:GetAsync(app:_appendUri("/documents/" .. collectionId .. "/"), true, headers)
		end)

		if status then 
			if HttpService:JSONDecode(response).documents then
				response = HttpService:JSONDecode(response).documents
				for key, value in pairs(response) do
					response[key] = FieldsFixer:convertToRoblox(value)
				end

				if app._debug then
					print("GetDocs Response:")
					print("URL: " .. app:_appendUri("/documents/" .. collectionId .. "/"))
					print("Headers: " .. HttpService:JSONEncode(headers))
					print("Response: " .. HttpService:JSONEncode(response))
				end

				return response
			else 
				if app._debug then
					print("GetDocs Response does not contain documents")
				end
				return
			end
		else
			if app._debug then
				warn("Error while getting documents: " .. error)
			end
		end
	end

	-- Create a new document in the collection
	function collectionClass:createDocument(documentData: {any}, documentId: string)
		local headers = {
			["Authorization"] = "Bearer " .. app._token,
			["Content-Type"] = "application/json"
		}

		local body = HttpService:JSONEncode({
			fields = FieldsFixer:convertToGQL(documentData)
		})

		if app._debug then
			print("Creating Document:")
			print("URL: " .. (documentId and app:_appendUri("/documents/" .. collectionId .. "?documentId=" .. documentId) or app:_appendUri("/documents/" .. collectionId)))
			print("Headers: " .. HttpService:JSONEncode(headers))
			print("Body: " .. body)
		end

		local status, response = pcall(function()
			if documentId then
				return HttpService:RequestAsync({
					Url = app:_appendUri("/documents/" .. collectionId .. "?documentId=" .. documentId),
					Method = "POST",
					Headers = headers,
					Body = body
				})
			else
				return HttpService:RequestAsync({
					Url = app:_appendUri("/documents/" .. collectionId),
					Method = "POST",
					Headers = headers,
					Body = body
				})
			end
		end)

		if status then
			if response.StatusCode == 200 then
				local responseData = HttpService:JSONDecode(response.Body)
				responseData.fields = FieldsFixer:convertToRoblox(responseData)

				if app._debug then
					print("Document created successfully!")
					print("Response: " .. HttpService:JSONEncode(responseData))
				end

				return responseData
			else
				if app._debug then
					warn("Error creating document: " .. response.StatusCode .. " " .. response.Body)
				end
			end
		else
			if app._debug then
				warn("Error creating document: " .. response)
			end
		end
	end

	-- Edit a document in the collection
	function collectionClass:updateDocument(documentData: {any}, documentId: string)
		local headers = {
			["Authorization"] = "Bearer " .. app._token,
			["Content-Type"] = "application/json"
		}

		local body = HttpService:JSONEncode({
			fields = FieldsFixer:convertToGQL(documentData)
		})

		if app._debug then
			print("Updating Document:")
			print("URL: " .. app:_appendUri("/documents/" .. collectionId .. "/" .. documentId))
			print("Headers: " .. HttpService:JSONEncode(headers))
			print("Body: " .. body)
		end

		local status, response = pcall(function()
			return HttpService:RequestAsync({
				Url = app:_appendUri("/documents/" .. collectionId .. "/" .. documentId),
				Method = "PATCH",
				Headers = headers,
				Body = body
			})
		end)

		if status then
			if response.StatusCode == 200 then
				local responseData = HttpService:JSONDecode(response.Body)
				responseData.fields = FieldsFixer:convertToRoblox(responseData)

				if app._debug then
					print("Document updated successfully!")
					print("Response: " .. HttpService:JSONEncode(responseData))
				end

				return responseData
			else
				if app._debug then
					warn("Error updating document: " .. response.StatusCode .. " " .. response.Body)
				end
			end
		else
			if app._debug then
				warn("Error updating document: " .. response)
			end
		end
	end

	-- Can be VERY destructive. Use with care.
	function collectionClass:deleteDocument(docId: string)
		local headers = {
			["Authorization"] = "Bearer " .. app._token
		}

		if app._debug then
			print("Deleting Document:")
			print("URL: " .. app:_appendUri("/documents/" .. collectionId .. "/" .. docId .. "/"))
			print("Headers: " .. HttpService:JSONEncode(headers))
		end

		local success, error = pcall(function()
			HttpService:RequestAsync({
				Url = app:_appendUri("/documents/" .. collectionId .. "/" .. docId .. "/"),
				Method = "DELETE",
				Headers = headers
			})
		end)

		if success then
			if app._debug then
				print("Document deleted or non-existent (no error).")
			end
		else
			if app._debug then
				warn("Error deleting document: " .. error)
			end
		end
	end

	-- Can be VERY destructive. Use with care.
	function collectionClass:deleteCollection()
		local documents = collectionClass:getDocuments()

		if app._debug then
			print("Deleting all documents in the collection:")
		end

		for _, document in ipairs(documents) do
			local documentPath = document.name
			if app._debug then
				print("Deleting document: " .. documentPath)
			end
			collectionClass:deleteDocument(documentPath)
		end
	end

	return collectionClass
end

return collection
