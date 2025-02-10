local JsonFile = {}
JsonFile.__index = JsonFile

-- Constructor
function JsonFile:new(filepath)
    local instance = setmetatable({}, JsonFile)
    instance.filepath = filepath
    instance.data = nil
    return instance
end

-- Method to read the JSON file
function JsonFile:read()
    local file = io.open(self.filepath, "r")
    if not file then
        vim.notify("Could not open file: " .. self.filepath, vim.log.levels.ERROR)
        return nil
    end

    local content = file:read("*a")
    file:close()

    local success, data = pcall(vim.json.decode, content)
    if not success then
        vim.notify("Invalid JSON format in file: " .. self.filepath, vim.log.levels.ERROR)
        return nil
    end

    self.data = data
    return self.data
end

-- Method to write data to the JSON file
function JsonFile:write(new_data)
    local file = io.open(self.filepath, "w")
    if not file then
        vim.notify("Could not open file for writing: " .. self.filepath, vim.log.levels.ERROR)
        return false
    end

    local json_content = vim.json.encode(new_data)
    file:write(json_content)
    file:close()

    self.data = new_data
    vim.notify("Data written successfully!", vim.log.levels.INFO)
    return true
end

-- Method to get the data (reads if not loaded)
function JsonFile:get_data()
    if not self.data then
        return self:read()
    end
    return self.data
end

return JsonFile
