prop.salary = prop.salary or {}

local function normalizeInterval(value)
    value = math.floor(tonumber(value) or 0)
    if value <= 0 then return 0 end

    return math.max(30, value)
end

local function getCurrentJob(ply)
    if not IsValid(ply) then return nil end
    return prop.team.get(ply:Team())
end

function prop.salary.getInterval()
    return normalizeInterval(prop.config.salaryInterval)
end

function prop.salary.getJobSalary(job)
    if not job then return 0 end
    return math.max(0, math.floor(tonumber(job.salary) or 0))
end

function prop.salary.getPlayerSalary(ply)
    return prop.salary.getJobSalary(getCurrentJob(ply))
end

function prop.salary.pay(ply, reason)
    if not IsValid(ply) then return false, "invalid_player" end

    local job = getCurrentJob(ply)
    if not job then return false, "no_job" end

    local amount = prop.salary.getJobSalary(job)
    if amount <= 0 then return false, "no_salary" end

    local ok, moneyReason = prop.money.add(ply, amount, reason or "salary")
    if not ok then return false, moneyReason end

    hook.Run("prop.SalaryPaid", ply, amount, job, reason)
    return true, amount
end

function prop.salary.payAll()
    for _, ply in ipairs(player.GetAll()) do
        prop.salary.pay(ply, "salary_tick")
    end

    hook.Run("prop.SalaryTick")
    return true
end

function prop.salary.restartTimer()
    timer.Remove("prop.Salary")

    local interval = prop.salary.getInterval()
    if interval <= 0 then return false, "disabled" end

    timer.Create("prop.Salary", interval, 0, function()
        prop.salary.payAll()
    end)

    return true
end

prop.salary.restartTimer()

hook.Add("prop.SalaryPaid", "prop.NotifySalaryPaid", function(ply, amount, job)
    if not IsValid(ply) then return end

    ply:ChatPrint(string.format("[prop] Salary: +%d (%s).", amount, job.name))
end)

prop.command.add("salary", {
    description = "Shows your current job salary.",
    usage = "/salary",
    category = "Character",
    onRun = function(ply)
        local job = getCurrentJob(ply)
        if not job then return false, "no_job" end

        local amount = prop.salary.getJobSalary(job)
        local interval = prop.salary.getInterval()

        return true, string.format("[prop] %s salary: %d every %d seconds.", job.name, amount, interval)
    end
})
