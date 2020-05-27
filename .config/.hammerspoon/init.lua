mash = {"⌘", "⌥", "⌃"} -- ⇧

require ("hotkey")
require("window")
require("apps")
require("inputSource")
require("translate")

hs.hotkey.bind(mash, "r", function() hs.reload(); end)

