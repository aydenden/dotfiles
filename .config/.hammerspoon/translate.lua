--- PopupTranslateSelection.spoon 참고
--- 구글 trans late 페이지로 열리도록 함

function current_selection()
    local elem=hs.uielement.focusedElement()
    local sel=nil
    if elem then
        sel=elem:selectedText()
    end
    if (not sel) or (sel == "") then
        hs.eventtap.keyStroke({"cmd"}, "c")
        hs.timer.usleep(20000)
        sel=hs.pasteboard.getContents()
    end
    return (sel or "")
end

hs.hotkey.bind({"⌥", '⇧'}, "e", function ()
    local query =  hs.http.encodeForQuery(current_selection())
    hs.urlevent.openURL('https://translate.google.co.kr/?hl=ko#view=home&op=translate&sl=auto&tl=en&text=' .. query)
end)

hs.hotkey.bind({"⌥", '⇧'}, "k", function ()
    local query =  hs.http.encodeForQuery(current_selection())
    hs.urlevent.openURL('https://translate.google.co.kr/?hl=ko#view=home&op=translate&sl=auto&tl=en&text=' .. query)
end)
