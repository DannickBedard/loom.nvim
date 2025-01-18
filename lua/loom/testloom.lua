local api = vim.api
local buf, win

local border = require("githelper.border")
local windowHelper = require("githelper.windowHelper")
local gitUtils = require("githelper.gitUtils")
local currentBorder = border.doubleBorder


local function open_window()
  buf = api.nvim_create_buf(false, true)
  local border_buf = api.nvim_create_buf(false, true)

  api.nvim_set_option_value('bufhidden', 'wipe', {buf = buf})
  api.nvim_set_option_value('filetype', 'whid', {buf = buf})

  local width = api.nvim_win_get_width(0)
  local height = api.nvim_win_get_height(0)

  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    relative = "editor",
    width = win_width ,
    height = math.ceil(win_height),
    row = row,
    col = col,
    border = 'single'
  }

  win = api.nvim_open_win(buf, true, opts)
  api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)

  api.nvim_win_set_option(win, 'cursorline', true)

  api.nvim_buf_set_lines(buf, 0, -1, false, { windowHelper.center('Git helper'), '', ''})
  api.nvim_buf_add_highlight(buf, -1, 'WhidHeader', 0, 0, -1)
end

local function update_view()
  local width = api.nvim_win_get_width(0)

  local height = api.nvim_win_get_height(0)

  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  api.nvim_buf_set_option(buf, 'modifiable', true)

  local result = {}

  -- Unstaged File
  local unstagedFile = gitUtils.getUnstagedFile()
  table.insert(result, border.fn.topBorderText("Unstaged", currentBorder, win_width))
  for k,v in pairs(unstagedFile) do
    table.insert(result, border.fn.middleBorderText(unstagedFile[k], currentBorder, win_width))
  end

  local untrakedFile = gitUtils.getUntrakedFile()
  for k,v in pairs(untrakedFile) do
    table.insert(result, border.fn.middleBorderText("A    ".. untrakedFile[k], currentBorder, win_width))
  end

  table.insert(result, border.fn.bottomBorder(currentBorder, win_width))

  -- Stage file
  local stagedFile = gitUtils.getStagedFile()
  table.insert(result, border.fn.topBorderText("Staged", currentBorder, win_width))
  for k,v in pairs(stagedFile) do
    table.insert(result, border.fn.middleBorderText(stagedFile[k], currentBorder, win_width))
  end

  table.insert(result, border.fn.bottomBorder(currentBorder, win_width))

  -- Status
  local completStatus = gitUtils.getStatus()
  table.insert(result, border.fn.topBorderText("Complet status", currentBorder, win_width))
  for k,v in pairs(completStatus) do
    table.insert(result, border.fn.middleBorderText(completStatus[k], currentBorder, win_width))
  end

  table.insert(result, border.fn.bottomBorder(currentBorder, win_width))

  -- Tips
  api.nvim_buf_set_lines(buf, 1, 2, false, {"s = Stage file, u = unstage file, d = Discrard file, c = Commit, p = push, pl = pull, <cr> = edit file"})

  -- Tables of content
  api.nvim_buf_set_lines(buf, 2, -1, false, result)

  api.nvim_buf_add_highlight(buf, -1, 'whidSubHeader', 1, 0, -1)
  api.nvim_buf_set_option(buf, 'modifiable', false)
end

local function close_window()
  api.nvim_win_close(win, true)
end

local function getFilePathFromGitstatus()
  local gitStatus = api.nvim_get_current_line()
  gitStatus = gitStatus:gsub(currentBorder[border.SIDE], "")
  gitStatus = gitStatus:match("^%s*(.-)%s*$")
  local path = gitStatus:match("%s*%a+%s+(.+)")
  return path
end

local function open_file()
  local currentFile = getFilePathFromGitstatus()
  close_window()
  api.nvim_command('edit '.. currentFile)
end

local function stage_file()
  gitUtils.actions.stageFile(getFilePathFromGitstatus())
  update_view()
end

local function unstage_file()
  gitUtils.actions.unstageFile(getFilePathFromGitstatus())
  update_view()
end

local function discard_file()
  local filePath = getFilePathFromGitstatus()
  gitUtils.actions.discardFile(filePath)
  gitUtils.actions.discardUntrakedFile(filePath)
  update_view()
end

local function git_push()
  gitUtils.actions.push()
  update_view()
end

local function git_pull()
  gitUtils.actions.pull()
  update_view()
end

local function commit()
  gitUtils.actions.commit(update_view)
end

local function set_mappings()
  local mappings = {
    ['<cr>'] = 'open_file()',
    q = 'close_window()',
    s = 'stage_file()',
    u = 'unstage_file()',
    d = 'discard_file()',
    c = 'commit()',
    p = 'git_push()',
    pl = 'git_pull()',
  }

  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"githelper.window".'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end

  -- Disable key while using the plugin
  local other_chars = {
    't','a', 'b', 'e', 'f', 'g', 'i', 'n', 'o', 'r', 'v', 'w', 'x', 'y', 'z'
  }

  for k,v in ipairs(other_chars) do
    api.nvim_buf_set_keymap(buf, 'n', v, '', { nowait = true, noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n', v:upper(), '', { nowait = true, noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n',  '<c-'..v..'>', '', { nowait = true, noremap = true, silent = true })
  end

end

local function window(content, opts)
  open_window()
  set_mappings()
  update_view()
  api.nvim_win_set_cursor(win, {4, 0})
end

return {
  window = window,
  update_view = update_view,
  open_file = open_file,
  stage_file = stage_file,
  unstage_file = unstage_file,
  discard_file = discard_file,
  commit = commit,
  git_push = git_push,
  git_pull = git_pull,
  close_window = close_window
}
