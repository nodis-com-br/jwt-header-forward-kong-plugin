local BasePlugin = require "kong.plugins.base_plugin"
local JwtHeaderForward = BasePlugin:extend()

return JwtHeaderForward
