

local process = {_version = "0.0.1"}

local _ao = require('ao')

Log = {}
Count = 0

function process.handle(msg, ao)
    local action = ""
    for _, o in ipairs(msg.Tags) do
        if o.name == "Action" then action = o.value end
    end
    if action == "echo" then return {Output = msg.Data} end
    if action == "inc" then
        Count = Count + 1
        return {Output = Count}
    end
    if action == "Date" then return {Output = os.date("%Y-%m-%d")} end
    if action == "Random" then return {Output = math.random(1, 10)} end
    if action == "Memory" then
        while true do table.insert(Log, 'Hello World') end
    end
    if action == "Directory" then
        Files = {}
        local command = string.format('ls %s', '/')
        local p = io.popen(command)
        for file in p:lines() do table.insert(Files, file) end
        p:close()
        return {Output = Files}
    end
    if action == "Assignment" then 
        ao.assign({ Processes = { 'pid-1', 'pid-2' }, Message = 'mid-1' })
        ao.assign({ Processes = { 'pid-1', 'pid-2' }, Message = 'mid-2' })
        return { Output = ao.outbox.Assignments }
    end 
    while true do Count = Count + 1 end
end

return process
