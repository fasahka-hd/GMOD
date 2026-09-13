eui.container = eui.container or {}

function eui.container.IsActive(id)
    local tbl = eui.container.containers[id]

    local hours, minutes = string.match(tbl.time, '(.*):(.*)')

    local curTime = os.date("*t")
    curTime.hour = hours
    curTime.min = minutes
    curTime.sec = 0
    
    local time = os.time(curTime)
    
    return os.time() < time
end
