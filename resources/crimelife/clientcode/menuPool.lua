local attivo = true
local funcTable = {}

TextAlignment = {
    Center = 0,
    Left   = 1,
    Right  = 2
}

local exportMenuPool
local exportMenu

local itemList = {}
local submenuList = {}

local OPENING_COOLDOWN = 250


local DEFAULT_HEIGHT = 0.03
local DEFAULT_TEXT_POSITION = vector2(0.002, 0.0035)

local function NewTextItem(menu, title)
    local self = setmetatable(BaseItem(menu), TextItem)

    self.colors = {
        background = self.parent and self.parent.colors.background or Colors.DarkGrey,
        text       = self.parent and self.parent.colors.text or Colors.White,
        rightText  = self.parent and self.parent.colors.text or Colors.White
    }

    self.text = Text(title, self.colors.text, DEFAULT_TEXT_POSITION)
    self.text.font = TEXT.FONT
    self.text.maxWidth = self.parent.width
    self:Add(self.text)

    self.rightText   = nil

    self.leftSprite  = nil
    self.rightSprite = nil



    local function RecalculatePosition()
        self.text.maxWidth = self.parent.width - (self.leftSprite and 0.015 or 0) - (self.rightSprite and 0.015 or 0)
        if (self.leftSprite) then
            self.text:Position(DEFAULT_TEXT_POSITION + vector2(0.015, 0))
        end
        if (self.rightText) then
            self.rightText.maxWidth = self.parent.width - (self.leftSprite and 0.015 or 0) -
                (self.rightSprite and 0.0125 or 0)
            self.rightText:Position(vector2(self.parent.width - 0.004 - 0.0125, DEFAULT_TEXT_POSITION.y))
        end
    end

    function self:LeftSprite(textureDict, textureName)
        self:Remove(self.leftSprite)

        if (textureDict and textureName) then
            self.leftSprite = Sprite(textureDict, textureName, vector2(0.0008, 0.0015),
                vector2(0.015, 0.015 * GetAspectRatio(false)))
            self:Add(self.leftSprite)
        else
            self.leftSprite = nil
        end

        RecalculatePosition()
    end

    function self:RightSprite(textureDict, textureName)
        self:Remove(self.rightSprite)

        if (textureDict and textureName) then
            self.rightSprite = Sprite(textureDict, textureName, vector2(0.135, 0.0015),
                vector2(0.015, 0.015 * GetAspectRatio(false)))
            self:Add(self.rightSprite)
        else
            self.rightSprite = nil
        end

        RecalculatePosition()
    end

    function self:RightText(title)
        self:Remove(self.rightText)

        self.rightText = Text(title, self.colors.rightText, vector2(self.parent.width - 0.004, DEFAULT_TEXT_POSITION.y),
            nil, TextAlignment.Right)
        self.rightText.maxWidth = self.parent.width - (self.leftSprite and 0.015 or 0) -
            (self.rightSprite and 0.0125 or 0)
        if (self.rightSprite) then
            self.rightText:Position(vector2(self.parent.width - 0.004 - 0.0125, DEFAULT_TEXT_POSITION.y))
        end
        self:Add(self.rightText)
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

TextItem = {}
TextItem.__index = TextItem
setmetatable(TextItem, {
    __call = function(cls, ...)
        return NewTextItem(...)
    end
})

TextItem.__tostring = function(obj)
    return string.format("TextItem()")
end

TextItem.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end


local function NewText(_title, _color, _position, _size, _alignment)
    local self             = setmetatable(Object2D(_position, vector2(1.0, 1.0)), Text)

    -- private
    local internalPosition = vector2(0.0, 0.0)
    local internalSize     = 1.0

    local size             = _size or 0.3

    -- public
    self.title             = _title or "MISSING_TEXT"

    self.alignment         = _alignment or TextAlignment.Left
    self.maxWidth          = 0.0

    self.font              = TextFont.Default

    self.color             = _color or Colors.White

    self.shadowDistance    = 0
    self.shadowColor       = Colors.Black

    -- get/set the position of the Text
    function self:Position(newPosition)
        if (not newPosition) then
            return self.position
        end

        self.position = newPosition

        internalPosition = self:AbsolutePosition()

        -- re-calc children position
        for i, child in next, (self.children) do
            child:Position(child:Position())
        end
    end

    -- get/set the scale of the Text
    function self:Scale(newScale)
        if (not newScale) then
            return self.scale
        end

        self.scale = newScale

        internalSize = self:AbsoluteScale() * size

        self:Position(self:Position())

        -- re-calc children scale
        for i, child in next, (self.children) do
            child:Scale(child:Scale())
        end
    end

    -- get/set the scale of the Text
    function self:Size(newSize)
        if (not newSize) then
            return size
        end

        size = newSize

        internalSize = self:AbsoluteScale() * size
    end

    -- get the total width of the Text
    function self:GetWidth()
        BeginTextCommandGetWidth("CELL_EMAIL_BCON")

        AddTextComponentSubstringPlayerName(self.title)

        SetTextScale(0.0, internalSize)

        SetTextJustification(self.alignment)
        if (self.maxWidth > 0.0) then
            if (self.alignment == TextAlignment.Left) then
                SetTextWrap(internalPosition.x, internalPosition.x + self.maxWidth)
            elseif (self.alignment == TextAlignment.Center) then
                SetTextWrap(internalPosition.x - self.maxWidth * 0.5, internalPosition.x + self.maxWidth * 0.5)
            elseif (self.alignment == TextAlignment.Right) then
                SetTextWrap(internalPosition.x - self.maxWidth, internalPosition.x)
            end
        end

        SetTextFont(self.font)

        return EndTextCommandGetWidth(true)
    end

    -- get the total height of the Text
    function self:GetHeight()
        return self:GetLineCount() * GetRenderedCharacterHeight(internalSize, self.font)

        -- also include line spacing
        --local lineCount = self:GetLineCount()
        --return lineCount * GetRenderedCharacterHeight(internalSize, self.font) + (lineCount - 1) * 0.006
    end

    -- get the height of a single line of the Text
    function self:GetSingleLineHeight()
        return GetRenderedCharacterHeight(internalSize, self.font)
    end

    -- get the line count of the Text
    function self:GetLineCount()
        BeginTextCommandLineCount("CELL_EMAIL_BCON")

        AddTextComponentSubstringPlayerName(self.title)

        SetTextScale(0.0, internalSize)

        SetTextJustification(self.alignment)
        if (self.maxWidth > 0.0) then
            if (self.alignment == TextAlignment.Left) then
                SetTextWrap(internalPosition.x, internalPosition.x + self.maxWidth)
            elseif (self.alignment == TextAlignment.Center) then
                SetTextWrap(internalPosition.x - self.maxWidth * 0.5, internalPosition.x + self.maxWidth * 0.5)
            elseif (self.alignment == TextAlignment.Right) then
                SetTextWrap(internalPosition.x - self.maxWidth, internalPosition.x)
            end
        end

        SetTextFont(self.font)

        return EndTextCommandLineCount(true)
    end

    -- draw the Text to the screen
    function self:Draw()
        SetTextScale(0.0, internalSize)
        SetTextColour(self.color.r, self.color.g, self.color.b, self.color.a)

        SetTextJustification(self.alignment)

        if (self.maxWidth > 0.0) then
            if (self.alignment == TextAlignment.Left) then
                SetTextWrap(internalPosition.x, internalPosition.x + self.maxWidth)
            elseif (self.alignment == TextAlignment.Center) then
                SetTextWrap(internalPosition.x - self.maxWidth * 0.5, internalPosition.x + self.maxWidth * 0.5)
            elseif (self.alignment == TextAlignment.Right) then
                SetTextWrap(internalPosition.x - self.maxWidth, internalPosition.x)
            end
        end

        SetTextFont(self.font)

        if (self.shadowDistance > 0) then
            SetTextDropshadow(self.shadowDistance, self.shadowColor.r, self.shadowColor.g, self.shadowColor.b,
                self.shadowColor.a)
        end

        BeginTextCommandDisplayText("CELL_EMAIL_BCON")
        AddTextComponentSubstringPlayerName(self.title)
        EndTextCommandDisplayText(internalPosition.x, internalPosition.y)
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    -- re-calc position and scale once
    self:Position(_position)
    self:Scale(vector2(1.0, 1.0))

    return self
end

Text = {}
Text.__index = Text
setmetatable(Text, {
    __call = function(cls, ...)
        return NewText(...)
    end
})

Text.__tostring = function(text)
    return string.format("Text(\"%s\")", text.title)
end

Text.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end


local function Clamp(value, min, max)
    return math.max(0, math.min(max, value))
end

local function NewColor(_r, _g, _b, _a)
    assert(
        (not _r or type(_r) == "number") and
        (not _g or type(_g) == "number") and
        (not _b or type(_b) == "number") and
        (not _a or type(_a) == "number"),
        "Attempted to create Color with incorrect values. Expected number(s)."
    )
    local self = setmetatable({}, Color)

    if (not _r) then
        self = Colors.MISSING_COLOR
    else
        self.r = _r and math.floor(Clamp(_r, 0, 255)) or 0
        self.g = _g and math.floor(Clamp(_g, 0, 255)) or 0
        self.b = _b and math.floor(Clamp(_b, 0, 255)) or 0
        self.a = _a and math.floor(Clamp(_a, 0, 255)) or 255
    end

    function self:Alpha(alpha)
        return Color(self.r, self.g, self.b, alpha)
    end

    return self
end

Color = {}
Color.__index = Color
setmetatable(Color, {
    __call = function(cls, ...)
        return NewColor(...)
    end
})

Color.__tostring = function(color)
    return string.format("Color(%i, %i, %i, %i)", color.r, color.g, color.b, color.a)
end

TextFont = {
    Default = 0,
    Cursive = 1,
    Monospace = 2,
    Symbols = 3,
    Small = 4,
    Numbers = 5,
    Small2 = 6,
    GTA = 7,

    -- real names
    ChaletLondon = 0,
    HouseScript = 1,
    ChaletComprimeCologne = 4,
    PriceDown = 7
}

Colors = setmetatable({
    White = Color(255, 255, 255),
    Black = Color(0, 0, 0),

    Grey = Color(60, 64, 67),
    LightGrey = Color(75, 76, 79),
    DarkGrey = Color(41, 42, 45),
    Gray = Color(60, 64, 67),
    LightGray = Color(75, 76, 79),
    DarkGray = Color(41, 42, 45),

    -- RGB
    Red = Color(255, 0, 0),
    Green = Color(0, 255, 0),
    Blue = Color(0, 0, 255),
    LightRed = Color(255, 127, 127),
    LightGreen = Color(127, 255, 127),
    LightBlue = Color(127, 127, 255),
    DarkRed = Color(127, 0, 0),
    DarkGreen = Color(0, 127, 0),
    DarkBlue = Color(0, 0, 127),

    -- CMY
    Cyan = Color(0, 255, 255),
    Magenta = Color(255, 0, 255),
    Yellow = Color(255, 255, 0),
    LightCyan = Color(127, 255, 255),
    LightMagenta = Color(255, 127, 255),
    LightYellow = Color(255, 255, 127),
    DarkCyan = Color(0, 127, 127),
    DarkMagenta = Color(127, 0, 127),
    DarkYellow = Color(127, 127, 0),

    -- seethrough / invisible
    Invisible = Color(0, 0, 0, 0),
    SeeThrough = Color(0, 0, 0, 0),

    -- missing color
    MISSING_COLOR = Color(255, 0, 255)
}, {
    __index = function(table, key)
        return table.MISSING_COLOR
    end
})

-- debug levels
LOG = {
    -- shows information
    INFO = false,
    -- shows debug information
    DEBUG = false,
    -- shows warnings
    WARNING = true,
    -- shows errors
    ERROR = true
}

-- default values for the menus
--   item background
BACKGROUND = {
    -- texture dictionary name
    TXD = "customSprites",
    -- texture name
    NAME = "gradient_3",
    -- color
    COLOR = Colors.Black,
    -- highlight color
    H_COLOR = Colors.DarkGrey
}

--   text values
TEXT = {
    -- font type
    FONT = TextFont.Default,
    -- color
    COLOR = Colors.White,
    -- highlight color
    H_COLOR = Colors.White
}

--   border color
BORDER = {
    COLOR = Colors.Invisible
}


local disabledControls = {
    1, 2, 16, 17, 24, 25, 68, 69, 70, 91, 92, 330, 331, 347, 257
}

GetKeyMenuz = function()
    local KEY = 20
    local n = GetResourceKvpInt("fenix_match:menuz")
    if n and tonumber(n) and tonumber(n) > 0 then
        KEY = tonumber(n)
    end
    return KEY
end

local function NewMenuPool()
    local self = setmetatable({}, MenuPool)

    self.menus = {}

    self.keys = {
        keyboard = {
            holdForCursor = GetKeyMenuz(),
            interact = interactKey or 25,
            activateItem = activateItemKey or 24
        }
    }

    self.settings = {
        screenEdgeScroll = true,
        holdKeyWithMenuOpen = true
    }

    local resolution = vector2(0, 0)

    self.OnInteract = nil
    self.OnMouseOver = nil

    self.alternateFunctions = {}
    local oldd = nil

    local function Process()
        if (not attivo) then
            if (self:IsAnyMenuOpen()) then
                self:CloseAllMenus()
            end
            return
        end

        self.keys = {
            keyboard = {
                holdForCursor = GetKeyMenuz(),
                interact = interactKey or 25,
                activateItem = activateItemKey or 24
            }
        }

        if (IsPauseMenuActive()) then
            if (self:IsAnyMenuOpen()) then
                self:CloseAllMenus()
            end
            return
        end

        if (IsControlJustPressed(0, self.keys.keyboard.holdForCursor) or IsDisabledControlJustPressed(0, self.keys.keyboard.holdForCursor)) then
            if (self:IsAnyMenuOpen()) then
                self:CloseAllMenus()
            end

            SetCursorLocation(0.5, 0.5)

            local resX, resY = GetActiveScreenResolution()
            resolution = vector2(resX, resY)
        end

        --not self.settings.holdKeyWithMenuOpen and self:IsAnyMenuOpen()
        if (IsControlPressed(0, self.keys.keyboard.holdForCursor) or IsDisabledControlPressed(0, self.keys.keyboard.holdForCursor)) then
            SetMouseCursorActiveThisFrame()

            local cursorPosition = GetCursorScreenPosition()

            for i, menu in next, (self.menus) do
                if (menu:Visible()) then
                    menu:Process(cursorPosition)
                    menu:Draw()
                end
            end

            for i, control in next, (disabledControls) do
                DisableControlAction(0, control, true)
            end

            local f = GetCursorScreenPosition()

            local a, b, c, d = ScreenToWorld(f, 10000.0)
            if DoesEntityExist(d) and IsEntityAPed(d) then
                if oldd == nil or oldd ~= d then
                    ResetEntityAlpha(oldd)
                    SetEntityAlpha(d, 100, false)
                    oldd = d
                end
            end

            local screenPosition, hitSomething, worldPosition, normalDirection, hitEntityHandle
            if (self.OnMouseOver) then
                screenPosition = GetCursorScreenPosition()
                hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition, 10000.0)
                self.OnMouseOver(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
            end

            if (self.OnInteract and IsDisabledControlJustPressed(0, self.keys.keyboard.interact)) then
                if (screenPosition == nil) then
                    screenPosition = GetCursorScreenPosition()
                    hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition, 10000.0)
                end

                CreateThread(function()
                    self.OnInteract(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
                end);
            end

            for i, alt in next, (self.alternateFunctions) do
                if (IsControlJustPressed(0, alt.key) or IsDisabledControlJustPressed(0, alt.key)) then
                    if (screenPosition == nil) then
                        screenPosition = GetCursorScreenPosition()
                        hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition,
                            10000.0)
                    end

                    CreateThread(function()
                        alt.Func(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
                    end);
                end
            end

            if (IsDisabledControlJustPressed(0, self.keys.keyboard.activateItem)) then
                local activatedMenu = false

                for i = #self.menus, 1, -1 do
                    if (self.menus[i]:Visible() and self.menus[i]:InBounds(cursorPosition)) then
                        local item = self.menus[i]:Activated(cursorPosition)

                        activatedMenu = true
                        break
                    end
                end

                if (not activatedMenu) then
                    self:CloseAllMenus()
                end
            elseif (IsDisabledControlJustReleased(0, self.keys.keyboard.activateItem)) then
                for i = #self.menus, 1, -1 do
                    if (self.menus[i]:Visible() and self.menus[i]:InBounds(cursorPosition)) then
                        local item = self.menus[i]:Released(cursorPosition)
                        break
                    end
                end
            end

            if (IsDisabledControlJustPressed(0, 16)) then
                for i = #self.menus, 1, -1 do
                    if (self.menus[i]:Visible() and self.menus[i].Scroll and self.menus[i]:InBounds(cursorPosition)) then
                        self.menus[i]:Scroll("down")
                        break
                    end
                end
            elseif (IsDisabledControlJustPressed(0, 17)) then
                for i = #self.menus, 1, -1 do
                    if (self.menus[i]:Visible() and self.menus[i].Scroll and self.menus[i]:InBounds(cursorPosition)) then
                        self.menus[i]:Scroll("up")
                        break
                    end
                end
            end

            if (self.settings.screenEdgeScroll) then
                if (screenPosition == nil) then
                    screenPosition = GetCursorScreenPosition()
                end

                SetMouseCursorSprite(1)

                local frameTime = GetFrameTime()

                if (screenPosition.x > (resolution.x - 10.0) / resolution.x) then
                    SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - 60.0 * frameTime)
                    SetMouseCursorSprite(7)
                elseif (screenPosition.x < 10.0 / resolution.x) then
                    SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + 60.0 * frameTime)
                    SetMouseCursorSprite(6)
                end
            end
        elseif (IsControlJustReleased(0, self.keys.keyboard.holdForCursor) or IsDisabledControlJustReleased(0, self.keys.keyboard.holdForCursor)) then
            if oldd ~= nil then
                ResetEntityAlpha(oldd)
            end
            self:Reset()
        end
    end

    function self:Reset()
        local currMemory = collectgarbage("count")

        for k, menu in next, (self.menus) do
            if (self.menus[k].Destroy) then
                self.menus[k]:Destroy()
            end
            self.menus[k] = nil
        end
        self.menus = {}

        collectgarbage()
    end

    CreateThread(function()
        while (true) do
            Wait(0)
            Process()
        end
    end);

    return self
end

MenuPool = {}
MenuPool.__index = MenuPool
setmetatable(MenuPool, {
    __call = function(cls, ...)
        return NewMenuPool(...)
    end
})

function MenuPool:IsAnyMenuOpen()
    for i, menu in next, (self.menus) do
        if (menu:Visible()) then
            return true
        end
    end

    return false
end

function MenuPool:CloseAllMenus()
    for i, menu in next, (self.menus) do
        menu:Visible(false)
    end
end

function MenuPool:AddMenu()
    table.insert(self.menus, Menu(self))

    return self.menus[#self.menus]
end

function MenuPool:AddScrollMenu(maxItems)
    table.insert(self.menus, ScrollMenu(self, maxItems))

    return self.menus[#self.menus]
end

function MenuPool:AddPageMenu(maxItems)
    table.insert(self.menus, PageMenu(self, maxItems))

    return self.menus[#self.menus]
end

function MenuPool:AddAlternateFunction(_key, _Func)
    table.insert(self.alternateFunctions, {
        key = _key,
        Func = _Func
    })
end

--
function GetCursorScreenPosition()
    if (not IsControlEnabled(0, 239)) then
        EnableControlAction(0, 239, true)
    end
    if (not IsControlEnabled(0, 240)) then
        EnableControlAction(0, 240, true)
    end

    return vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))
end

function ScreenToWorld(screenPosition, maxDistance)
    local pos = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(0)
    local fov = GetGameplayCamFov()
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, fov, 0, 2)
    local camRight, camForward, camUp, camPos = GetCamMatrix(cam)
    DestroyCam(cam, true)

    screenPosition = vector2(screenPosition.x - 0.5, screenPosition.y - 0.5) * 2.0

    local fovRadians = DegreesToRadians(fov)
    local to = camPos + camForward + (camRight * screenPosition.x * fovRadians * GetAspectRatio(false) * 0.534375) -
        (camUp * screenPosition.y * fovRadians * 0.534375)

    local direction = (to - camPos) * maxDistance
    local endPoint = camPos + direction

    local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, endPoint.x, endPoint.y, endPoint.z, -1, nil, 0)
    local _, hit, worldPosition, normalDirection, entity = GetShapeTestResult(rayHandle)

    if (hit == 1) then
        return true, worldPosition, normalDirection, entity
    else
        return false, vector3(0, 0, 0), vector3(0, 0, 0), nil
    end
end

function DegreesToRadians(degrees)
    return (degrees * 3.14) / 180.0
end

local function OnActivate(itemId, func)
    assert(itemId ~= nil and itemId >= 0 and itemId <= #itemList, "Parameter \"itemId\" must be a valid item id!")
    assert(func ~= nil, "Parameter \"func\" must be a valid function!")

    itemList[itemId].OnActivate = func
end

function InitExportMenu()
    exportMenuPool = MenuPool()

    exportMenuPool.OnInteract = function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
        if (onCooldown) then
            return
        end
        onCooldown = true

        CreateThread(function()
            local timer = GetGameTimer()
            while (GetGameTimer() < timer + OPENING_COOLDOWN) do
                Wait(0)
            end

            onCooldown = false
        end);

        -- reset menu
        exportMenuPool:Reset()

        -- empty out item and submenu list
        for k, v in next, (itemList) do
            itemList[k] = nil
        end
        itemList = {}
        for k, v in next, (submenuList) do
            submenuList[k] = nil
        end
        submenuList = {}

        -- add first layer menu
        exportMenu = exportMenuPool:AddMenu()

        -- execute registered functions and remove/ignore the ones causing errors
        local toDelete = {}
        for i, func in next, (funcTable) do
            local result, error = pcall(func, screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
        end
        for i = #toDelete, 1, -1 do
            table.remove(funcTable, toDelete[i])
        end

        -- display menu
        if exportMenu.Position and exportMenu.Visible then
            exportMenu:Position(screenPosition)
            exportMenu:Visible(true)
        end
    end
end

local function GetMenu(menuId)
    if (menuId == nil or menuId == 0) then
        return exportMenu
    end

    if (menuId > #submenuList) then
        return
    end

    return submenuList[menuId]
end

local function AddItemToList(item)
    --if (#itemList % 10 == 0) then
    --	Wait(0)
    --end
    table.insert(itemList, item)
    return #itemList
end
local function AddItem(menuId, title, func)
    if GetMenu(menuId).AddItem then
        local item = GetMenu(menuId):AddItem(title)
        if (func) then
            item.OnActivate = func
        end

        return AddItemToList(item)
    end
end

local function Register(func)
    table.insert(funcTable, func)

    if (exportMenuPool == nil) then
        InitExportMenu()
    end

    return #funcTable
end

local function AddSubmenuToList(submenu)
    table.insert(submenuList, submenu)
    return #submenuList
end

local function AddPageSubmenu(parentMenuId, title, maxItems)
    if GetMenu(parentMenuId).AddPageSubmenu then
        local pageSubmenu, item = GetMenu(parentMenuId):AddPageSubmenu(title, maxItems)
        return AddSubmenuToList(pageSubmenu), AddItemToList(item)
    end
end

Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
    if (not DoesEntityExist(hitEntity)) or GetPlayerServerId(NetworkGetPlayerIndexFromPed(hitEntity)) == 0 then
        return
    end

    local id = GetPlayerServerId(NetworkGetPlayerIndexFromPed(hitEntity))
    local myid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
    SetEntityAlpha(hitEntity, 100, false)

    local InfoMenu, InfoMenuItem = AddPageSubmenu(0, "Info", 5)
    if InfoMenu == nil then
        return
    end

    ESX.TriggerServerCallback('Menu:GetPlayerData', function(data)
        if type(data) == "table" then
            stats = {
                kills = data.kills,
                deaths = data.deaths,
                kd = (data.deaths > 0) and string.format('%02.2f', (data.kills / data.deaths)) or
                    (data.kills > 0 and (data.kills .. '.0') or '0.0'),
                iddiscord = data.dcid,
                name = data.name,
                trophies = data.trophies,
                rank = data.rank,
                xp = data.xp,
                level = data.level
            }
        end

        AddItem(InfoMenu, "~w~[ID]: ~r~" .. id)
        AddItem(InfoMenu, "~w~[Name]: ~r~" .. GetPlayerName(NetworkGetPlayerIndexFromPed(hitEntity)))
        AddItem(InfoMenu, "~w~[DS Name]: ~r~" .. stats.name)
        AddItem(InfoMenu, "~w~[DS ID]: ~r~" .. stats.iddiscord)

        local statsmenu, statsItem = AddPageSubmenu(0, "Stats", 5)
        if statsmenu == nil then
            return
        end

        AddItem(statsmenu, "Kills: ~r~" .. stats.kills .. "~w~ Tode: ~r~" .. stats.deaths .. "~w~ K/D: ~r~" .. stats.kd)
        AddItem(statsmenu, stats.rank .. " - ~r~" .. stats.trophies .. " ~w~Trophäen")
        AddItem(statsmenu, "XP: ~r~" .. stats.xp .. "~w~ - Level: ~r~" .. stats.level .. "~w~")

        local copiaOutfit = AddItem(0, "Outfit Kopieren")
        OnActivate(copiaOutfit, function()
            TriggerServerEvent("ali:copyOutfit:request", id)
        end);

        if not isinMatch then
            local requestMatch = AddItem(0, "1vs1 Anfrage")
            OnActivate(requestMatch, function()
                TriggerEvent("1vs1:requestWithID", id)
            end);
        end
    end, id)
end);

RegisterCommand("copy", function(source, args, rawCommand)
    local id = tonumber(args[1])
    TriggerServerEvent("ali:copyOutfit:request", id)
end, false)

local function NewMenu(pool)
    local self = setmetatable(Container(), Menu)

    -- private
    local visible = false

    local lowerRight = vector2(0, 0)

    -- public
    self.pool = pool

    self.parent = nil

    self.order = 0

    self.width = 0.15

    self.colors = {
        border = BORDER.COLOR,
        background = BACKGROUND.COLOR,
        hBackground = BACKGROUND.H_COLOR,
        text = TEXT.COLOR,
        hText = TEXT.H_COLOR
    }

    local border = Border()
    border:Color(self.colors.border)
    border:Parent(self)

    local function RecalculatePosition(_position)
        self.position = _position

        local totalHeight = 0.0
        local nonScaledHeight = 0.0
        for i, item in next, (self.objectList) do
            totalHeight = totalHeight + item:Height() * self.scale.y
            nonScaledHeight = nonScaledHeight + item:Height()
        end

        lowerRight = self:AbsolutePosition() + vector2(self.width * self.scale.x, totalHeight)
        if (lowerRight.x > 1.0) then
            if (self.parent ~= nil) then
                self.position = vector2(self.position.x - self.width - self.parent.width, self.position.y)
                lowerRight = vector2(lowerRight.x - self.width - self.parent.width, lowerRight.y)
            else
                self.position = self.position - vector2(lowerRight.x - 1.0, 0.0)
                lowerRight = vector2(1.0, lowerRight.y)
            end
        end
        if (lowerRight.y > 1.0) then
            self.position = self.position - vector2(0.0, lowerRight.y - 1.0)
            lowerRight = vector2(lowerRight.x, 1.0)
        end

        border:Size(lowerRight - self.position)
        border:Size(vector2(self.width, nonScaledHeight))

        local currPos = vector2(0, 0)
        for i, item in next, (self.objectList) do
            item:Position(currPos)
            currPos = currPos + vector2(0.0, item:Height())
        end
    end



    function self:AddAnyItem(item)
        self:Add(item)

        RecalculatePosition(self.position)

        return self.objectList[#self.objectList]
    end

    function self:AddBaseItem()
        return self:AddAnyItem(BaseItem(self))
    end

    -- adds a new Separator to the menu
    function self:AddSeparator()
        return self:AddAnyItem(SeparatorItem(self))
    end

    -- adds a new TextItem to the menu
    function self:AddTextItem(title)
        return self:AddAnyItem(TextItem(self, title))
    end

    -- adds a new Item to the menu
    function self:AddItem(title)
        return self:AddAnyItem(Item(self, title))
    end

    -- adds a new Item to the menu
    function self:AddSpriteItem(textureDict, textureName)
        return self:AddAnyItem(SpriteItem(self, textureDict, textureName))
    end

    -- adds a new Item to the menu
    function self:AddCheckboxItem(title, checked)
        return self:AddAnyItem(CheckboxItem(self, title, checked))
    end

    -- adds a new submenu to this menu
    function self:AddSubmenu(title)
        local submenu = self.pool:AddMenu()
        submenu.order = self.order + 1
        submenu:Parent(self)

        return submenu, self:AddAnyItem(SubmenuItem(self, title, submenu))
    end

    -- adds a new scroll submenu to this menu
    function self:AddScrollSubmenu(title, maxItems)
        local scrollSubmenu = self.pool:AddScrollMenu(maxItems)
        scrollSubmenu.order = self.order + 1
        scrollSubmenu:Parent(self)

        return scrollSubmenu, self:AddAnyItem(SubmenuItem(self, title, scrollSubmenu))
    end

    -- adds a new scroll submenu to this menu
    function self:AddPageSubmenu(title, maxItems)
        local pageSubmenu = self.pool:AddPageMenu(maxItems)
        pageSubmenu.order = self.order + 1
        pageSubmenu:Parent(self)

        return pageSubmenu, self:AddAnyItem(SubmenuItem(self, title, pageSubmenu))
    end

    -- processes and draws the menu
    function self:Process(cursorPosition)
        if (not visible) then
            return
        end

        for i, item in next, (self.objectList) do
            if (item.Process) then
                item:Process(cursorPosition)
            end
        end
    end

    function self:Draw()
        if (not visible) then
            return
        end

        if (self:IsOverlapped()) then
            local sprite = Sprite(BACKGROUND.TXD, BACKGROUND.NAME, self:AbsolutePosition(),
                (self:AbsolutePosition() - lowerRight) * -1.0, nil, self.colors.background)
            sprite:Draw()

            return
        end

        for i, obj in next, (self.objectList) do
            obj:Draw()
        end

        border:Draw()
    end

    -- when anything was activated
    function self:Activated(cursorPosition)
        for i, item in next, (self.objectList) do
            if (item:InBounds(cursorPosition) and item.Activated) then
                item:Activated()

                return
            end
        end
    end

    -- when the activate button was released
    function self:Released(cursorPosition)
        for i, item in next, (self.objectList) do
            if (item:InBounds(cursorPosition) and item.Released) then
                item:Released()
                return
            end
        end
    end

    -- get/set the visibility of the Menu
    function self:Visible(visibility)
        if (visibility == nil) then
            return visible
        end

        --if (visibility == false) then
        --    CreateThread(function()
        --        self.OnClosed()
        --    end);
        --end
        visible = visibility
    end

    -- get/set the position of the Menu
    function self:Position(_position)
        if (_position == nil) then
            return self.position
        end

        RecalculatePosition(_position)
    end

    -- get/set the scale of the Menu
    function self:Scale(newScale)
        if (not newScale) then
            return self.scale
        end

        self.scale = newScale

        for i, item in next, (self.objectList) do
            item:Scale(item:Scale())
        end

        RecalculatePosition(self.position)
    end

    -- checks if the given position is inside the bounds of the Menu
    function self:InBounds(point)
        local pos = self:AbsolutePosition()
        return point.x >= pos.x
            and point.y >= pos.y
            and point.x < lowerRight.x
            and point.y < lowerRight.y
    end

    function self:IsOverlapped(position)
        for i, item in next, (self.objectList) do
            if (item.submenu and item.submenu:Visible()) then
                for j, subItem in next, (item.submenu.objectList) do
                    if (subItem.submenu and subItem.submenu:Visible() and subItem.submenu.objectList) then
                        for k, sub2Item in next, (subItem.submenu.objectList) do
                            if (self:InBounds(sub2Item:AbsolutePosition() + vector2(sub2Item.parent.width, sub2Item.height) * 0.5)) then
                                return true
                            end
                        end
                    end
                end
            end
        end

        return false
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

Menu = {}
Menu.__index = Menu
setmetatable(Menu, {
    __call = function(cls, ...)
        return NewMenu(...)
    end
})

Menu.__tostring = function(obj)
    return string.format("Menu()")
end

Menu.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end

local function NewContainer(_position)
    local self = setmetatable(Object2D(_position, nil), Container)

    -- list containing all Graphics2D elements to draw
    self.objectList = {}



    -- get/set the position of the Rect
    function self:Position(newPosition)
        if (not newPosition) then
            return self.position
        end

        self.position = newPosition

        -- re-calc children position
        for i, obj in next, (self.objectList) do
            obj:Position(obj:Position())
        end
    end

    -- get/set the scale of the Rect
    function self:Scale(newScale)
        if (not newScale) then
            return self.scale
        end

        self.scale = newScale

        -- re-calc children scale
        for i, obj in next, (self.objectList) do
            obj:Scale(obj:Scale())
        end
    end

    function self:Draw()
        for i, obj in next, (self.objectList) do
            obj:Draw()
        end
    end

    -- add new Graphics2D objects to the Container
    function self:Add(obj)
        obj:Parent(self)

        table.insert(self.objectList, obj)

        return self.objectList[#self.objectList]
    end

    -- remove a Graphics2D object from the Container
    function self:Remove(object)
        for i, obj in next, (self.objectList) do
            if (obj == object) then
                table.remove(self.objectList, i)
                return
            end
        end
    end

    -- remove all objects from the Container
    function self:Clear()
        self.objectList = {}
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

Container = {}
Container.__index = Container
setmetatable(Container, {
    __call = function(cls, ...)
        return NewContainer(...)
    end
})

Container.__tostring = function(container)
    return "Container()"
end

Container.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end

local function NewObject2D(_position, _scale)
    local self = setmetatable({}, Object2D)

    self.parent = nil
    self.children = {}

    self.position = _position or vector2(0.0, 0.0)
    self.scale = _scale or vector2(1.0, 1.0)



    -- get/set the parent of the Object2D
    function self:Parent(newParent)
        if (not newParent) then
            return self.parent
        end

        if (self.parent) then
            for i, child in next, (self.parent.children) do
                if (child == self) then
                    table.remove(self.parent.children, i)
                    break
                end
            end
        end

        self.parent = newParent

        table.insert(self.parent.children, self)

        self:Position(self:Position())
        self:Scale(self:Scale())
    end

    -- get/set the position of the Object2D
    function self:Position(newPosition)
        if (not newPosition) then
            return self.position
        end

        self.position = newPosition
    end

    -- get/set the scale of the Object2D
    function self:Scale(newScale)
        if (not newScale) then
            return self.scale
        end

        self.scale = newScale
    end

    -- get the absolute screen position of the Object2D
    function self:AbsolutePosition()
        if (self.parent) then
            return self.parent:AbsolutePosition() + self.position * self.parent:AbsoluteScale()
        else
            return self.position
        end
    end

    -- get the absolute screen scale of the Object2D
    function self:AbsoluteScale()
        if (self.parent) then
            return self.parent:AbsoluteScale() * self.scale
        else
            return self.scale
        end
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

Object2D = {}
Object2D.__index = Object2D
setmetatable(Object2D, {
    __call = function(cls, ...)
        return NewObject2D(...)
    end
})

Object2D.__tostring = function(object2D)
    return string.format("Object2D(%s, %s)", object2D.position, object2D.scale)
end

Object2D.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end


local DEFAULT_THICKNESS = 0.001

local function NewBorder(_size, _thickness, _color)
    local self = setmetatable(Container(), Border)

    local size = _size or vector2(1.0, 1.0)

    local thickness = _thickness or DEFAULT_THICKNESS

    local color = _color or Colors.MISSING_COLOR

    local edges = { Rect(), Rect(), Rect(), Rect() }
    for i, edge in next, (edges) do
        self:Add(edge)
    end



    local function RecalculateBorder()
        -- pre-calc
        local aspectRatio = GetAspectRatio(false)
        local thick = vector2(thickness, thickness * aspectRatio) -- * self.scale
        local halfThick = thick * 0.5

        local topLeft = -halfThick
        local horizontalSize = vector2(size.x + thick.x, thick.y)
        local verticalSize = vector2(thick.x, size.y + thick.y)

        -- resize rects
        edges[1]:Position(topLeft)
        edges[1]:Size(horizontalSize)
        edges[2]:Position(topLeft)
        edges[2]:Size(verticalSize)
        edges[3]:Position(vector2(topLeft.x, size.y - halfThick.y))
        edges[3]:Size(horizontalSize)
        edges[4]:Position(vector2(size.x - halfThick.x, topLeft.y))
        edges[4]:Size(verticalSize)

        --self:Clear()
        --
        ---- add rects
        --self:Add(Rect(topLeft, horizontalSize, color))
        --self:Add(Rect(topLeft, verticalSize, color))
        --self:Add(Rect(vector2(topLeft.x, size.y - halfThick.y), horizontalSize, color))
        --self:Add(Rect(vector2(size.x - halfThick.x, topLeft.y), verticalSize, color))
    end

    -- get/set the size of the Border
    function self:Size(newSize)
        if (not newSize) then
            return size
        end

        size = newSize

        RecalculateBorder()
    end

    -- get/set the color of the Border
    function self:Color(_color)
        if (_color == nil) then
            return color
        end

        color = _color

        for i, obj in next, (self.objectList) do
            obj.color = color
        end
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (edges) do
            if (edges[k].Destroy) then
                edges[k]:Destroy()
            end

            edges[k] = nil
        end

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    RecalculateBorder()

    return self
end

Border = {}
Border.__index = Border
setmetatable(Border, {
    __call = function(cls, ...)
        return NewBorder(...)
    end
})

Border.__tostring = function(border)
    return string.format("Border()")
end

Border.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end


local function NewRect(_position, _size, _color)
    local self = setmetatable(Object2D(_position, vector2(1.0, 1.0)), Rect)

    -- private
    local internalPosition = vector2(0.0, 0.0)
    local internalScale = vector2(1.0, 1.0)

    local size = _size or vector2(1.0, 1.0)

    -- public
    self.color = _color or Colors.White



    -- get/set the position of the Rect
    function self:Position(newPosition)
        if (not newPosition) then
            return self.position
        end

        self.position = newPosition

        internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

        -- re-calc children position
        for i, child in next, (self.children) do
            child:Position(child:Position())
        end
    end

    -- get/set the scale of the Rect
    function self:Scale(newScale)
        if (not newScale) then
            return self.scale
        end

        self.scale = newScale

        internalScale = self:AbsoluteScale() * size
        internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

        -- re-calc children scale
        for i, child in next, (self.children) do
            child:Scale(child:Scale())
        end
    end

    -- get/set the scale of the Rect
    function self:Size(newSize)
        if (not newSize) then
            return size
        end

        size = newSize

        internalScale = self:AbsoluteScale() * size
        internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)
    end

    -- get/set the color of the Rect
    function self:Color(newColor)
        if (not newColor) then
            return self.color
        end

        self.color = newColor
    end

    -- draws the Rect to the screen
    function self:Draw()
        DrawRect(internalPosition.x, internalPosition.y, internalScale.x, internalScale.y, self.color.r, self.color.g,
            self.color.b, self.color.a)
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].ClearReferences) then
                self.children[k]:ClearReferences()
            end

            self.children[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    -- re-calc position and scale once
    self:Position(_position)
    self:Scale(vector2(1.0, 1.0))

    return self
end

Rect = {}
Rect.__index = Rect
setmetatable(Rect, {
    __call = function(cls, ...)
        return NewRect(...)
    end
})

Rect.__tostring = function(rect)
    return string.format("Rect(%s, %s, %s)", rect:Position(), rect:Size(), rect.color)
end

Rect.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end

local DEFAULT_MAX_ITEMS = 10

local function NewPageMenu(pool, _maxItems)
    local self = setmetatable(Menu(pool), PageMenu)

    -- private
    local visible = false

    local lowerRight = vector2(0, 0)

    local itemList = {}

    local maxItems = _maxItems or DEFAULT_MAX_ITEMS

    local currentIndex = 1

    local pageItem = PageItem(self)

    local border = Border()
    border:Color(self.colors.border)
    border:Parent(self)

    local function RecalculatePosition(_position)
        self.position = _position

        local totalHeight = 0.0
        local nonScaledHeight = 0.0
        for i, item in next, (self.objectList) do
            totalHeight = totalHeight + item:Height() * self.scale.y
            nonScaledHeight = nonScaledHeight + item:Height()
        end

        lowerRight = self:AbsolutePosition() + vector2(self.width * self.scale.x, totalHeight)
        if (lowerRight.x > 1.0) then
            if (self.parent ~= nil) then
                self.position = vector2(self.position.x - self.width - self.parent.width, self.position.y)
                lowerRight = vector2(lowerRight.x - self.width - self.parent.width, lowerRight.y)
            else
                self.position = self.position - vector2(lowerRight.x - 1.0, 0.0)
                lowerRight = vector2(1.0, lowerRight.y)
            end
        end
        if (lowerRight.y > 1.0) then
            self.position = self.position - vector2(0.0, lowerRight.y - 1.0)
            lowerRight = vector2(lowerRight.x, 1.0)
        end

        border:Size(lowerRight - self.position)
        border:Size(vector2(self.width, nonScaledHeight))

        local currPos = vector2(0, 0)
        for i, item in next, (self.objectList) do
            item:Position(currPos)
            currPos = currPos + vector2(0.0, item:Height())
        end
    end



    function self:SwitchPage(direction)
        if (direction == "right") then
            currentIndex = currentIndex + maxItems
        else
            currentIndex = currentIndex - maxItems
        end

        if (currentIndex < 1) then
            if (#itemList % maxItems == 0) then
                currentIndex = #itemList - maxItems + 1
            else
                currentIndex = #itemList - (#itemList % maxItems - 1)
            end
        end
        if (currentIndex > #itemList) then
            currentIndex = 1
        end

        self:Clear()
        pageItem.text.title = 1 + (math.floor(currentIndex / maxItems))
        self:Add(pageItem)

        for i = currentIndex, currentIndex + maxItems - 1, 1 do
            if (i <= #itemList) then
                self:Add(itemList[i])
            end
        end

        RecalculatePosition(self.position)
    end

    function self:AddAnyItem(item)
        table.insert(itemList, item)

        if (#itemList > maxItems) then
            self:Clear()

            self:Add(pageItem)
            for i = 1, maxItems, 1 do
                if (i <= #itemList) then
                    self:Add(itemList[i])
                end
            end
        end

        if (#itemList <= maxItems) then
            self:Add(item)
        end

        RecalculatePosition(self.position)

        return item
    end

    -- processes and draws the menu
    function self:Process(cursorPosition)
        if (not visible) then
            return
        end

        for i, item in next, (self.objectList) do
            if (item.Process) then
                item:Process(cursorPosition)
            end
        end
    end

    function self:Draw()
        if (not visible) then
            return
        end

        for i, obj in next, (self.objectList) do
            obj:Draw()
        end

        border:Draw()
    end

    -- get/set the visibility of the Menu
    function self:Visible(visibility)
        if (visibility == nil) then
            return visible
        end

        --if (visibility == false) then
        --    CreateThread(function()
        --        self.OnClosed()
        --    end);
        --end
        visible = visibility
    end

    -- get/set the position of the Menu
    function self:Position(_position)
        if (_position == nil) then
            return self.position
        end

        RecalculatePosition(_position)
    end

    -- checks if the given position is inside the bounds of the Menu
    function self:InBounds(point)
        local pos = self:AbsolutePosition()
        return point.x >= pos.x
            and point.y >= pos.y
            and point.x < lowerRight.x
            and point.y < lowerRight.y
    end

    function self:IsOverlapped()
        for i, item in next, (self.objectList) do
            if (item.submenu and item.submenu:Visible()) then
                for j, subItem in next, (item.submenu.objectList) do
                    if (subItem.submenu and subItem.submenu.objectList) then
                        for k, sub2Item in next, (subItem.submenu.objectList) do
                            if (self:InBounds(sub2Item.position + vector2(sub2Item.parent.width, sub2Item.height) * 0.5)) then
                                return true
                            end
                        end
                    end
                end
            end
        end

        return false
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (itemList) do
            if (itemList[k].Destroy) then
                itemList[k]:Destroy()
            end

            itemList[k] = nil
        end

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

PageMenu = {}
PageMenu.__index = PageMenu
setmetatable(PageMenu, {
    __call = function(cls, ...)
        return NewPageMenu(...)
    end
})

PageMenu.__tostring = function(obj)
    return string.format("PageMenu()")
end

PageMenu.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end

local DEFAULT_HEIGHT = 0.03

local SCROLL_TIME = 150

local function NewPageItem(scrollMenu)
    local self = setmetatable(BaseItem(scrollMenu), PageItem)

    self.colors = {
        background  = self.parent.colors.background or Colors.DarkGrey:Alpha(180),
        hBackground = self.parent.colors.hBackground or Colors.LightGrey:Alpha(180),
        arrow       = self.parent.colors.text or Colors.White,
        hArrow      = self.parent.colors.hText or Colors.White
    }

    -- segment background
    self:Remove(self.background)

    self.background = SpriteUV(BACKGROUND.TXD, BACKGROUND.NAME, vector2(0, 0),
        vector2(self.parent.width * 0.4, self.height), 0.0, self.colors.background)
    self.background.uv2 = vector2(0.4, 1.0)
    self:Add(self.background)

    self.background2 = SpriteUV(BACKGROUND.TXD, BACKGROUND.NAME, vector2(self.parent.width * 0.4, 0),
        vector2(self.parent.width * 0.2, self.height), 0.0, self.colors.background)
    self.background2.uv1 = vector2(0.4, 0.0)
    self.background2.uv2 = vector2(0.6, 1.0)
    self:Add(self.background2)

    self.background3 = SpriteUV(BACKGROUND.TXD, BACKGROUND.NAME, vector2(self.parent.width * 0.6, 0),
        vector2(self.parent.width * 0.4, self.height), 0.0, self.colors.background)
    self.background3.uv1 = vector2(0.6, 0.0)
    self.background3.uv2 = vector2(1.0, 1.0)
    self:Add(self.background3)

    -- page number
    self.text = Text(1, self.colors.text, vector2(self.parent.width * 0.5, 0.0), 0.4, TextAlignment.Center)
    self.text.maxWidth = self.parent.width * 0.2
    self:Add(self.text)

    self.hoveredLeft  = false
    self.hoveredRight = false

    local scale       = vector2(self.parent.width, DEFAULT_HEIGHT)

    local direction   = _direction
    self.sprite       = SpriteUV("commonmenu", "arrowleft", vector2(self.parent.width * 0.15, 0.0),
        vector2(0.015, 0.015 * GetAspectRatio(false)))
    self.sprite2      = SpriteUV("commonmenu", "arrowright", vector2(self.parent.width * 0.75, 0.0),
        vector2(0.015, 0.015 * GetAspectRatio(false)))
    self:Add(self.sprite)
    self:Add(self.sprite2)

    self.OnActivate   = function() end
    self.OnRelease    = function() end
    self.OnStartHover = function() end
    self.OnEndHover   = function() end



    function self:InLeftBounds(point)
        local pos = self:AbsolutePosition()
        return point.x >= pos.x
            and point.y >= pos.y
            and point.x < pos.x + self.parent.width * self.parent.scale.x * 0.5
            and point.y < pos.y + self.height * self.parent.scale.y
    end

    -- process the Item
    function self:Process(cursorPosition)
        if (not self.enabled) then
            return
        end

        local hovered = self:InBounds(cursorPosition)
        if (hovered ~= self.hovered) then
            self.hovered = hovered

            if (self.hovered) then
                CreateThread(function()
                    self.OnStartHover()
                end);
            else
                CreateThread(function()
                    self.OnEndHover()
                end);

                self.background.color = self.colors.background
                self.background3.color = self.colors.background

                self.sprite.color = self.colors.arrow
                self.sprite2.color = self.colors.arrow
            end
        end

        if (self.hovered) then
            local hoveredLeft = self:InLeftBounds(cursorPosition)
            self.hoveredLeft = hoveredLeft
            self.background.color = hoveredLeft and self.colors.hBackground or self.colors.background
            self.background3.color = not hoveredLeft and self.colors.hBackground or self.colors.background

            self.sprite.color = hoveredLeft and self.colors.hArrow or self.colors.arrow
            self.sprite2.color = not hoveredLeft and self.colors.hArrow or self.colors.arrow
        end
    end

    function self:Activated()
        if (not self.enabled) then
            return
        end

        if (self.hoveredLeft) then
            self.parent:SwitchPage("left")
        else
            self.parent:SwitchPage("right")
        end

        CreateThread(function()
            self.OnActivate()
        end);
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

PageItem = {}
PageItem.__index = PageItem
setmetatable(PageItem, {
    __call = function(cls, ...)
        return NewPageItem(...)
    end
})

PageItem.__tostring = function(obj)
    return string.format("PageItem()")
end

PageItem.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end


local DEFAULT_HEIGHT = 0.03

local function NewBaseItem(menu)
    local self = setmetatable(Container(), BaseItem)

    -- if the item is enabled and shows in the Menu
    self.enabled = true

    -- the parent Menu of the Item
    self.parent = menu

    -- the colors of the Item
    self.colors = {
        background = self.parent and self.parent.colors.background or Colors.DarkGrey
    }

    -- the height of the Item
    self.height = DEFAULT_HEIGHT

    -- the background sprite of the Item
    self.background = Sprite(BACKGROUND.TXD, BACKGROUND.NAME, vector2(0, 0), vector2(self.parent.width, self.height), 0.0,
        self.colors.background)
    self:Add(self.background)

    self.isOverlapped = false



    -- get/set if the Item is enabled
    function self:Enabled(newEnabled)
        if (newEnabled == nil) then
            return self.enabled
        end

        self.enabled = newEnabled
    end

    -- process the Item
    function self:Process()
        return
    end

    function self:Draw()
        if (self.isOverlapped) then
            return
        end

        for i, obj in next, (self.objectList) do
            obj:Draw()
        end
    end

    -- get/set the height of the Item
    function self:Height(newHeight)
        if (not newHeight) then
            return self.height
        end

        self.height = newHeight

        self.background:Size(vector2(self.parent.width, self.height))
    end

    -- checks, if a screen relative point is inside the item bounds
    function self:InBounds(point)
        local pos = self:AbsolutePosition()
        return point.x >= pos.x
            and point.y >= pos.y
            and point.x < pos.x + self.parent.width * self.parent.scale.x
            and point.y < pos.y + self.height * self.parent.scale.y
    end

    -- checks, if the item is currently overlapped by another menu
    function self:IsOverlapped()
        for i, menu in next, (self.parent.pool.menus) do
            if (menu:Visible() and menu.order > self.parent.order) then
                local pos = self.position + vector2(self.parent.width, self.height) * 0.5
                for j, item in next, (menu.objectList) do
                    if (item.InBounds ~= nil and item:InBounds(pos)) then
                        self.isOverlapped = true

                        return true
                    end
                end
            end
        end

        self.isOverlapped = false

        return false
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

BaseItem = {}
BaseItem.__index = BaseItem
setmetatable(BaseItem, {
    __call = function(cls, ...)
        return NewBaseItem(...)
    end
})

BaseItem.__tostring = function(obj)
    return string.format("BaseItem()")
end

BaseItem.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end

local DEFAULT_HEIGHT = 0.03

local function NewSpriteItem(menu, textureDict, textureName)
    local self = setmetatable(BaseItem(menu), SpriteItem)

    self.colors = {
        background = self.parent.colors.background,
        text       = self.parent.colors.text,
        rightText  = self.parent.colors.text
    }

    self.hovered = false

    local x, y = GetActiveScreenResolution()
    local texRes = GetTextureResolution(textureDict, textureName)

    local scale = vector2(self.parent.width, DEFAULT_HEIGHT)

    self.sprite = Sprite(textureDict, textureName, nil, scale)
    self:Add(self.sprite)

    self.highlight    = Rect(vector2(0, 0), vector2(self.parent.width, self.height), Colors.White:Alpha(50))

    self.OnActivate   = function() end
    self.OnRelease    = function() end
    self.OnStartHover = function() end
    self.OnEndHover   = function() end



    -- process the Item
    function self:Process(cursorPosition)
        if (not self.enabled) then
            return
        end

        local hovered = self:InBounds(cursorPosition)
        if (hovered ~= self.hovered) then
            self.hovered = hovered

            if (self.hovered) then
                self:Add(self.highlight)

                CreateThread(function()
                    self.OnStartHover()
                end);
            else
                self:Remove(self.highlight)

                CreateThread(function()
                    self.OnEndHover()
                end);
            end
        end
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

SpriteItem = {}
SpriteItem.__index = SpriteItem
setmetatable(SpriteItem, {
    __call = function(cls, ...)
        return NewSpriteItem(...)
    end
})

SpriteItem.__tostring = function(obj)
    return string.format("SpriteItem()")
end

SpriteItem.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end


local function NewSprite(_dict, _name, _position, _size, _angle, _color)
    local self             = setmetatable(Object2D(_position, vector2(1.0, 1.0)), Sprite)

    -- private
    local dict             = _dict
    local name             = _name

    local internalPosition = vector2(0, 0)
    local internalScale    = vector2(1, 1)

    -- public
    local size             = _size or vector2(1.0, 1.0)

    self.angle             = _angle or 0.0
    self.color             = _color or Colors.White



    -- get/set the position of the Rect
    function self:Position(newPosition)
        if (not newPosition) then
            return self.position
        end

        self.position = newPosition

        internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

        -- re-calc children position
        for i, child in next, (self.children) do
            child:Position(child:Position())
        end
    end

    -- get/set the scale of the Rect
    function self:Scale(newScale)
        if (not newScale) then
            return self.scale
        end

        self.scale = newScale

        internalScale = self:AbsoluteScale() * size
        internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

        -- re-calc children scale
        for i, child in next, (self.children) do
            child:Scale(child:Scale())
        end
    end

    -- get/set the size of the Rect
    function self:Size(newSize)
        if (not newSize) then
            return size
        end

        size = newSize

        internalScale = self:AbsoluteScale() * size
        internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

        -- re-calc children scale
        for i, child in next, (self.children) do
            child:Scale(child:Scale())
        end
    end

    -- draw the Sprite to the screen
    function self:Draw()
        DrawSprite(
            dict, name,
            internalPosition.x, internalPosition.y,
            internalScale.x, internalScale.y,
            self.angle,
            self.color.r, self.color.g, self.color.b, self.color.a
        )
    end

    -- get the texture dictionary of the Sprite
    function self:Dict()
        return dict
    end

    -- get the name of the Sprite
    function self:Name()
        return name
    end

    function self:Sprite(_dict, _name)
        dict = _dict
        name = _name

        -- request dictionary
        if (not HasStreamedTextureDictLoaded(dict)) then
            RequestStreamedTextureDict(dict, true)
        end
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    -- request dictionary
    if (not HasStreamedTextureDictLoaded(dict)) then
        RequestStreamedTextureDict(dict, true)
    end

    -- re-calc position and scale once
    self:Position(_position)
    self:Scale(vector2(1.0, 1.0))

    return self
end

Sprite = {}
Sprite.__index = Sprite
setmetatable(Sprite, {
    __call = function(cls, ...)
        return NewSprite(...)
    end
})

Sprite.__tostring = function(sprite)
    return string.format("Sprite(\"%s\", \"%s\")", sprite:Dict(), sprite:Name())
end

Sprite.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end


local function NewSpriteUV(_dict, _name, _position, _size, _angle, _color)
    local self             = setmetatable(Object2D(_position, vector2(1.0, 1.0)), Sprite)

    -- private
    local dict             = _dict
    local name             = _name

    local internalPosition = vector2(0, 0)
    local internalScale    = vector2(1, 1)

    local size             = _size or vector2(1.0, 1.0)

    -- public
    self.angle             = _angle or 0.0
    self.color             = _color or Colors.White

    self.uv1               = vector2(0.0, 0.0)
    self.uv2               = vector2(1.0, 1.0)



    -- get/set the position of the Rect
    function self:Position(newPosition)
        if (not newPosition) then
            return self.position
        end

        self.position = newPosition

        internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

        -- re-calc children position
        for i, child in next, (self.children) do
            child:Position(child:Position())
        end
    end

    -- get/set the scale of the Rect
    function self:Scale(newScale)
        if (not newScale) then
            return self.scale
        end

        self.scale = newScale

        internalScale = self:AbsoluteScale() * size
        internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

        -- re-calc children scale
        for i, child in next, (self.children) do
            child:Scale(child:Scale())
        end
    end

    -- draw the Sprite to the screen
    function self:Draw()
        DrawSpriteUv(
            dict, name,
            internalPosition.x, internalPosition.y,
            internalScale.x, internalScale.y,
            self.uv1.x, self.uv1.y, self.uv2.x, self.uv2.y,
            self.angle,
            self.color.r, self.color.g, self.color.b, self.color.a
        )
    end

    -- get the texture dictionary of the SpriteUV
    function self:Dict()
        return dict
    end

    -- get the name of the SpriteUV
    function self:Name()
        return name
    end

    function self:Sprite(_dict, _name)
        dict = _dict
        name = _name

        -- request dictionary
        if (not HasStreamedTextureDictLoaded(dict)) then
            RequestStreamedTextureDict(dict, true)
        end
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    -- request dictionary
    if (not HasStreamedTextureDictLoaded(dict)) then
        RequestStreamedTextureDict(dict, true)
    end

    -- re-calc position and scale once
    self:Position(_position)
    self:Scale(vector2(1.0, 1.0))

    return self
end

SpriteUV = {}
SpriteUV.__index = SpriteUV
setmetatable(SpriteUV, {
    __call = function(cls, ...)
        return NewSpriteUV(...)
    end
})

SpriteUV.__tostring = function(sprite)
    return string.format("SpriteUV(\"%s\", \"%s\")", sprite:Dict(), sprite:Name())
end

SpriteUV.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end

local HOVER_TIMEOUT = 250

local function NewSubmenuItem(menu, title, submenu)
    -- create the SubmenuItem
    local self = setmetatable(Item(menu, title), SubmenuItem)

    -- add all necessary colors
    self.colors = {
        background  = self.parent.colors.background,
        hBackground = self.parent.colors.hBackground,
        text        = self.parent.colors.text,
        hText       = self.parent.colors.hText,
        rightText   = self.parent.colors.text,
        hRightText  = self.parent.colors.hText
    }

    self.submenu = submenu
    submenu:Visible(false)

    self.rightText = nil

    self:RightSprite("commonmenu", "arrowright")

    self.closeOnActivate = false

    self.hovered = nil



    self.OnActivate   = function() end
    self.OnRelease    = function() end
    self.OnStartHover = function() end
    self.OnEndHover   = function() end



    local function Coroutine_StartedHoveringForSubmenu()
        CreateThread(function()
            local startTime = GetGameTimer()
            while (true) do
                if (not self.hovered or (self.submenu and self.submenu:Visible()) or (self.parent and not self.parent:Visible())) then
                    return
                end

                if (GetGameTimer() - HOVER_TIMEOUT >= startTime) then
                    if (self.OpenSubmenu) then
                        self:OpenSubmenu()
                    end

                    return
                end

                Wait(0)
            end
        end);
    end
    local function Coroutine_StoppedHoveringForSubmenu()
        CreateThread(function()
            local startTime = GetGameTimer()
            while (true) do
                if (self.hovered or (self.submenu and not self.submenu:Visible()) or (self.submenu and self.submenu:InBounds(GetCursorScreenPosition()))) then
                    return
                end

                if (GetGameTimer() - HOVER_TIMEOUT >= startTime) then
                    if (self.CloseSubmenu) then
                        self:CloseSubmenu()
                    end

                    return
                end

                Wait(0)
            end
        end);
    end

    -- process the SubmenuItem
    function self:Process(cursorPosition)
        if (not self.enabled) then
            return
        end

        local hovered = self:InBounds(cursorPosition)
        if (hovered ~= self.hovered) then
            self.hovered = hovered

            self.text.color = self.hovered and self.colors.hText or self.colors.text
            self.background.color = self.hovered and self.colors.hBackground or self.colors.background

            if (self.hovered) then
                CreateThread(function()
                    Coroutine_StartedHoveringForSubmenu(self)

                    self.OnStartHover()
                end);
            else
                CreateThread(function()
                    Coroutine_StoppedHoveringForSubmenu(self)

                    self.OnEndHover()
                end);
            end
        end
    end

    function self:OpenSubmenu()
        for i = 1, #self.parent.objectList, 1 do
            if (self.parent.objectList[i] ~= self and self.parent.objectList[i].submenu and self.parent.objectList[i].submenu:Visible()) then
                self.parent.objectList[i]:CloseSubmenu()
            end
        end

        self.submenu:Position(self.position + vector2(self.parent.width, 0.0))
        self.submenu:Visible(true)
    end

    function self:CloseSubmenu()
        for i = 1, #self.submenu.objectList, 1 do
            if (self.submenu.objectList[i].submenu and self.submenu.objectList[i].submenu:Visible()) then
                self.submenu.objectList[i]:CloseSubmenu()
            end
        end

        self.submenu:Visible(false)
    end

    function self:Activated()
        if (not enabled) then
            return
        end

        CreateThread(function()
            self:OpenSubmenu()
        end);

        CreateThread(function()
            self.OnActivate()
        end);
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

SubmenuItem = {}
SubmenuItem.__index = SubmenuItem
setmetatable(SubmenuItem, {
    __call = function(cls, ...)
        return NewSubmenuItem(...)
    end
})

SubmenuItem.__tostring = function(obj)
    return string.format("SubmenuItem()")
end

SubmenuItem.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end

local function NewItem(menu, title)
    -- create the Item
    local self = setmetatable(TextItem(menu, title), Item)

    -- add all necessary colors
    self.colors = {
        background  = self.parent and self.parent.colors.background or Colors.DarkGrey:Alpha(180),
        hBackground = self.parent and self.parent.colors.hBackground or Colors.LightGrey:Alpha(180),
        text        = self.parent and self.parent.colors.text or Colors.White,
        hText       = self.parent and self.parent.colors.hText or Colors.White,
        rightText   = self.parent and self.parent.colors.text or Colors.White,
        hRightText  = self.parent and self.parent.colors.hText or Colors.White
    }

    self.closeOnActivate = false

    self.hovered = false



    self.OnActivate   = function() end
    self.OnRelease    = function() end
    self.OnStartHover = function() end
    self.OnEndHover   = function() end



    -- process the Item
    function self:Process(cursorPosition)
        if (not self.enabled) then
            return
        end

        if (self:IsOverlapped(cursorPosition)) then
            return
        end

        local hovered = self:InBounds(cursorPosition)
        if (hovered ~= self.hovered) then
            self.hovered = hovered

            self.text.color = self.hovered and self.colors.hText or self.colors.text
            self.background.color = self.hovered and self.colors.hBackground or self.colors.background
            if (self.rightText) then
                self.rightText.color = self.hovered and self.colors.hRightText or self.colors.rightText
            end

            if (self.hovered) then
                CreateThread(function()
                    self.OnStartHover()
                end);
            else
                CreateThread(function()
                    self.OnEndHover()
                end);
            end
        end
    end

    function self:Draw()
        if (self.isOverlapped) then
            return
        end

        for i, obj in next, (self.objectList) do
            obj:Draw()
        end
    end

    -- get/set the height of the Item
    --function self:Height(newHeight)
    --    if (not newHeight) then
    --        return self:Height()
    --    end
    --
    --    self:Height(newHeight)
    --end

    function self:Activated()
        if (not self.enabled) then
            return
        end

        CreateThread(function()
            self.OnActivate()
        end);

        if (self.closeOnActivate) then
            self.parent.pool:CloseAllMenus()
        end
    end

    function self:Released()
        if (not self.enabled) then
            return
        end

        CreateThread(function()
            self.OnRelease()
        end);
    end

    function self:Destroy()
        self.parent = nil

        for k, v in next, (self.children) do
            if (self.children[k].Destroy) then
                self.children[k]:Destroy()
            end

            self.children[k] = nil
        end

        for k, v in next, (self.objectList) do
            if (self.objectList[k].Destroy) then
                self.objectList[k]:Destroy()
            end

            self.objectList[k] = nil
        end

        for k, v in next, (self) do
            self[k] = nil
        end
    end

    return self
end

Item = {}
Item.__index = Item
setmetatable(Item, {
    __call = function(cls, ...)
        return NewItem(...)
    end
})

Item.__tostring = function(obj)
    return string.format("Item()")
end

Item.__gc = function(obj)
    if (obj.Destroy) then
        obj:Destroy()
    end
end

local copy = {
    hasRequest = false,
    outfit = nil,
    requester = 0
}

RegisterNetEvent("ali:copyOutfit:client", function(name, id)
    CreateThread(function()
        Wait(10000)
        copy.hasRequest = false
        copy.requester = 0
    end);

    if not copy.hasRequest then
        copy.hasRequest = true
        copy.requester = id
        Config.HUD.announce({
            title = "COPY OUTFIT",
            text = name ..
                ' Möchte Dein Outfit kopieren. Drücke <span style="color: var(--serverColor);">K</span> um es anzunehmen, und <span style="color: var(--serverColor);">B</span> um es abzulehnen! <br>Die Anfrage läuft in 10 Sekunden ab',
            time = 5000
        })
    end
end);

RegisterNetEvent("ali:copyOutfit:client:accept", function(skin)
    TriggerEvent('skinchanger:loadSkin', skin)

    Config.HUD.Notify({
        title = "COPY OUTFIT",
        text = "Copy Outfit angenommen!",
        type = "success",
        time = 3500
    })
end);

RegisterKeyMapping("decoutfit", "Outfit Anfrage ablehnen", "keyboard", "B")
RegisterKeyMapping("accoutfit", "Outfit Anfrage annehmen", "keyboard", "K")

RegisterCommand("accoutfit", function()
    if copy.hasRequest and copy.requester > 0 then
        TriggerServerEvent("ali:copyOutfit:server:accept", copy.requester)
        copy.hasRequest = false
        copy.requester = 0
    end
end, false)

RegisterCommand("decoutfit", function()
    if copy.hasRequest and copy.requester > 0 then
        TriggerServerEvent("ali:deny:copy", copy.requester)
        copy.hasRequest = false
        copy.requester = 0
    end
end, false)
