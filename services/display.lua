local displaySvc = {}

displaySvc.run = function(blit, termUpdateChannel)
    local msg = termUpdateChannel:pop()

    --[[
        Term Update Format:
        clear = {
            bgColor: <color>
            fgColor: <color>
        },
        clearLine = {
            bgColor: <color>
            fgColor: <color>
            y: <int>
        }
        text = {
            x = <int>
            y = <int>
            text = <text>
            bgColor = <color>
            fgColor = <color>
        }
    ]]

    if msg then
        print("msg")
        print(msg.type)
        if msg.type == "clear" then
            for i = 1, termSize.y do
                blit[i] = {
                    string.rep(" ", termSize.x),
                    string.rep(msg.fgColor, termSize.x),
                    string.rep(msg.bgColor, termSize.x)
                }
                print(blit[i][3])
            end
            print("update: clear")
        elseif msg.type == "clearLine" then
            blit[msg.y] = {
                string.rep(" ", termSize.x),
                string.rep(msg.fgColor, termSize.x),
                string.rep(msg.bgColor, termSize.x)
            }
        elseif msg.type == "blit" then
            print("blit")
            if msg.x <= termSize.x then
                
                --[[
                    step 1: get the text, bg, and fg colors for the row, and other info for the text
                    step 2: chop off ends that are outside of terminal boundries
                    step 3: remove all characters in positions that the new text would override
                    step 4: insert new row back into the blit table
                ]]

                -- step 1
                local prevData = blit[msg.y]
                local textLen = #msg.text

                local text = prevData[1]
                local fg = prevData[2]
                local bg = prevData[3]
                

                -- step 2
                if textLen + msg.x > termSize.x then
                    -- sub the text down to a point where it can fit in the row
                    text = text:sub(1, termSize.x - msg.x)
                    fg = text:sub(1, termSize.x - msg.x)
                    bg = text:sub(1, termSize.x - msg.x)
                    textLen = #msg.text

                    --[[
                        example to figure this thing out:
                        start at 45 (for exmaple, 6 chars from end)
                            string is "hello world" (11 chars long)
                        subtract 51 (width of terminal) from 45 (x position of text) to reveal cutoff point of text
                        sub text from 1 to cutoff point
                    ]]
                end

                -- step 3 (probably the hardest step)
                --[[
                    how to do this:
                    get parts that the new text will not replace
                        sub from 1 to the x position (get first part of the string)
                        sub from end of string to terminal width (get second part of the string)
                    make a new string that contains the old data, and the new data
                ]]

                -- setup the variables
                local textPre = ""
                local textPost = ""
                
                local bgPre = ""
                local bgPost = ""
                
                local fgPre = ""
                local fgPost = ""

                if msg.x > 1 then
                    -- extract data from text, fg, and bg
                    textPre = text:sub(1, msg.x)
                    bgPre = bg:sub(1, msg.x)
                    fgPre = fg:sub(1, msg.x)
                end
                if #msg.text + msg.x < termSize.x then
                    textPost = text:sub(msg.x + #msg.text, termSize.x)
                    bgPost = bg:sub(msg.x + #msg.text, termSize.x)
                    fgPost = fg:sub(msg.x + #msg.text, termSize.x)
                end

                -- step 4!
                local newLine = {
                    textPre .. msg.text .. textPost,
                    fgPre .. msg.fgColor .. fgPost,
                    bgPre .. msg.bgColor .. bgPost
                }
                blit[msg.y] = newLine
            end
        elseif msg.type == "scroll" then
            for i, v in pairs(blit) do
                if i ~= 1 then
                    blit[i - 1] = v
                end
                blit[termSize.y] = {
                    string.rep(" ", 51),
                    string.rep(msg.fgColor, 51),
                    string.rep(msg.bgColor, 51)
                }
            end
        end
    end
end

displaySvc.setTermSize = function(tbl)
    termSize = tbl  
end

return displaySvc