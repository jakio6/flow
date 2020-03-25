local pse = require "pse"
--local p = require "prompt"
pse:load()
local u = pse:add("wtf")
pse:tag(u, "wtf-tag")
pse:tag(u, "that-tag")
u = pse:comment(u,"the fuck")
pse:comment(u,"the fuck")
pse.struc.index = {}
for _,val in ipairs(pse.struc.root) do
	pse:list(val,0)
end
pse:save()
--print(p.describe(pse))
