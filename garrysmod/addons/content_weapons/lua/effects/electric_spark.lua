function EFFECT:Init(data)
    self.Position = data:GetOrigin()
    self.Scale = data:GetMagnitude() or 1 -- Adjust scale as needed

    local entindex = data:GetEntity():EntIndex()

    -- Start a coroutine to create the electric spark effect
    coroutine.wrap(function()
        for i = 1, math.random(5, 10) do
            local lightning = ents.Create("point_tesla")
            lightning:SetPos(self.Position)
            lightning:SetKeyValue("m_SoundName", "")
            lightning:SetKeyValue("texture", "sprites/bluelight1.spr")
            lightning:SetKeyValue("m_Color", "255 255 150")
            lightning:SetKeyValue("m_flRadius", "150")
            lightning:SetKeyValue("beamcount_max", "15")
            lightning:SetKeyValue("thick_min", "15")
            lightning:SetKeyValue("thick_max", "30")
            lightning:SetKeyValue("lifetime_min", "0.15")
            lightning:SetKeyValue("lifetime_max", "0.4")
            lightning:SetKeyValue("interval_min", "0.15")
            lightning:SetKeyValue("interval_max", "0.25")
            lightning:Spawn()
            lightning:Fire("DoSpark", "", 0)
            lightning:Fire("kill", "", 0.2)

            local light = ents.Create("light_dynamic")
            light:SetPos(self.Position)
            light:Spawn()
            light:SetKeyValue("_light", "100 100 255")
            light:SetKeyValue("distance", "550")
            light:Fire("Kill", "", 0.20)

            sound.Play("k_lab.teleport_spark", self.Position, 110)

            -- Wait for a random interval before creating the next spark
            local interval = math.Rand(0.03, 0.1)
            coroutine.yield(interval)
        end
    end)()
end

function EFFECT:Think()
    -- No need to continue thinking
    return false
end

function EFFECT:Render()
end