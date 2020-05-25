-- application 관련

-- 백그라운드에 실행중인 프로그램 키보드로 젼환할 수 있는 hint
hs.hotkey.bind({'shift'}, 'F1', hs.hints.windowHints)

-- 단축키와 매핑된 응용프로그램으로 이동
local function toggleApplication(name)
    local app = hs.application.find(name)
    if not app or app:isHidden() then
        hs.application.launchOrFocus(name)
    elseif hs.application.frontmostApplication() ~= app then
        app:activate()
    else
        app:hide()
    end
end

-- 프로그램 별 매핑 단축키
hs.hotkey.bind({'ctrl', 'shift'}, "c", function() toggleApplication("Google Chrome") end)
hs.hotkey.bind({'ctrl', 'shift'}, "i", function() toggleApplication("IntelliJ IDEA") end)
hs.hotkey.bind({'ctrl', 'shift'}, "t", function() toggleApplication("iTerm") end)
hs.hotkey.bind({'ctrl', 'shift'}, "v", function() toggleApplication("Visual Studio Code") end)
