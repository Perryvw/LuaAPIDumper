--[[
API Dumper, dumps the entire API to the console in JSON format.

APIDumper:Dump() dumps all functions, including those of nested tables

APIDumper:DumpCons() dumps all global constants (might need some sorting)

How to fix formatting: First: Find-replace all '[   VScript       ]: ' with ''.
Then find-replace all ',\n"##FIX##"' with '', then find-replace all '"##FIX##"' with '' - all without the single quotes

Author: Perry
]]

--Define the APIDumper class
if APIDumper == nil then
	APIDumper = {}
	APIDumper.__index = APIDumper
end

--Initialise
function APIDumper:Init()
	APIDumper = self

	--Dump funtions!
	APIDumper:Dump()

	--Dump constants
	APIDumper:DumpCons()
end

--DUMP functions
function APIDumper:Dump()
	--dump the object's functions
	doneObjs = {}
	dumpObjectFunc( _G, '_G', 0 )
	print('"##FIX##"')
end

--DUMP all global constants
function APIDumper:DumpCons()
	dumpObjectCons( _G, 'Constants', 0 )
	print('"##FIX##"')
end

--Only outputs tables and functions!
function dumpObjectFunc( obj, name, indent )
	--build our indentation offset
	local indentStr = '';
	for i=1,indent do
		indentStr = indentStr..'    '
	end

	--keep track of what we did to prevent infinite cycles
	doneObjs[obj] = true

	--open the JSON object
	print(indentStr..'"'..name..'"')
	print(indentStr.."{")

	--loop over all fields
	for k,v in pairs(obj) do
		
		--if the field is a table recurse
		if type(v) == 'table' and k ~= 'FDesc' and doneObjs[v] == nil and type(k) ~= 'table' then

			dumpObjectFunc( v, k, indent + 1)

		elseif type(v) == 'function' then
			
			--if the field is a function try to find a description and print
			if obj.FDesc and obj.FDesc[k] then
				print(indentStr..'    "'..k..'" : '..'"'..string.gsub(tostring(obj.FDesc[k]), '\n', '\\n ')..'",')
			else
				print(indentStr..'    "'..k..'" : '..'"No description",')
			end
		end

	end
	print('"##FIX##"')
	--close JSON object
	print(indentStr.."},")
end

--Only outputs tables and constants!
function dumpObjectCons( obj, name, indent )
	--build our indentation offset
	local indentStr = '';
	for i=1,indent do
		indentStr = indentStr..'    '
	end

	--keep track of what we did to prevent infinite cycles
	doneObjs[obj] = true

	--open the JSON object
	print(indentStr..'"'..name..'"')
	print(indentStr.."{")

	--loop over all fields
	for k,v in pairs(obj) do
		
		if type(v) == 'number' then
			--print constants
			print(indentStr..'    "'..k..'",')
		end

	end
	print('"##FIX##"')
	--close JSON object
	print(indentStr.."},")
end

--Initialise
APIDumper:Init()