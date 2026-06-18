prop.net = prop.net or {}
prop.net.type = prop.net.type or {
    nilValue = 0,
    bool = 1,
    number = 2,
    string = 3,
    color = 4,
    vector = 5,
    angle = 6
}

prop.net.maxKeyLength = prop.config.get("netMaxKeyLength", 64)
prop.net.maxStringLength = prop.config.get("netMaxStringLength", 512)
prop.net.maxChatParts = prop.config.get("netMaxChatParts", 32)

local TYPE_NIL = prop.net.type.nilValue
local TYPE_BOOL = prop.net.type.bool
local TYPE_NUMBER = prop.net.type.number
local TYPE_STRING = prop.net.type.string
local TYPE_COLOR = prop.net.type.color
local TYPE_VECTOR = prop.net.type.vector
local TYPE_ANGLE = prop.net.type.angle

local function isColor(value)
    return istable(value) and isnumber(value.r) and isnumber(value.g) and isnumber(value.b)
end

local function toByte(value, default)
    return math.Clamp(math.floor(tonumber(value) or default), 0, 255)
end

local function normalizeString(value, maxLength)
    value = tostring(value or "")
    if #value > maxLength then
        value = string.sub(value, 1, maxLength)
    end

    return value
end

function prop.net.isValidKey(key)
    return isstring(key) and key ~= "" and #key <= prop.net.maxKeyLength
end

function prop.net.getValueType(value)
    if value == nil then return TYPE_NIL end
    if type(value) == "boolean" then return TYPE_BOOL end
    if isnumber(value) then return TYPE_NUMBER end
    if isstring(value) then return TYPE_STRING end
    if isColor(value) then return TYPE_COLOR end
    if isvector and isvector(value) then return TYPE_VECTOR end
    if isangle and isangle(value) then return TYPE_ANGLE end
end

function prop.net.canWriteValue(value)
    local valueType = prop.net.getValueType(value)
    if not valueType then return false, "unsupported_type" end
    if valueType == TYPE_STRING and #value > prop.net.maxStringLength then return false, "string_too_long" end

    return true
end

function prop.net.writeColor(color)
    net.WriteUInt(toByte(color.r, 255), 8)
    net.WriteUInt(toByte(color.g, 255), 8)
    net.WriteUInt(toByte(color.b, 255), 8)
    net.WriteUInt(toByte(color.a, 255), 8)
end

function prop.net.readColor()
    return Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
end

function prop.net.writeValue(value)
    local valueType = prop.net.getValueType(value)
    if not valueType then return false, "unsupported_type" end

    net.WriteUInt(valueType, 3)

    if valueType == TYPE_BOOL then
        net.WriteBool(value)
    elseif valueType == TYPE_NUMBER then
        net.WriteDouble(value)
    elseif valueType == TYPE_STRING then
        net.WriteString(value)
    elseif valueType == TYPE_COLOR then
        prop.net.writeColor(value)
    elseif valueType == TYPE_VECTOR then
        net.WriteVector(value)
    elseif valueType == TYPE_ANGLE then
        net.WriteAngle(value)
    end

    return true
end

function prop.net.readValue()
    local valueType = net.ReadUInt(3)

    if valueType == TYPE_NIL then
        return nil
    elseif valueType == TYPE_BOOL then
        return net.ReadBool()
    elseif valueType == TYPE_NUMBER then
        return net.ReadDouble()
    elseif valueType == TYPE_STRING then
        return net.ReadString()
    elseif valueType == TYPE_COLOR then
        return prop.net.readColor()
    elseif valueType == TYPE_VECTOR then
        return net.ReadVector()
    elseif valueType == TYPE_ANGLE then
        return net.ReadAngle()
    end
end

function prop.net.normalizeChatParts(parts)
    if not istable(parts) then return false, "invalid_parts" end

    local normalized = {}

    for _, part in ipairs(parts) do
        if isColor(part) then
            table.insert(normalized, Color(toByte(part.r, 255), toByte(part.g, 255), toByte(part.b, 255), toByte(part.a, 255)))
        elseif isstring(part) or isnumber(part) or type(part) == "boolean" then
            table.insert(normalized, normalizeString(part, prop.net.maxStringLength))
        else
            return false, "unsupported_chat_part"
        end

        if #normalized >= prop.net.maxChatParts then break end
    end

    if #normalized == 0 then return false, "empty_parts" end
    return normalized
end

function prop.net.writeChatParts(parts)
    net.WriteUInt(#parts, 8)

    for _, part in ipairs(parts) do
        if isColor(part) then
            net.WriteBool(true)
            prop.net.writeColor(part)
        else
            net.WriteBool(false)
            net.WriteString(part)
        end
    end
end

function prop.net.readChatParts()
    local count = math.min(net.ReadUInt(8), prop.net.maxChatParts)
    local parts = {}

    for i = 1, count do
        if net.ReadBool() then
            parts[i] = prop.net.readColor()
        else
            parts[i] = net.ReadString()
        end
    end

    return parts
end

