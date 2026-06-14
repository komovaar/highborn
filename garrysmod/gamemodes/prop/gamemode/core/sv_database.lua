prop.db = prop.db or {}

function prop.db.init()
    local q = [[
        create table if not exists prop_players (
            sid64 text primary key,
            data text default '{}'
        );
    ]]
    
    local res = sql.Query(q)
    if res == false then 
        error("[prop] Database Error: " .. sql.LastError())
    end

    prop.log("Database Provider Online. Tracks: Identity, State, and Time.")
end

function prop.db.query(str)
    local res = sql.Query(str)

    if res == false then 
        prop.log("error", "SQL Error: " .. sql.LastError())
        prop.log("error", "Failed Query: " .. str)
    end

    return res
end

prop.db.init()
