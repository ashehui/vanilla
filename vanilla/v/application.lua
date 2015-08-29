-- perf
local error = error
local pairs = pairs
local pcall = pcall
local require = require
local setmetatable = setmetatable
local smatch = string.match
local function tappend(t, v) t[#t+1] = v end
local function buildconf(config)
    local sys_conf = require('vanilla.v.config')
    if config ~= nil then
        for k,v in pairs(config) do sys_conf[k] = v end
    end
    return sys_conf
end

-- init Application and set routes
local Application = {}

function Application:new(ngx, config)
    self.ngx = ngx
    self.config = buildconf(config)
    local instance = {
        run = self.run,
        bootstrap = self.bootstrap,
        dispatcher = require('vanilla.v.dispatcher'):new(self)
    }
    setmetatable(instance, Application)
    return instance
end

function Application:bootstrap()
    local bootstrap = require('application.bootstrap'):new(self.dispatcher)
    bootstrap:bootstrap()
    return self
end

function Application:run()
    self.dispatcher:dispatch()
end

return Application