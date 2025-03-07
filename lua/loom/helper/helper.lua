local function merge_table(table1, table2)
  for key,value in pairs(table2) do table1[key] = value end
  return table1
end
local function merge_tables_recursive(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" and type(t1[k]) == "table" then
            merge_tables_recursive(t1[k], v)
        else
            t1[k] = v
        end
    end
    return t1
end

local function merge_arrays(t1, t2)
    local result = {}
    for _, v in ipairs(t1) do table.insert(result, v) end
    for _, v in ipairs(t2) do table.insert(result, v) end
    return result
end

return {
  merge_table = merge_arrays
}
