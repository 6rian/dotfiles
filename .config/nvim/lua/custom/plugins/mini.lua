return {
  'echasnovski/mini.move',
  version = false,

  config = function(_, opts)
    require('mini.move').setup(opts)
  end,
}
