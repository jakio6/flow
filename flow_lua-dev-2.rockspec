package = "flow_lua"
version = "dev-2"
source = {
   url = "git+file:///home/jakio6/git/flow_lua"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      --cli = "cli.lua",
      flow = "flow.lua",
   },
   install = {
	bin = {
		f = "cli.lua"
	}
   }
}
