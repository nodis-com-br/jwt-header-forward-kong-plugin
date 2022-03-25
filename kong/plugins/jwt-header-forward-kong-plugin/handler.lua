local BasePlugin = require "kong.plugins.base_plugin"
local jwt_parser = require "kong.plugins.jwt.jwt_parser"
local req_get_header = kong.request.get_header
local req_set_header = kong.service.request.set_header
local req_clear_header = kong.service.request.clear_header

local JwtHeaderForwardHandler = BasePlugin:extend()

JwtHeaderForwardHandler.VERSION = "0.1.0-0"
JwtHeaderForwardHandler.PRIORITY = 999 --- After all authentication plugins.

--- Parse mappings from an array of ':'-delimited strings to key-value pairs.
-- This is needed because Konga doesn't support 'map' types.
-- @param arr An array of ':'-delimited strings.
-- @return A table where the keys are the part before the ':' and the values
-- are the part after the ':'.
local function parse_mappings(arr)
  local mappings = {}
  for _, s in ipairs(arr) do
    local k, v = s:match("^(..-):(.+)$")
    if k and v then
      mappings[k] = v
    end
  end
  return mappings
end

--- Extract Bearer token from the Authorization request header.
-- @return token, or nil
local function extract_bearer_token()
  local authorization = req_get_header("Authorization")
  if not authorization then
    return
  end

  local token = authorization:match("^Bearer%s+(.+)$")
  return token
end

--- Clear any request headers which are supposed to be mapped from JWT claims.
-- This prevents malicious clients from skipping JWT authentication by setting
-- the request headers themselves.
-- @param mappings Mappings from JWT claims to request headers.
local function clear_destination_headers(mappings)
  for _, header in pairs(mappings) do
    req_clear_header(header)
  end
end

--- Map JWT claims to request headers.
-- @param claims All claims from the JWT.
-- @param mappings Mappings from JWT claims to request headers.
local function map_claims_to_headers(mappings, claims)
  for claim_name, header_name in pairs(mappings) do
    local claim_value = claims[claim_name]
    if claim_value ~= nil and type(claim_value) ~= "table" then
      req_set_header(header_name, tostring(claim_value))
    end
  end
end

function JwtHeaderForwardHandler:new()
  JwtHeaderForwardHandler.super.new(self, "jwt-header-forward")
end

function JwtHeaderForwardHandler:access(conf)
  JwtHeaderForwardHandler.super.access(self, conf)

  local mappings = parse_mappings(conf.mappings)

  clear_destination_headers(mappings)

  local token = extract_bearer_token()
  if not token then
    return
  end

  local jwt, err = jwt_parser:new(token)
  if err then
    return
  end

  if not jwt.claims then
    return
  end

  map_claims_to_headers(mappings, jwt.claims)
end

return JwtHeaderForwardHandler
