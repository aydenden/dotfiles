-- 곧통 단축키 설정 모듈

-- 참 숨김 시스템 단축키 disable
hs.hotkey.bind({"cmd"}, "m", function()
end)

-- lockScreen
hs.hotkey.bind(mash, "L", function()
    hs.caffeinate.lockScreen()
end)
