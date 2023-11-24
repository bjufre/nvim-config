return function(task, success_msg)
  local opts = { title = string.upper(task), timeout = 1000 }

  return function(_, code)
    if code ~= 0 then
      vim.notify(string.format("ERROR %s", code), "error", opts)
    else
      if success_msg then
        vim.notify(success_msg, "info", opts)
      else
        vim.notify(string.format("SUCCESS!"), "info", opts)
      end
    end
  end
end

