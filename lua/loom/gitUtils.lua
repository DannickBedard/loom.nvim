local api = vim.api

local getUnstagedFile = function ()
  local unstagedFile = api.nvim_call_function('systemlist', {
      'git diff --name-status'
    })
  return unstagedFile
end

local getUntrakedFile = function ()
  local untrakedFile = api.nvim_call_function('systemlist', {
      'git ls-files --others --exclude-standard'
  })
  return untrakedFile
end

local getStagedFile = function ()
  local stagedFile = api.nvim_call_function('systemlist', {
      'git diff --name-status --cached'
    })
  return stagedFile
end

local getStatus = function ()
  local completStatus = api.nvim_call_function('systemlist', {
      'git status'
    })
  return completStatus
end

local stageFile = function (path)
  local command = "git add " .. path
  vim.fn.system(command)
end

local unstageFile = function (path)
  local command = "git restore --staged " .. path
  vim.fn.system(command)
end

local discardFile = function (path)
  local command = "git restore " .. path
  vim.fn.system(command)
end

local discardUntrakedFile = function (path)
  local discard_untraked_file = "git clean -f " .. path
  vim.fn.system(discard_untraked_file)
end

local push = function()
  local command = "git push"
  vim.fn.system(command)
end

local pull = function()
  local command = "git pull"
  vim.fn.system(command)
end

local diff = function(window, path)

  local commitBuf = api.nvim_create_buf(false, true)

  -- Set the buffer to unmodified to avoid the E5108 error
  api.nvim_buf_set_option(commitBuf, 'modifiable', false)

  -- Open a new window for the terminal buffer
  local opts = {
    style = "minimal",
    relative = "editor",
    width = 80,
    height = 20,
    row = 10,
    col = 10,
    border = "rounded"
  }
  local terminaWin = api.nvim_open_win(commitBuf, true, opts)

  -- Run the git commit command in the terminal buffer
  vim.fn.termopen("git diff " .. path, {
    on_exit = function(_, exit_code, _)
      if exit_code == 0 then
        print("Commit successful")
      else
        print("Commit failed")
      end
      -- Close the window and buffer
      api.nvim_win_close(terminaWin, true)
      api.nvim_buf_delete(commitBuf, { force = true })
      window:update_view()
    end
  })
end


local commit = function(window)

  local commitBuf = api.nvim_create_buf(false, true)

  -- delete file in ".git/COMMIT_EDITMSG"
  vim.fn.system("rm .git/COMMIT_EDITMSG")
  --
  -- Set the buffer to unmodified to avoid the E5108 error

  api.nvim_buf_set_option(commitBuf, 'modifiable', false)

  -- Open a new window for the terminal buffer
  local opts = {
    style = "minimal",
    relative = "editor",
    width = 80,
    height = 20,
    row = 10,
    col = 10,
    border = "rounded"
  }
  local terminaWin = api.nvim_open_win(commitBuf, true, opts)

  -- Run the git commit command in the terminal buffer
  vim.fn.termopen("git commit", {
    on_exit = function(_, exit_code, _)
      if exit_code == 0 then
        print("Commit successful")
      else
        print("Commit failed")
      end
      -- Close the window and buffer
      api.nvim_win_close(terminaWin, true)
      api.nvim_buf_delete(commitBuf, { force = true })
      window:update_view()
    end
  })
end


return {
  getUnstagedFile = getUnstagedFile,
  getUntrakedFile = getUntrakedFile,
  getStagedFile = getStagedFile,
  getStatus = getStatus,
  actions = {
    stageFile = stageFile,
    unstageFile = unstageFile,
    discardFile = discardFile,
    discardUntrakedFile = discardUntrakedFile,
    push = push,
    pull = pull,
    diff = diff,
    commit = commit,
  }
}
