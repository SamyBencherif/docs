#!/usr/bin/env lua

function readISODate()
    local year = tonumber(io.read(4));
    io.read(1);
    local month = tonumber(io.read(2));
    io.read(1);
    local day = tonumber(io.read(2));
    local hour;
    local min;
    local sec;
    if io.read(1) == "T" then
        hour = tonumber(io.read(2));
        io.read(1);
        min = tonumber(io.read(2));
        io.read(1);
        sec = tonumber(io.read(2));
    end
    io.read("*line");

    return {year=year, month=month, day=day, hour=hour, min=min,
    sec=sec}
end

function readHwDescription()
    return io.read("*line")
end

function reasonableTimeDescription(seconds)
    if seconds < 0 then
        return "no time";
    end
    if math.floor(seconds/604800) > 1 then
        return math.floor(seconds/604800).." weeks"
    end
    if math.floor(seconds/86400) > 1 then
        return math.floor(seconds/86400).." days"
    end
    if math.floor(seconds/3600) > 1 then
        return math.floor(seconds/3600).." hours"
    end
    if math.floor(seconds/60) > 1 then
        return math.floor(seconds/60).." minutes"
    end
    return (seconds).." seconds"
end

local now = os.time()
print(os.date("Right now it is %c.", now))
print("")

while io.read(0) ~= nil do
    -- A = Assignment
    -- E = Event
    local entryType = io.read(1)

    -- These variables are titled as if all of these calendar entries
    -- are homework, however it has been adapted to handle other kinds
    -- of entries.
    local hwII = readISODate()
    local hwDue = os.time(hwII)
    local hwTitle = readHwDescription()
    io.read("*line")  --skip blank line

    if (hwDue-now > 0) then
        if entryType == "A" then
            phrase = "You have %s to do %s.\nIt is due on %s\n"
        elseif entryType == "E" then
            phrase = "In %s you are scheduled for %s.\nIt occurs at %s\n"
        end
        print(phrase:format(reasonableTimeDescription(hwDue-now),
        hwTitle,
        os.date("%c.", hwDue)))
    end
end
