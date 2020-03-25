#!/usr/bin/env lua
local pse = require "pse"
pse:load()

local m = {
	['add'] = function (_,args)
		local s = table.concat(args,' ')
		pse:add(s)
	end,
	['comment'] = function (_,args)
		if #args > 1 then
			local i = tonumber(args[1])
			local u = pse:getidx(i)
			local s = table.concat({table.unpack(args,2)},' ')
			pse:comment(u, s)
		end
	end,
	['tag'] = function (_,args)
		if #args > 0 then
			local idx = tonumber(args[1])
			local u = pse:getidx(idx)
			local tag = table.concat({table.unpack(args,2)}," ")
			if u then
				pse:tag(u, tag)
			end
			return
		end
	end,
	['listag'] = function (_,args)
		if #args > 0 then
			for _,val in ipairs(args) do
				local l = pse:getag(val)
				pse.struc.index = {}
				for _,u in ipairs(l) do
					pse:list(u,0)
				end
			end
			return
		end
		for k,v in pairs(pse.struc.tag) do
			print(k .. '  \x1b[2m' .. #v .. ' items' .. '\x1b[0m')
		end
	end,
	['list'] = function (_,args)
		if #args > 0 then
			local idx = tonumber(args[1])
			local u = pse:getidx(idx)
			pse.struc.index = {}
			if u then
				pse:list(u,0)
			end
			return
		end
		pse.struc.index = {}
		for _,v in ipairs(pse.struc.root) do
			pse:list(v,0)
		end
	end
}

local f = m[arg[1]]
if f then
	f(m,{table.unpack(arg,2)})
end
pse:save()
