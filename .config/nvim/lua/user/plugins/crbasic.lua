-- CRBasic (Campbell Scientific datalogger) syntax highlighting.
-- The plugin keeps its runtime files under .vim/ and only detects *.cr1, so add both here.
return {
  "bearnik/vim-crbasic",
  lazy = false,
  init = function()
    vim.filetype.add({ extension = { crb = "crbasic", CRB = "crbasic", cr1 = "crbasic", cr1x = "crbasic" } })
  end,
  config = function(plugin)
    vim.opt.rtp:append(plugin.dir .. "/.vim")
  end,
}
