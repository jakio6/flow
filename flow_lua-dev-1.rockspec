package = "flow_lua"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/jakio6/flow.git"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      cli = "cli.lua",
      flow = "flow.lua"
   },
   --install = {
	   --bin = {
		   --f = "cli.lua"
	   --}
   --}
}
