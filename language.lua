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

local function getData(path)
	local nest = {}
	local lastTable = actualLang
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

local function getString(stringPath)
	return getData(stringPath) or getBackupData(stringPath) or tostring(stringPath) .." is not defined."
end

local function loadLanguage(name, data)
	if type(data) == "string" then
		local result = require(data)
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

function lang.setProtectedMode(bool)
	if bool then
		protectedMode = true
	else
		protectedMode = false
	end
end

function lang.setPrintErros(bool)
	if bool then
		printErrors = true
	else
		printErrors = false
	end
end

function lang.getString(stringPath)
	if protectedMode then
		local success, msg = pcall(getString, stringPath)
		if success then
			return msg
		elseif printErrors then
			print(msg)
		end
	else
		return getString(stringPath)
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

function lang.getCurrentLanguage()
	return systemLanguage
end

return lang