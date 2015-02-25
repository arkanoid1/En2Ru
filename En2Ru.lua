-- En2Ru.lua


local HelperButton = CreateFrame("Button", "HelperButton"..ChatFrame1EditBox:GetName(), UIParent);
local pattern_en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?/~@#$^&|]];
local pattern_ru = [[ёйцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,.Ё"№;:?/]];


local function chsize(char)
    if not char then
        return 0;
    elseif char > 240 then
        return 4;
    elseif char > 225 then
        return 3;
    elseif char > 192 then
        return 2;
    else
        return 1;
    end
end

local function utf8sub(str, startChar, numChars)
    local startIndex = 1;
    local numChars = numChars or 1;
    while startChar > 1 do
        local char = string.byte(str, startIndex);
        startIndex = startIndex + chsize(char);
        startChar = startChar - 1;
    end

    local currentIndex = startIndex;
    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex);
        currentIndex = currentIndex + chsize(char);
        numChars = numChars -1;
    end
    return str:sub(startIndex, currentIndex - 1);
end

local function findPattern(char)
    for index = 1, strlenutf8(pattern_en) do
        if utf8sub(pattern_en, index, 1) == char then
            return index;
        end
    end
end

HelperButton:SetScript("OnClick", function(self, button)
    if button == "translit" then
        local text = ChatFrame1EditBox:GetText();
        if text ~= "" then
            local new_text = "";
            for i = 1, strlenutf8(text) do
                local char = utf8sub(text, i, 1);
                local index = findPattern(char);
                if index then
                    local ru_char = utf8sub(pattern_ru, index, 1);
                    new_text = new_text..ru_char;
                else
                    new_text = new_text..char;
                end
            end
            ChatFrame1EditBox:SetText(new_text);
        end
    end
end);
    
ChatFrame1EditBox:HookScript("OnEditFocusLost", ClearOverrideBindings);
ChatFrame1EditBox:HookScript("OnEditFocusGained", function(self)
    SetOverrideBindingClick(self, false, "ALT-LEFT", "HelperButton"..ChatFrame1EditBox:GetName(), "translit");
end);

print("|cff15bd05Для преобразования ошибочно набранных символов нажмите |r|cff6f0a9aALT+LEFT|r");
