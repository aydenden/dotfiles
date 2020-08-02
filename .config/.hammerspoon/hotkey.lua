-- 곧통 단축키 설정 모듈

-- 참 숨김 시스템 단축키 disable
hs.hotkey.bind({"cmd"}, "m", function()
end)

-- lockScreen
hs.hotkey.bind(mash, "L", function()
    hs.caffeinate.lockScreen()
end)

-- 현재 마우스 커서의 우클릭
hs.hotkey.bind(mash, "r", function()
    local pos=nil
    pos=hs.mouse.getAbsolutePosition()
    hs.eventtap.rightClick(pos, 0)
end)
