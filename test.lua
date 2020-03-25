local flow = require "flow"
local prompt = require "prompt"

local u1 = flow:add("item 1")
print ("add",prompt.describe(flow))
flow:tag(u1, "tag 1")
print ("tag", prompt.describe(flow))
flow:untag(u1, "tag 1")
print ("untag",prompt.describe(flow))
flow:folder(u1, "folder")
print ("folder",prompt.describe(flow))
flow:unfolder(u1)
print ("unfolder",prompt.describe(flow))
local u2 = flow:rep(u1, "item 2")
print ("rep",prompt.describe(flow))
flow:tag(u2, "tag 2")
print ("tag",prompt.describe(flow))

flow:list(u1, 0)
