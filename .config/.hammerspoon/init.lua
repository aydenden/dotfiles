mash = {"⌘", "⌥", "⌃"}

require ("hotkey")
require("window")
require("apps")

hs.hotkey.bind(mash, "r", function() hs.reload(); end)

