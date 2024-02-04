--INIT
local lang = {}

--RESOURCES
local actualLang = {}
local backupLang = {}
local localization = {}

--CONFIG
local printErrors = true
local protectedMode = true
local systemLanguage = "english"
local automaticUpdate = true
local isolatedMode = true
local sanitizeOutput = true
local sanitizeFilter = {"string", "table", "number"}

local function getData(path, lastTable)
	local nest = {}
	local lastTable = lastTable or actualLang
	local value
	if path then
		for word in path:gmatch("[^.]+") do
			table.insert(nest, word)
		end
		for i = 1, #nest do
			if type(lastTable) == "table" then
				lastTable = lastTable[nest[i]]
			end
		end
		return lastTable
	else
		return "*NO PATH*"
	end
end

local function getBackupData(path)
	local nest = {}
	local lastTable = backupLang
	local value
	if path then
		for word in path:gmatch("[^.]+") do
			table.insert(nest, word)
		end
		for i = 1, #nest do
			if type(lastTable) == "table" then
				lastTable = lastTable[nest[i]]
			end
		end
		return lastTable
	else
		return "*NO PATH*"
	end
end

local function getString(stringKey, languageKey)
	local data = getData(stringKey, localization[languageKey]) or getBackupData(stringKey) or tostring(stringKey) .." is not defined."
	if sanitizeOutput then
		for k,v in pairs(sanitizeFilter) do
			if type(data) == v then
				return data
			end
		end
		local msg = "Blocked %s since the type %s is not on the whitelist"
		return string.format(msg, tostring(stringKey), type(data))
	else
		return data
	end
end

local function loadLanguage(name, data)
	if type(data) == "string" then
		local result
		if isolatedMode then
			result = setfenv(require(data), {})
		else
			result = require(data)
		end
		if type(result) == "table" then
			localization[name] = result
		elseif printErrors then
			local msg = "Cannot load %s The lua file %s didn't return a table returned %s"
			print(string.format(msg, tostring(name), tostring(data), tostring(result)))
		end
	elseif type(data) == "table" then
		localization[name] = data
	elseif printErrors then
		local msg = "Cannot load language %s due to the data is an %s type"
		print(string.format(msg, tostring(name), type(data)))
	end
	if #localization == 1 then
		local firstKey = ""
		for k, v in pairs(localization) do
			firstKey = k
			break
		end
		backupLang = k
		actualLang = k
	end
end

local function setBackupLanguage(name)
	local exists = localization[name]
	if exists then
		backupLang = exists
	elseif printErrors then
		local msg = "Cannot set backup language %s,\nneeds to be loaded first by using language.loadLanguage(name, data)"
		print(string.format(msg, name))
	end
end

function lang.loadLanguage(name, data)
	if protectedMode then
		local success, msg = pcall(loadLanguage, name, data)
		if success then
			return msg
		elseif printErrors then
			print(msg)
		end
	else
		return loadLanguage(name, data)
	end
end

function lang.setSanitizeOutput(bool)
	if bool then
		sanitizeOutput = true
	else
		sanitizeOutput = false
	end
end

function lang.setSanitizeOutputFilters(filters)
	if type(filters) == "table" then
		for k,v in pairs(filters) do
			if type(v) == "string" then
			else
				if printErrors then
					local msg = "Found anomalous types on the filter list only strings are allowed, found: %s"
					print(string.format(msg, type(v)))
				end
				return
			end
		end
		sanitizeFilter = filters
	elseif filters == nil then
		sanitizeFilter = {"string", "table", "number"}
	end
end

function lang.setProtectedMode(bool)
	if bool then
		protectedMode = true
	else
		protectedMode = false
	end
end

function lang.setIsolatedMode(bool)
	if bool then
		isolatedMode = true
	else
		isolatedMode = false
	end
end

function lang.setPrintErros(bool)
	if bool then
		printErrors = true
	else
		printErrors = false
	end
end

function lang.getString(stringKey, languageKey)
	if protectedMode then
		local success, msg = pcall(getString, stringKey, languageKey)
		if success then
			return msg
		elseif printErrors then
			print(msg)
		end
	else
		return getString(stringKey, languageKey)
	end
	return ""
end

function lang.update()
	if type(lang.onUpdate) == "function" then
		if protectedMode then
			local success, msg = pcall(lang.onUpdate)
			if (not success) and printErrors then
				print(msg)
			end
		else
			lang.onUpdate()
		end
	end
end

function lang.setLanguage(languageName)
	local exists = localization[languageName]
	if exists then
		systemLanguage = languageName
	elseif printErrors then
		local msg = "Cannot set language to %s since it doesn't exist."
		print(string.format(msg, tostring(languageName)))
	end
	if automaticUpdate then
		lang.update()
	end
end

function lang.getLanguage()
	return systemLanguage
end

function lang.setBackupLanguage(name)
	if protectedMode then
		local success, msg = pcall(setBackupLanguage, name, data)
		if success then
			return msg
		elseif printErrors then
			print(msg)
		end
	else
		return setBackupLanguage(name, data)
	end
end

function lang.getLocalizationData()
	return localization
end

function lang.getActualLanguageData()
	return actualLang
end

function lang.getBackupLanguageData()
	return backupLang
end

return lang