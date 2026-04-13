hook.Add("LoadFlareConfiguration", "NUClassTransport", function ()
    UF:RegisterFlareVehicleConfiguration("lvs_nuclass_attack_shuttle",
            {
                {
                    pos = Vector(-317,148,127), -- Position where to eject flares.
                    dir = UF.CONST.BACKWARDS, -- In which direction to eject flares, defaults available: UF.CONST.BACKWARDS, UF.CONST.RIGHT, UF.CONST.LEFT.
                    dirMulti = 2000, -- Optional velocity multiplier for ejecting flares.
                },
                {
                    pos = Vector(-317,-148,127),
                    dir = UF.CONST.BACKWARDS,
                    dirMulti = 2000,
                },
            },
            1, -- Which seat should control the flares. Default 0.
            16, -- The total times the flares can be used. Default 16.
            10 -- The amount of individual flares that should be deployed per burst. Default 5.
    )
    UF:RegisterFlareVehicleConfiguration("lvs_nuclass_attack_shuttle_medical",
            {
                {
                    pos = Vector(-317,148,127), -- Position where to eject flares.
                    dir = UF.CONST.BACKWARDS, -- In which direction to eject flares, defaults available: UF.CONST.BACKWARDS, UF.CONST.RIGHT, UF.CONST.LEFT.
                    dirMulti = 2000, -- Optional velocity multiplier for ejecting flares.
                },
                {
                    pos = Vector(-317,-148,127),
                    dir = UF.CONST.BACKWARDS,
                    dirMulti = 2000,
                },
            },
            1, -- Which seat should control the flares. Default 0.
            16, -- The total times the flares can be used. Default 16.
            10 -- The amount of individual flares that should be deployed per burst. Default 5.
    )
    UF:RegisterFlareVehicleConfiguration("lvs_nuclass_attack_shuttle_imp",
            {
                {
                    pos = Vector(-317,148,127), -- Position where to eject flares.
                    dir = UF.CONST.BACKWARDS, -- In which direction to eject flares, defaults available: UF.CONST.BACKWARDS, UF.CONST.RIGHT, UF.CONST.LEFT.
                    dirMulti = 2000, -- Optional velocity multiplier for ejecting flares.
                },
                {
                    pos = Vector(-317,-148,127),
                    dir = UF.CONST.BACKWARDS,
                    dirMulti = 2000,
                },
            },
            1, -- Which seat should control the flares. Default 0.
            16, -- The total times the flares can be used. Default 16.
            10 -- The amount of individual flares that should be deployed per burst. Default 5.
    )
    UF:RegisterFlareVehicleConfiguration("lvs_nuclass_attack_shuttle_medical_2",
            {
                {
                    pos = Vector(-317,148,127), -- Position where to eject flares.
                    dir = UF.CONST.BACKWARDS, -- In which direction to eject flares, defaults available: UF.CONST.BACKWARDS, UF.CONST.RIGHT, UF.CONST.LEFT.
                    dirMulti = 2000, -- Optional velocity multiplier for ejecting flares.
                },
                {
                    pos = Vector(-317,-148,127),
                    dir = UF.CONST.BACKWARDS,
                    dirMulti = 2000,
                },
            },
            1, -- Which seat should control the flares. Default 0.
            16, -- The total times the flares can be used. Default 16.
            10 -- The amount of individual flares that should be deployed per burst. Default 5.
    )
    UF:RegisterFlareVehicleConfiguration("lvs_nuclass_attack_shuttle_republic",
            {
                {
                    pos = Vector(-317,148,127), -- Position where to eject flares.
                    dir = UF.CONST.BACKWARDS, -- In which direction to eject flares, defaults available: UF.CONST.BACKWARDS, UF.CONST.RIGHT, UF.CONST.LEFT.
                    dirMulti = 2000, -- Optional velocity multiplier for ejecting flares.
                },
                {
                    pos = Vector(-317,-148,127),
                    dir = UF.CONST.BACKWARDS,
                    dirMulti = 2000,
                },
            },
            1, -- Which seat should control the flares. Default 0.
            16, -- The total times the flares can be used. Default 16.
            10 -- The amount of individual flares that should be deployed per burst. Default 5.
    )
    UF:RegisterFlareVehicleConfiguration("lvs_nuclass_attack_shuttle_republic_2",
            {
                {
                    pos = Vector(-317,148,127), -- Position where to eject flares.
                    dir = UF.CONST.BACKWARDS, -- In which direction to eject flares, defaults available: UF.CONST.BACKWARDS, UF.CONST.RIGHT, UF.CONST.LEFT.
                    dirMulti = 2000, -- Optional velocity multiplier for ejecting flares.
                },
                {
                    pos = Vector(-317,-148,127),
                    dir = UF.CONST.BACKWARDS,
                    dirMulti = 2000,
                },
            },
            1, -- Which seat should control the flares. Default 0.
            16, -- The total times the flares can be used. Default 16.
            10 -- The amount of individual flares that should be deployed per burst. Default 5.
    )
end)