prop.money = prop.money or {}

local function normalizeAmount(value)
    local amount = tonumber(value)
    if not amount then return nil end

    amount = math.floor(amount)
    if amount <= 0 then return nil end

    return amount
end

local function getCharacter(ply)
    if not IsValid(ply) then return nil, "invalid_player" end

    local character = prop.characters.getActive(ply)
    if not character then return nil, "no_character" end

    return character
end

function prop.money.get(ply)
    local character = getCharacter(ply)
    if not character then return 0 end

    return tonumber(character.data.money) or 0
end

function prop.money.set(ply, amount, reason)
    local character, characterReason = getCharacter(ply)
    if not character then return false, characterReason end

    amount = math.max(0, math.floor(tonumber(amount) or 0))

    local oldAmount = tonumber(character.data.money) or 0
    if oldAmount == amount then return false, "unchanged" end

    character.data.money = amount

    local ok, saveReason = prop.characters.save(ply)
    if not ok then return false, saveReason end

    hook.Run("prop.MoneyChanged", ply, oldAmount, amount, reason)
    return true
end

function prop.money.add(ply, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if amount == 0 then return false, "invalid_amount" end

    return prop.money.set(ply, prop.money.get(ply) + amount, reason)
end

function prop.money.canAfford(ply, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount < 0 then return false end

    return prop.money.get(ply) >= amount
end

function prop.money.transfer(fromPly, toPly, amount, reason)
    if not IsValid(fromPly) or not IsValid(toPly) then return false, "invalid_player" end
    if fromPly == toPly then return false, "same_player" end

    amount = normalizeAmount(amount)
    if not amount then return false, "invalid_amount" end
    if not prop.money.canAfford(fromPly, amount) then return false, "cant_afford" end

    local takeOK, takeReason = prop.money.add(fromPly, -amount, reason or "transfer")
    if not takeOK then return false, takeReason end

    local giveOK, giveReason = prop.money.add(toPly, amount, reason or "transfer")
    if not giveOK then
        prop.money.add(fromPly, amount, "transfer_refund")
        return false, giveReason
    end

    hook.Run("prop.MoneyTransferred", fromPly, toPly, amount, reason)
    return true
end

local function normalize(value)
    if not isstring(value) then return "" end
    return string.lower(string.Trim(value))
end

local function findPlayer(caller, query)
    query = normalize(query)
    if query == "" then return nil, "missing_player" end
    if query == "me" then return caller end

    local userID = tonumber(query)
    if userID then
        local ply = Player(userID)
        if IsValid(ply) then return ply end
    end

    for _, ply in ipairs(player.GetAll()) do
        if normalize(ply:SteamID()) == query or normalize(ply:SteamID64()) == query then
            return ply
        end
    end

    local matches = {}

    for _, ply in ipairs(player.GetAll()) do
        if string.find(normalize(ply:Nick()), query, 1, true) then
            table.insert(matches, ply)
        end
    end

    if #matches == 1 then return matches[1] end
    if #matches > 1 then return nil, "multiple_players" end

    return nil, "player_not_found"
end

prop.command.add("money", {
    description = "Shows your character balance.",
    usage = "/money",
    category = "Character",
    onRun = function(ply)
        ply:ChatPrint("[prop] Balance: " .. tostring(prop.money.get(ply)))
        return true
    end
})

prop.command.add("pay", {
    description = "Transfers money to another player.",
    usage = "/pay <player> <amount>",
    category = "Character",
    onRun = function(ply, args)
        local target, targetReason = findPlayer(ply, args[1])
        if not target then return false, targetReason end

        local amount = normalizeAmount(args[2])
        if not amount then return false, "invalid_amount" end

        local ok, reason = prop.money.transfer(ply, target, amount, "pay")
        if not ok then return false, reason end

        target:ChatPrint(string.format("[prop] %s paid you %d.", ply:Nick(), amount))
        return true, string.format("[prop] Paid %s %d.", target:Nick(), amount)
    end
})
