-- Per-machine settings: loads config/hosts/<hostname>.lua if it exists.
-- Runs right after variables.lua, so host files can override those defaults.

local function read_hostname()
    local f = io.open("/etc/hostname")
    if not f then return "" end
    local h = f:read("l") or ""
    f:close()
    return (h:gsub("%s", ""))
end

HOSTNAME = read_hostname()

local module = "config.hosts." .. HOSTNAME
local ok, err = pcall(require, module)
-- A missing host file is fine (generic defaults); real errors inside one are not.
if not ok and not tostring(err):find("module '" .. module .. "' not found", 1, true) then
    error(err, 0)
end
