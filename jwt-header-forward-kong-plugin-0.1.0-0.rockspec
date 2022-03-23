package = "jwt-header-forward-kong-plugin"
version = "0.1.0-0"
source = {
    url = "git+https://github.com/nodis-com-br/jwt-header-forward-kong-plugin",
    dir = "jwt-header-forward-kong-plugin"
}
description = {
    summary = "",
    detailed = [[
        ]],
    homepage = "https://github.com/nodis-com-br/jwt-header-forward-kong-plugin",
    license = "Apache 2.0"
}
dependencies = {
    "luasec",
    "luasocket",
    "ltn12",
    "lua-cjson"
}

build = {
    type = "builtin",
    modules = {
        ["kong.plugins.jwt-header-forward-kong-plugin.handler"] = "kong/plugins/jwt-header-forward-kong-plugin/handler.lua",
        ["kong.plugins.jwt-header-forward-kong-plugin.schema"] = "kong/plugins/jwt-header-forward-kong-plugin/schema.lua",
    }
}
