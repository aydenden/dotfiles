mash = {"⌘", "⌥", "⌃"}

require ("hotkey")
require("window")
require("apps")
require("inputSource")

hs.hotkey.bind(mash, "r", function() hs.reload(); end)

