function ENT:PredictPoseParameters()
    local Pod = self:GetTopGunnerSeat()

    if not IsValid( Pod ) then return end

    local plyL = LocalPlayer()
    local ply = Pod:GetDriver()

    if ply ~= plyL then return end

    self:SetPoseParameterTopGun( Pod:lvsGetWeapon() )

    self:InvalidateBoneCache()
end