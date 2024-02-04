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
6. 💎 Profit. For more in depth documentation take a look down below.

## API
- `language.loadLanguage(name, data)` Load a table containing the strings into memory.