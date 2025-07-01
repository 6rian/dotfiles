return {
  -- Make sure to set this up properly if you have lazy=true
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    file_types = { 'markdown', 'Avante' },
    completions = { blink = { enabled = true } },
  },
  ft = { 'markdown', 'Avante' },
}
