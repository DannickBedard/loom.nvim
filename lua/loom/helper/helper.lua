local function merge_table(table1, table2)
  for key,value in pairs(table2) do table1[key] = value end
end

return {
  merge_table = merge_table
}
