
---@class ContextMenuItem
---@field title? string
---@field menu? string
---@field icon? string | {[1]: IconProp, [2]: string};
---@field iconColor? string
---@field image? string
---@field progress? number
---@field onSelect? fun(args: any)
---@field arrow? boolean
---@field description? string
---@field metadata? string | { [string]: any } | string[]
---@field disabled? boolean
---@field readOnly? boolean
---@field event? string
---@field serverEvent? string
---@field args? any

---@class ContextMenuArrayItem : ContextMenuItem
---@field title string

---@class ContextMenuProps
---@field id string
---@field title string
---@field menu? string
---@field onExit? fun()
---@field onBack? fun()
---@field canClose? boolean
---@field options { [string]: ContextMenuItem } | ContextMenuArrayItem[]

---@param context ContextMenuProps | ContextMenuProps[]
kxm.context = function(data)
    lib.registerContext({
        id = data.id or GetInvokingResource(),
        title = data.title,
        menu = data.menu or nil,
        canClose = data.canClose or true,
        onExit = data.onExit or nil,
        onBack = data.onBack or nil,
        options = data.options or nil
    })

    lib.showContext(data.id or GetInvokingResource())
end

local html = {
    -- start tags
    ['<h1>'] = '#',
    ['<h2>'] = '##',
    ['<h3>'] = '###',
    ['<h4>'] = '####',
    ['<h5>'] = '#####',
    ['<h6>'] = '######',
    ['<b>'] = '**',
    ['<bold>'] = '**',
    ['<strong>'] = '**',
    ['<i>'] = '*',
    -- end tags
    ['</h1>'] = '',
    ['</h2>'] = '',
    ['</h3>'] = '',
    ['</h4>'] = '',
    ['</h5>'] = '',
    ['</h6>'] = '',
    ['</b>'] = '**',
    ['</bold>'] = '**',
    ['</strong>'] = '**',
    ['</i>'] = '*',
    ['<br>'] = '  \n',
}

function ConvertText(string)
    if string == '' then return false end
    if not string then return false end

    if string:match("<img(.*)>") then
        local match = string:match("<img(.*)>")
        local beg, final = string.find(string, ">")
        local after_string = string.sub(string, final + 1)
        string = after_string
    else
        for k, v in pairs(html) do
            string = string.gsub(string, k, v)
        end
    end
    return string
end

local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format('qb-menu', exportName), function(setCB)
        setCB(func)
    end)
end

local function convert(menu)
    local new_context = {}
    new_context.id = menu.id or ('convert_'..math.random(1, 10000))
    new_context.title = ConvertText(menu.title) or 'Options'

    local options = {}
    for _,button in pairs(menu) do
        local isServer, event, serverEvent, icon, title, description, action = button.params?.isServer or false, nil, nil, nil, nil, nil, nil
        if isServer then serverEvent = button.params?.event or '' else event = button.params?.event or '' end
        icon = button.icon or nil

        if ConvertText(button.header) then title = ConvertText(button.header) description = ConvertText(button.txt) end
        if not ConvertText(button.header) and ConvertText(button.txt) then title = ConvertText(button.txt) description = nil end
        if not ConvertText(button.header) and not ConvertText(button.txt) then title = ' ' description = nil end
        if button.params?.isAction and type(button.params?.event) ~= 'string' then action = button.params?.event end
        if button.params?.action then action = button.params?.action end

        options[#options+1] = {
            title = title,
            disabled = button.isMenuHeader or false,
            onSelect = action or nil,
            icon = icon,
            arrow = button.subMenu or false,
            description = description,
            event = event,
            serverEvent = serverEvent,
            args = button.params?.args or nil,
        }
    end

    new_context.options = options
    return new_context
end

exportHandler('openMenu', function(data, _)
    local menu = convert(data)
    lib.registerContext(menu)
    lib.showContext(menu.id)
end)

exportHandler('closeMenu', function()
    lib.hideContext()
end)

exportHandler('showHeader', function(data)
    local menu = convert(data)
    lib.registerContext(menu)
    lib.showContext(menu.id)
end)

RegisterNetEvent('qb-menu:client:closeMenu', function()
    lib.hideContext()
end)
