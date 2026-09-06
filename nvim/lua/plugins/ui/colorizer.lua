-- norcalli/nvim-colorizer.lua has had no commits since 2021; catgoose maintains
-- the active fork, with a structured options format (legacy flat options are
-- frozen, no new features) — see :h colorizer.config
return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  config = function()
    require('colorizer').setup {
      filetypes = {
        '*',
        css = {
          parsers = { css = true, css_fn = true },
        },
      },
    }
  end,
}
