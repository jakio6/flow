local uuid = require "lua_uuid"
local cjson = require "cjson"
local m = {
	flows = {},
	struc = {
		root = {},
		tag = {},
		index = {}, -- listing建立的索引.
		m = {}
	},
	insert = function(self,u,r,o,t,c) -- 插入log
		self.flows[#self.flows + 1] = {
			u = u,
			r = r,
			o = o,
			t = t,
			c = c
		}
	end,
	add = function (self,s) -- 添加
		local u = self:comment(nil,s)
		table.insert(self.struc.root,u)
		return u
	end,
	comment = function (self, r, s)
		local u = uuid()
		local t = os.time()
		self:insert(u,r,"add",t,s)
		if r then
			if not self.struc.m[r].child then
				self.struc.m[r].child = {}
			end

			table.insert(self.struc.m[r].child,u)
		end
		self.struc.m[u] = {
			parent = r,
			u = u,
			t = t,
			c = s
		}
		return u
	end,
	archive = function (self, r) -- 移除
		local u = uuid()
		local t = os.time()
		self:insert(u, r, "archive",t,nil)
		self.struc.m[r] = nil
		return true
	end,
	list = function (self,u,depth) -- filter, displaying
		if not self.struc.m[u] then
			return
		end
		table.insert(self.struc.index, u)
		io.write(string.format('%s%d. %s \x1b[2m%s\x1b[1m%s\x1b[0m\n',
			string.rep("  ", depth), #self.struc.index, self.struc.m[u].c,
			os.date("%H:%M %m-%d",self.struc.m[u].t),
			table.concat(self.struc.m[u].tags or {},',')))

		if self.struc.m[u].child then
			for _,v in ipairs(self.struc.m[u].child) do
				self.list(self,v,depth+1)
			end
		end
	end,
	getidx = function (self,i)
		return self.struc.index[i]
	end,
	tag = function (self,r,tag) -- tag
		local u = uuid()
		local t = os.time()
		self:insert(u, r, "tag", t, tag)
		if not self.struc.tag[tag] then
			self.struc.tag[tag] = {}
		end
		print ("tagging" , r, tag)
		table.insert(self.struc.tag[tag], r)
		if self.struc.m[r].tags then
			table.insert(self.struc.m[r].tags, tag)
		else
			self.struc.m[r].tags = {tag}
		end
	end,
	getag = function (self,tag)
		return self.struc.tag[tag]
	end,
	save = function(self)
		local f = io.open("test.json","w")
		local t = {flows = self.flows, struc = self.struc}
		f:write(cjson.encode(t))
	end,
	load = function(self)
		local t = {}
		local f,err = io.open("test.json", "r")
		if not f then
			print(err)
		else
			t = cjson.decode(f:read('a'))
		end
		if t['flows'] then
			self.flows = t['flows']
		end
		if t['struc'] then
			self.struc = t['struc']
		end
	end,
}

return m
