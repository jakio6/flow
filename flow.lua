local uuid = require "lua_uuid"
local cjson = require "cjson"

local flow = {
	m = {
		fm = {},
		tm = {},
		im = {},
		index = {}
	}
}

--local unfolder,folder

local function find(t, val)
	if t then
		for i,v in ipairs(t) do
			if v == val then
				return i
			end
		end
	end
	return nil
end

function flow:geti(u)
	if not u then return self.m.im end
	return self.m.im[u]
end

function flow:getf(s)
	if not s then return self.m.fm end
	if not self.m.fm[s] then self.m.fm[s] = {} end
	return self.m.fm[s]
end
function flow:clearf(s)
	assert(#self.m.fm[s] == 0)
	self.m.fm[s] = nil
end

function flow:gett(s)
	if not s then return self.m.tm end
	if not self.m.tm[s] then self.m.tm[s] = {} end
	return self.m.tm[s]
end
function flow:cleart(s)
	assert(#self.m.tm[s] == 0)
	self.m.tm[s] = nil
end

function flow:getindex(i)
	assert(self.m.index, "index should always exists")
	if not i then return self.m.index end
	return self.m.index[i]
end
function flow:clear_index() self.m.index = {} end

function flow:folder(u,s)
	local it = self:geti(u)
	local f = self:getf(s)
	assert(it)
	if it['folder'] then
		self:unfolder(u)
	end
	it['folder'] = s
	table.insert(f, u)
end

function flow:unfolder(r)
	local it = self:geti(r)
	assert(it)
	assert(it['folder'])
	local f = self:getf(it['folder'])
	assert(f)
	-- remove in item
	it['f'] = nil

	if f then
		local fi = find(f, r)
		if fi then
			table.remove(f, fi)
		end
		if #f == 0 then
			self:clearf(it['folder'])
		end
	end
end

function flow:tag(u,s)
	local it = self:geti(u)
	local t = self:gett(s)
	assert(it, "the item to be tagged should exist")
	if not find(it['tags'],s) then
		if not it['tags'] then
			it['tags'] = {}
		end
		table.insert(it['tags'], s)
	end
	table.insert(t,u)
end


function flow:untag(r, s)
	local it = self:geti(r)
	local i = find(it['tags'],s)
	local t = self:gett(s)
	if i then
		table.remove(it['tags'], i)
	end
	if t then
		local ti = find(t, s)
		table.remove(t, ti)
		if #t == 0 then
			self:cleart(s)
		end
	end
end

function flow:rep(r,s)
	local u = uuid()
	local t = os.time()

	-- FIXME
	self.m.im[u] = {
		u = u,
		t = t,
		r = r,
		c = s
	}

	if r then
		local it = self:geti(r)
		assert(it, "parent item should exist")
		if not it.child then
			it.child = {}
		end
		table.insert(it.child, u)
	end
	return u
end

function flow:add(s)
	local u = self:rep(nil,s)
	self:folder(u, "root")
	return u
end

function flow:list(u,depth)
	assert(self:geti(u))

	table.insert(self:getindex(), u)
	io.write(string.format('%s%d. %s \x1b[2m%s\x1b[0m\x1b[1m%s\x1b[0m\n',
	string.rep("  ", depth), #self:getindex(), self:geti(u).c,
	os.date("%H:%M %m-%d",self:geti(u).t),
	table.concat(self:geti(u).tags or {},',')))

	local l = self:geti(u).child
	if l then
		for _,v in ipairs(l) do
			self:list(v,depth+1)
		end
	end

end

function flow:listag()
		for k,v in pairs(self:gett()) do
			print(k .. '  \x1b[2m' .. #v .. ' items' .. '\x1b[0m')
		end
end

function flow:listfolder()
	for k,v in pairs(self:getf()) do
			print(k .. '  \x1b[2m' .. #v .. ' items' .. '\x1b[0m')
	end
end

function flow:save()
	local f = io.open("test.json", "w")
	f:write(cjson.encode(self.m))
end

function flow:load()
	local t = {
		fm = {},
		tm = {},
		im = {},
		index = {}
	}

	local f,err = io.open("test.json", "r")
	if not f then
		print(err)
	else
		t = cjson.decode(f:read('a'))
	end
	self.m = t
end

return flow
