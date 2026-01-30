local M = {}

---Debounce a function to run after `ms` milliseconds have passed.
---@param ms integer
---@param fn function
---@return function
function M.debounce(ms, fn)
  local timer = vim.uv.new_timer()

  return function(...)
    local argv = { ... }

    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

return M
