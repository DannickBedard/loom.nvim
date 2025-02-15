local JsonFile = {}
JsonFile.__index = JsonFile

local function expand_path(path)
  return path:gsub("^~", vim.fn.expand("~"))
end

-- Pretty-print JSON function (works in all Neovim versions)
local function pretty_json_encode(data, indent)
  indent = indent or 2  -- Default indentation size
  local json = vim.json.encode(data)  -- Encode to compact JSON
  local formatted_json = ""
  local level = 0
  local in_string = false

  for i = 1, #json do
    local char = json:sub(i, i)

    if char == '"' and json:sub(i - 1, i - 1) ~= "\\" then
      in_string = not in_string
    end

    if not in_string then
      if char == "{" or char == "[" then
        level = level + 1
        formatted_json = formatted_json .. char .. "\n" .. string.rep(" ", level * indent)
      elseif char == "}" or char == "]" then
        level = level - 1
        formatted_json = formatted_json .. "\n" .. string.rep(" ", level * indent) .. char
      elseif char == "," then
        formatted_json = formatted_json .. char .. "\n" .. string.rep(" ", level * indent)
      else
        formatted_json = formatted_json .. char
      end
    else
      formatted_json = formatted_json .. char
    end
  end

  return formatted_json
end

-- Constructor
function JsonFile:new(filepath)
  if not filepath then
    local str = debug.getinfo(2, "S").source:sub(2)
    local dir = str:match("(.*/)") or "./"
    filepath = dir .. "projects.json"
  end
  filepath = expand_path(filepath)

  local instance = setmetatable({}, JsonFile)
  instance.filepath = filepath
  instance.data = nil
  return instance
end

-- Read JSON file
function JsonFile:read()

  local file = io.open(self.filepath, "r")
  if not file then
    vim.notify("Could not open file: " .. self.filepath, vim.log.levels.WARN)
    return {}
  end

  local content = file:read("*a")
  file:close()

  local success, data = pcall(vim.json.decode, content)
  if not success then
    vim.notify("Invalid JSON format: " .. self.filepath, vim.log.levels.ERROR)
    return {}
  end

  self.data = data
  return self.data
end

-- Write JSON file (pretty-printed)
function JsonFile:write(new_data)
    local file = io.open(self.filepath, "w")
    if not file then
        vim.notify("Could not open file for writing: " .. self.filepath, vim.log.levels.ERROR)
        return false
    end

    local json_content = pretty_json_encode(new_data)
    file:write(json_content .. "\n")  -- Add a newline at the end for readability
    file:close()

    self.data = new_data
    vim.notify("Data written successfully!", vim.log.levels.INFO)
    return true
end

-- Append a new project to the JSON file
function JsonFile:append(new_project)
  local data = self:read()
  if type(data) ~= "table" then
    data = {}  -- Ensure it's a table
  end

  table.insert(data, new_project)
  return self:write(data)
end

return JsonFile
