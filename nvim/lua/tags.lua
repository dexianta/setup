local M = {}

function M.add_tags(tag_key)
  local line_number = vim.fn.line(".")             -- Get the current line number
  local line_content = vim.fn.getline(line_number) -- Get the content of the current line

  -- Step 1: Find the first word on the line
  local field_name = line_content:match("^%s*([%w_]+)")
  if field_name == nil then
    print("No field name found on the current line")
    return
  end

  -- Step 2: Build list to store all the options inside ``, split by space
  local tags_str = line_content:match("`([^`]+)`")
  local tags_list = {}
  if tags_str then
    for tag in tags_str:gmatch("%S+") do
      table.insert(tags_list, tag)
    end
  end

  -- Step 3: Convert the value in the first step to snake_case.
  local snake_case_name = field_name:gsub("(%u)", "_%1"):lower()
  snake_case_name = snake_case_name:gsub("^_", "")

  -- Step 4: Take the input key, find out if there's a match in step 2, if so replace with the new tag, if not, append to the end.
  local new_tag = string.format('%s:"%s"', tag_key, snake_case_name)
  local found = false
  for i, tag in ipairs(tags_list) do
    if tag:match("^%s*:" .. tag_key) then
      tags_list[i] = new_tag
      found = true
      break
    end
  end
  if not found then
    table.insert(tags_list, new_tag)
  end

  -- Step 5: Take the value from step 4, replace the content within ``
  local new_tags_str = table.concat(tags_list, " ")
  local new_line_content = line_content:gsub("`([^`]+)`", "`" .. new_tags_str .. "`")
  vim.fn.setline(line_number, new_line_content)
end

return M
