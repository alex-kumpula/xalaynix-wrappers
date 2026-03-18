-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

local wrapped_zsh = os.getenv("WRAPPED_ZSH")

-- This is where you actually apply your config choices.
if wrapped_zsh then
    -- Set the default program to our wrapped Zsh
    config.default_prog = { wrapped_zsh }
end

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 16
config.color_scheme = 'AdventureTime'

-- Finally, return the configuration to wezterm:
return config