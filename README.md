# *language.lua*
A pure lua library for management of strings

## Features
- Hot swap in real time of strings
- Simple API
- Lightweight
- Protected mode
- Configurable

## Getting started
1. 📡 Get a copy of language.lua from the [Official Repository](https://github.com/alejandro-alzate/language-lua) or [From Luarocks](https://luarocks.org/modules/alejandro-alzate/language)
2. 💾 Copy `language.lua` where you like to use it, or just on the root directory of the project
3. ⚙ Add it to your project like this:
	```lua
	local language = require("path/to/language")
	```
4. 📃 Pass a path or table containing the data
	- Method 1: The strings are defined internally
	```lua
	local english = {
		welcome = "Welcome back!",
		menu = {
			title = "Main menu:",
			option1 = {
				name = "Start",
				description = "Description of start"
			}
		},
		debugmenu = {
			title = "Hello world"
		}
	}
	local spanish = {
		welcome = "Bienvenido de regreso!",
		menu = {
			title = "Menú principal:",
			option1 = {
				name = "Iniciar",
				description = "Descripcion de iniciar"
			}
		}
	}

	language.loadLanguage("english", english)
	language.loadLanguage("spanish", spanish)
	language.setLanguage("english")
	language.setBackupLanguage("english")
	```
	- Method 2: The string are on an external file
	```lua
	--This will look for english.lua and spanish.lua inside the folder l10n
	--Those files must return a table of strings to work with
	language.loadLanguage("english", "l10n.english")
	language.loadLanguage("spanish", "l10n.spanish")
	```
5. 🖨️ Every time you want tell something to the user, do it by the `getString` function.
	```lua
	print(language.getString("welcome"))
	print(language.getString("menu.title"))
	print(language.getString("menu.option1.name"))
	print(language.getString("menu.option1.description"))

	language.setLanguage("spanish")

	print(language.getString("welcome"))
	print(language.getString("menu.title"))
	print(language.getString("menu.option1.name"))
	print(language.getString("menu.option1.description"))

	--English:
	-->Welcome back!
	-->Main menu:
	-->Start
	-->Description of start

	--Spanish:
	-->Bienvenido de regreso!
	-->Menú principal
	-->Iniciar
	-->Descripcion de iniciar
	```
6. 💎 Profit. For more in depth documentation take a look down [below](#api-documentation).

## API Documentation

#### Safeguards

- `language.setProtectedMode(bool)` ***Enabled*** by default, Make protected calls for catching runtime errors.
	- Parameters:
		- \**Boolean* `bool` Enable *true*, Disable *false*.
	- Returns:
		- nothing

- `language.setIsoleatedMode(bool)` ***Enabled*** by default, when loading a string from an external lua file isolate said lua file for accessing the environment, can be disabled to do wacky stuff for dynamic and or procedural string generation.
	- Parameters:
		- \**Boolean* `bool` Enable *true*, Disable *false*.
	- Returns:
		- nothing

- `language.setSanitizeOutput(bool)` ***Enabled*** by default, when calling getString filter out any type that is not in the `sanitizeFilter` whitelist.
	- Parameters:
		- \**Boolean* `bool` Enable *true*, Disable *false*.
	- Returns:
		- nothing

- `language.setSanitizeOutputFilters(filterList)` Set what types `getString` is allowed to output when `setSanitizeOutput` is enabled, by default they are `string`, `number` and `table`
	- Parameters:
		- *Table* `filterList` A table containing strings that represent a type like `string`, `function`, `number`, `nil`, `table` or `userdata` when given the literall `nil` it will assume default config wich is `{"string", "table", "number"}`.
	- Returns:
		- nothing

#### Library settings

- `language.setLanguage(name)` Sets the current language to use
	- Parameters:
		- \**String* `name` The current language chosen.
	- Returns:
		- nothing

- `language.setPrintErrors(bool)` ***Enabled*** by default, When in protected mode, print error that are being caught.
	- Parameters:
		- \**Boolean* `bool` Enable *true*, Disable *false*.
	- Returns:
		- nothing

#### Resource Manipulation
- `language.loadLanguage(name, data)` Load a table containing the strings into memory.
	- Parameters:
		- \**String* `name` What name will have the key where the data will be saved.
		- \**String, Table* `data`
			- \**String* `data` Path to the file to look for loading the table.
			- \**Table* `data` Table containing the strings already loaded.
	- Returns:
		- nothing

- `language.getString(key)`
	- Parameters:
		- \**String* `key` String identification key, the key can be nested in other keys using the `.` separator eg: `menu.main.title`
	- Returns:
		- \**String* `string` when used correctly this will always return a *String*, it may return a table when the `key` points to said table, but also may point to a function or undefined types if `setSanitizeOutput` is set to `false`.



- `lang.getLocalizationData()`
	- Parameters:
		- nothing
	- Returns:
		- \**Table* `localization` This contains the strings loaded, although not encouraged this can be manipulated directly.

- `lang.getActualLanguageData()`
	- Parameters:
		- nothing
	- Returns:
		- \**Table* `actualLang` Returns what is effectively `localization[systemLanguage]`.

- `lang.getBackupLanguageData()`
	- Parameters:
		- nothing
	- Returns:
		- \**Table* `backupLang` This is a fallback table where a `key` will be searched when `actualLang` has no defined such `key`.
	return backupLang
end

- `lang.getCurrentLanguage()` Get the current language that this library tries to look for when asked of a key on `getString`.
	- Parameters:
		- nothing
	- Returns:
		- \**String* `systemLanguage` What is the language that is set.
