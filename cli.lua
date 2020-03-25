#!/usr/bin/env lua
local flow = require "flow"
flow:load()


local m = {
	['add'] = function (_,args)
		local s = table.concat(args,' ')
		flow:add(s)
	end,

	['c'] = function(self,...) self:comment(...) end,
	['comment'] = function (_,args)
		if #args > 1 then
			local i = tonumber(args[1])
			local u = flow:getindex(i)
			local s = table.concat({table.unpack(args,2)},' ')
			flow:rep(u, s)
		end
	end,

	-- folder
	['mv'] = function(self,...) self:archive(...) end,
	['rm'] = function(self,...) self:archive(...) end,
	['archive'] = function (_,args)
		if #args > 0 then
			local idx = tonumber(args[1])
			local u = flow:getindex(idx)
			if u then
				flow:folder(u, args[2] or "archive")
			end
		end
	end,

	-- tag
	['tag'] = function (_,args)
		if #args > 0 then
			local idx = tonumber(args[1])
			local u = flow:getindex(idx)
			local tag = table.concat({table.unpack(args,2)}," ")
			if u then
				flow:tag(u, tag)
			end
			return
		end
	end,

	['untag'] = function (_,args)
		if #args > 1 then
			local idx = tonumber(args[1])
			local u = flow:getindex(idx)
			local tag = args[2]
			if u then
				flow:untag(u,tag)
			end
		end
	end,

	-- list tag
	['lt'] = function (self,...) self:listag(...) end,
	['listag'] = function (_,args)
		if #args > 0 then
			for _,val in ipairs(args) do
				local l = flow:gett(val)
				flow:clear_index()
				for _,u in ipairs(l) do
					flow:list(u,0)
				end
			end
			return
		end
		flow:listag()
	end,

	-- list
	['l'] = function(self,...) self:list(...) end,
	['list'] = function (self,args)
		if #args > 0 then -- has arg
			local idx = tonumber(args[1])
			local u = flow:getindex(idx)
			flow:clear_index()
			if u then
				flow:list(u,0)
			end
			return
		end

		self:listfolder{"root"}
	end,

	-- list folder
	['lf'] = function (self,...) self:listfolder(...) end,
	['listfolder'] = function (_,args)
		if #args > 0 then
			for _,v in ipairs(args) do
				local l = flow:getf(v)
				flow:clear_index()
				for _,u in ipairs(l) do
					flow:list(u,0)
				end
			end
			return
		end

		flow:listfolder()
	end,

	['todo'] = function (self, _) self:listfolder{"todo"} end,

	['help'] = function ()
		print [[
		add -- add
		l|list [idx] -- list
		c|comment idx ... -- comment to
		lf|listfolder [idx]
		lt|listag [idx]
		tag [idx] ...
		untag [idx] ...
		mv|rm|archive [idx folder] -- move to folder , or archive
		]]
	end
}

local f = m[arg[1]]
if f then
	f(m,{table.unpack(arg,2)})
elseif arg[1] then
	print("unknow option:",arg[1])
	m:help{}
else
	m:list{}
end
flow:save()
