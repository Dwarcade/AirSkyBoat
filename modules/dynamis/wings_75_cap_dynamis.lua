--------------------------------------------
--      Dynamis Wings 75 Era Module       --
--------------------------------------------
--------------------------------------------
--       Module Required Scripts          --
--------------------------------------------
require("scripts/mixins/job_special")
require("scripts/globals/battlefield")
require("scripts/globals/keyitems")
require("scripts/globals/missions")
require("scripts/globals/npc_util")
require("scripts/globals/status")
require("scripts/globals/titles")
require("scripts/globals/utils")
require("scripts/globals/zone")
require("scripts/globals/msg")
require("scripts/globals/pathfind")
require("scripts/zones/Dynamis-Bastok/dynamis_mobs.lua")
require("scripts/zones/Dynamis-Beaucedine/dynamis_mobs.lua")
require("scripts/zones/Dynamis-Buburimu/dynamis_mobs.lua")
require("scripts/zones/Dynamis-Jeuno/dynamis_mobs.lua")
require("scripts/zones/Dynamis-Qufim/dynamis_mobs.lua")
require("scripts/zones/Dynamis-San_dOria/dynamis_mobs.lua")
require("scripts/zones/Dynamis-Tavnazia/dynamis_mobs.lua")
require("scripts/zones/Dynamis-Valkurm/dynamis_mobs.lua")
require("scripts/zones/Dynamis-Windurst/dynamis_mobs.lua")
require("scripts/zones/Dynamis-Xarcabard/dynamis_mobs.lua")
require("modules/module_utils")
--------------------------------------------
--       Module Affected Scripts          --
--------------------------------------------
require("scripts/globals/dynamis")
--------------------------------------------

local m = Module:new("wings_75_cap_dynamis")
m:setEnabled(true)

xi = xi or {}
xi.dynamis = xi.dynamis or {}

--------------------------------------------
--        Global Dynamis Variables        --
--------------------------------------------
local dynamis_timeless = 4236
local dynamis_perpetual = 4237
local dynamis_min_lvl = 65
local dynamis_reservation_cancel = 180
local dynamis_reentry_days = 3
local dynamis_rentry_hours = 71
local dynamis_win_aoe = false
local dynamis_staging_time = 15 -- Extra time added at registration of dynamis in minutes. Wings gave 15 minutes by default.

local entryInfoEra =
{
        --[[
    [zone] =
    {
        csBit    = the bit in the Dynamis_Status player variable that records whether player has beaten this dynamis
                this bit number is also given to the start Dynamis event and message.
        csSand   = event ID for cutscene where Cornelia gives you the vial of shrouded sand
        csWin    = event ID for cutscene after you have beaten this Dynamis
        csDyna   = event ID for entering Dynamis
        winVar   = variable used to denote players who have beaten this Dynamis, but not yet viewed the cutscene
        winKI    = key item given as reward for this Dynamis
        enterPos = coordinates where player will be placed when entering this Dynamis
        reqs     = function that returns true if player meets requirements for entering this Dynamis
                minimum level and timer are checked separately
    }
        --]]

    [xi.zone.SOUTHERN_SAN_DORIA] =
    {
        csBit = 1,
        csRegisterGlass = 184,
        csSand = 686,
        csWin = 698,
        csDyna = 685,
        maxCapacity = 64,
        enabled = true,
        winVar = "DynaSandoria_Win",
        dynamis_has_enteredVar = "DynaSandoria_dynamis_has_entered",
        hasSeenWinCSVar = "DynaSandoria_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_SAN_DORIA,
        winKI = xi.ki.HYDRA_CORPS_COMMAND_SCEPTER,
        enterPos = {161.838, -2.000, 161.673, 93, 185},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) and
                   (player:getMainLvl() >= dynamis_min_lvl)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.BASTOK_MINES] =
    {
        csBit = 2,
        csRegisterGlass = 200,
        csSand = 203,
        csWin = 215,
        csDyna = 201,
        maxCapacity = 64,
        enabled = true,
        winVar = "DynaBastok_Win",
        dynamis_has_enteredVar = "DynaBastok_dynamis_has_entered",
        hasSeenWinCSVar = "DynaBastok_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_BASTOK,
        winKI = xi.ki.HYDRA_CORPS_EYEGLASS,
        enterPos = {116.482, 0.994, -72.121, 128, 186},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) and
                   (player:getMainLvl() >= dynamis_min_lvl)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.WINDURST_WALLS] =
    {
        csBit = 3,
        csRegisterGlass = 451,
        csSand = 455,
        csWin = 465,
        csDyna = 452,
        maxCapacity = 64,
        enabled = true,
        winVar = "DynaWindurst_Win",
        dynamis_has_enteredVar = "DynaWindurst_dynamis_has_entered",
        hasSeenWinCSVar = "DynaWindurst_HasSeenWinCS",
        zoneName = xi.zone.WINDURST_WALLS,
        winKI = xi.ki.HYDRA_CORPS_LANTERN,
        enterPos = {-221.988, 1.000, -120.184, 0, 187},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) and
                   (player:getMainLvl() >= dynamis_min_lvl)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.RULUDE_GARDENS] =
    {
        csBit = 4,
        csRegisterGlass = 10011,
        csSand = 10016,
        csWin = 10026,
        csDyna = 10012,
        maxCapacity = 64,
        enabled = true,
        winVar = "DynaJeuno_Win",
        dynamis_has_enteredVar = "DynaJeuno_dynamis_has_entered",
        hasSeenWinCSVar = "DynaJeuno_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_JEUNO,
        winKI = xi.ki.HYDRA_CORPS_TACTICAL_MAP,
        enterPos = {48.930, 10.002, -71.032, 195, 188},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) and
                   (player:getMainLvl() >= dynamis_min_lvl)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.BEAUCEDINE_GLACIER] =
    {
        csBit = 5,
        csRegisterGlass = 118,
        csWin = 134,
        csDyna = 119,
        maxCapacity = 64,
        enabled = true,
        winVar = "DynaBeaucedine_Win",
        dynamis_has_enteredVar = "DynaBeaucedine_dynamis_has_entered",
        hasSeenWinCSVar = "DynaBeaucedine_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_BEAUCEDINE,
        winKI = xi.ki.HYDRA_CORPS_INSIGNIA,
        enterPos = {-284.751, -39.923, -422.948, 235, 134},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.HYDRA_CORPS_COMMAND_SCEPTER) and
                    player:hasKeyItem(xi.ki.HYDRA_CORPS_EYEGLASS) and
                    player:hasKeyItem(xi.ki.HYDRA_CORPS_LANTERN) and
                    player:hasKeyItem(xi.ki.HYDRA_CORPS_TACTICAL_MAP) and
                   (player:getMainLvl() >= dynamis_min_lvl)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.XARCABARD] =
    {
        csBit = 6,
        csRegisterGlass = 15,
        csWin = 32,
        csDyna = 16,
        maxCapacity = 64,
        enabled = true,
        winVar = "DynaXarcabard_Win",
        dynamis_has_enteredVar = "DynaXarcabard_dynamis_has_entered",
        hasSeenWinCSVar = "DynaXarcabard_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_XARCABARD,
        winKI = xi.ki.HYDRA_CORPS_BATTLE_STANDARD,
        enterPos = {569.312, -0.098, -270.158, 90, 135},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.HYDRA_CORPS_INSIGNIA) and
                   (player:getMainLvl() >= dynamis_min_lvl)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.VALKURM_DUNES] =
    {
        csBit = 7,
        csRegisterGlass = 15,
        csFirst = 33,
        csWin = 39,
        csDyna = 58,
        maxCapacity = 32,
        enabled = true,
        winVar = "DynaValkurm_Win",
        dynamis_has_enteredVar = "DynaValkurm_dynamis_has_entered",
        hasSeenWinCSVar = "DynaValkurm_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_VALKURM,
        winKI = xi.ki.DYNAMIS_VALKURM_SLIVER,
        enterPos = {100, -8, 131, 47, 39},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) and
                    player:getMainLvl() >= dynamis_min_lvl and
                   (player:hasCompletedMission(COP, xi.mission.id.cop.DARKNESS_NAMED) == true)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.BUBURIMU_PENINSULA] =
    {
        csBit = 8,
        csRegisterGlass = 21,
        csFirst = 40,
        csWin = 46,
        csDyna = 22,
        maxCapacity = 32,
        enabled = true,
        winVar = "DynaBuburimu_Win",
        dynamis_has_enteredVar = "DynaBuburimu_dynamis_has_entered",
        hasSeenWinCSVar = "DynaBuburimu_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_BUBURIMU,
        winKI = xi.ki.DYNAMIS_BUBURIMU_SLIVER,
        enterPos = {155, -1, -169, 170, 40},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) and
                    player:getMainLvl() >= dynamis_min_lvl and
                   (player:hasCompletedMission(COP, xi.mission.id.cop.DARKNESS_NAMED) == true)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.QUFIM_ISLAND] =
    {
        csBit = 9,
        csRegisterGlass = 2,
        csFirst = 22,
        csWin = 28,
        csDyna = 3,
        maxCapacity = 32,
        enabled = true,
        winVar = "DynaQufim_Win",
        dynamis_has_enteredVar = "DynaQufim_dynamis_has_entered",
        hasSeenWinCSVar = "DynaQufim_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_QUFIM,
        winKI = xi.ki.DYNAMIS_QUFIM_SLIVER,
        enterPos = {-19, -17, 104, 253, 41},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) and
                    player:getMainLvl() >= dynamis_min_lvl and
                   (player:hasCompletedMission(COP, xi.mission.id.cop.DARKNESS_NAMED) == true)) or
                   (player:getGMLevel() > 1)
        end,
    },
    [xi.zone.TAVNAZIAN_SAFEHOLD] =
    {
        csBit = 10,
        csRegisterGlass = 587,
        csFirst = 614,
        csWin = 615,
        csDyna = 588,
        maxCapacity = 18,
        enabled = false,
        winVar = "DynaTavnazia_Win",
        dynamis_has_enteredVar = "DynaTavnazia_dynamis_has_entered",
        hasSeenWinCSVar = "DynaQufim_HasSeenWinCS",
        zoneName = xi.zone.DYNAMIS_TAVNAZIA,
        winKI = xi.ki.DYNAMIS_TAVNAZIA_SLIVER,
        enterPos = {0.1, -7, -21, 190, 42},
        reqs = function(player)
            return (player:hasKeyItem(xi.ki.DYNAMIS_VALKURM_SLIVER) and
                    player:hasKeyItem(xi.ki.DYNAMIS_QUFIM_SLIVER) and
                    player:hasKeyItem(xi.ki.DYNAMIS_BUBURIMU_SLIVER) and
                    player:getMainLvl() >= dynamis_min_lvl and
                   (player:hasCompletedMission(COP, xi.mission.id.cop.DARKNESS_NAMED) == true)) or
                   (player:getGMLevel() > 1)
        end,
    },
}

local dynaInfoEra =
{
        --[[
    [zone] =
    {
        winVar = Variable for the Win Condition
        dynamis_has_enteredVar = Variable for Previous Entry
        hasSeenWinCSVar = Variable for Win CS
        winKI = Key item for win
        winTitle = Title for win
        entryPos = Coordinates in destination zone (Dynamis Zone)
        ejectPos = Coordinates in originating zone (Non-Dynamis Zone)
        specifiedChildren = Boolean for using specific children spawns.
        updatedRoam = Boolean for using LimitBreak statue roaming paths.
    }
        --]]

    [xi.zone.DYNAMIS_SAN_DORIA] =
    {
        winVar = "DynaSandoria_Win",
        dynamis_has_enteredVar = "DynaSandoria_dynamis_has_entered",
        hasSeenWinCSVar = "DynaSandoria_HasSeenWinCS",
        dynaNameShort = "DynamisSan",
        winKI = xi.ki.HYDRA_CORPS_COMMAND_SCEPTER,
        winTitle = xi.title.DYNAMIS_SAN_DORIA_INTERLOPER,
        winQM = 17535223,
        entryPos = {161.838, -2.000, 161.673, 93, xi.zone.DYNAMIS_SAN_DORIA},
        ejectPos = {161.000, -2.000, 161.000, 94, xi.zone.SOUTHERN_SAN_DORIA},
        specifiedChildren = true,
        updatedRoam = true,
    },
    [xi.zone.SOUTHERN_SAN_DORIA] =
    {
        dynaZone = xi.zone.DYNAMIS_SAN_DORIA,
        dynaNameShort = "DynamisSan",
        dynaZoneMessageParam = 1,
    },
    [xi.zone.DYNAMIS_BASTOK] =
    {
        winVar = "DynaBastok_Win",
        dynamis_has_enteredVar = "DynaBastok_dynamis_has_entered",
        hasSeenWinCSVar = "DynaBastok_HasSeenWinCS",
        dynaNameShort = "DynamisBas",
        winKI = xi.ki.HYDRA_CORPS_EYEGLASS,
        winTitle = xi.title.DYNAMIS_BASTOK_INTERLOPER,
        winQM = 17539322,
        entryPos = {116.482, 0.994, -72.121, 128, xi.zone.DYNAMIS_BASTOK},
        ejectPos = {112.000, 0.994, -72.000, 127, xi.zone.BASTOK_MINES},
    },
    [xi.zone.BASTOK_MINES] =
    {
        dynaZone = xi.zone.DYNAMIS_BASTOK,
        dynaNameShort = "DynamisBas",
        dynaZoneMessageParam = 2,
    },
    [xi.zone.DYNAMIS_WINDURST] =
    {
        winVar = "DynaWindurst_Win",
        dynamis_has_enteredVar = "DynaWindurst_dynamis_has_entered",
        hasSeenWinCSVar = "DynaWindurst_HasSeenWinCS",
        dynaNameShort = "DynamisWin",
        winKI = xi.ki.HYDRA_CORPS_LANTERN,
        winTitle = xi.title.DYNAMIS_WINDURST_INTERLOPER,
        winQM = 17543479,
        entryPos = {-221.988, 1.000, -120.184, 0 , xi.zone.DYNAMIS_WINDURST},
        ejectPos = {-217.000, 1.000, -119.000, 94, xi.zone.WINDURST_WALLS},
    },
    [xi.zone.WINDURST_WALLS] =
    {
        dynaZone = xi.zone.DYNAMIS_WINDURST,
        dynaNameShort = "DynamisWin",
        dynaZoneMessageParam = 3,
    },
    [xi.zone.DYNAMIS_JEUNO] =
    {
        winVar = "DynaJeuno_Win",
        dynamis_has_enteredVar = "DynaJeuno_dynamis_has_entered",
        hasSeenWinCSVar = "DynaJeuno_HasSeenWinCS",
        dynaNameShort = "DynamisJeu",
        winKI = xi.ki.HYDRA_CORPS_TACTICAL_MAP,
        winTitle = xi.title.DYNAMIS_JEUNO_INTERLOPER,
        winQM = 17547509,
        entryPos = {48.930, 10.002, -71.032, 195, xi.zone.DYNAMIS_JEUNO},
        ejectPos = {48.930, 10.002, -71.032, 195, xi.zone.RULUDE_GARDENS},
        updatedRoam = true,
    },
    [xi.zone.RULUDE_GARDENS] =
    {
        dynaZone = xi.zone.DYNAMIS_JEUNO,
        dynaNameShort = "DynamisJeu",
        dynaZoneMessageParam = 4,
    },
    [xi.zone.DYNAMIS_BEAUCEDINE] =
    {
        winVar = "DynaBeaucedine_Win",
        dynamis_has_enteredVar = "DynaBeaucedine_dynamis_has_entered",
        hasSeenWinCSVar = "DynaBeaucedine_HasSeenWinCS",
        dynaNameShort = "DynamisBea",
        winKI = xi.ki.HYDRA_CORPS_INSIGNIA,
        winTitle = xi.title.DYNAMIS_BEAUCEDINE_INTERLOPER,
        winQM = 17326800,
        entryPos = {-284.751, -39.923, -422.948, 235, xi.zone.DYNAMIS_BEAUCEDINE},
        ejectPos = {-284.751, -39.923, -422.948, 235, xi.zone.BEAUCEDINE_GLACIER},
    },
    [xi.zone.BEAUCEDINE_GLACIER] =
    {
        dynaZone = xi.zone.DYNAMIS_BEAUCEDINE,
        dynaNameShort = "DynamisBea",
        dynaZoneMessageParam = 5,
    },
    [xi.zone.DYNAMIS_XARCABARD] =
    {
        winVar = "DynaXarcabard_Win",
        dynamis_has_enteredVar = "DynaXarcabard_dynamis_has_entered",
        hasSeenWinCSVar = "DynaXarcabard_HasSeenWinCS",
        dynaNameShort = "DynamisXar",
        winKI = xi.ki.HYDRA_CORPS_BATTLE_STANDARD,
        winTitle = xi.title.DYNAMIS_XARCABARD_INTERLOPER,
        winQM = 17330780,
        entryPos = {569.312, -0.098, -270.158, 90, xi.zone.DYNAMIS_XARCABARD},
        ejectPos = {569.312, -0.098, -270.158, 90, xi.zone.XARCABARD},
    },
    [xi.zone.XARCABARD] =
    {
        dynaZone = xi.zone.DYNAMIS_XARCABARD,
        dynaNameShort = "DynamisXar",
        dynaZoneMessageParam = 6,
    },
    [xi.zone.DYNAMIS_VALKURM] =
    {
        winVar = "DynaValkurm_Win",
        dynamis_has_enteredVar = "DynaValkurm_dynamis_has_entered",
        hasSeenWinCSVar = "DynaValkurm_HasSeenWinCS",
        dynaNameShort = "DynamisVal",
        winKI = xi.ki.DYNAMIS_VALKURM_SLIVER,
        winTitle = xi.title.DYNAMIS_VALKURM_INTERLOPER,
        winQM = 16937586,
        entryPos = {100, -8, 131, 47, xi.zone.DYNAMIS_VALKURM},
        ejectPos = {119, -9, 131, 52, xi.zone.VALKURM_DUNES},
    },
    [xi.zone.VALKURM_DUNES] =
    {
        dynaZone = xi.zone.DYNAMIS_VALKURM,
        dynaNameShort = "DynamisVal",
        dynaZoneMessageParam = 7,
    },
    [xi.zone.DYNAMIS_BUBURIMU] =
    {
        winVar = "DynaBuburimu_Win",
        dynamis_has_enteredVar = "DynaBuburimu_dynamis_has_entered",
        hasSeenWinCSVar = "DynaBuburimu_HasSeenWinCS",
        dynaNameShort = "DynamisBub",
        winKI = xi.ki.DYNAMIS_BUBURIMU_SLIVER,
        winTitle = xi.title.DYNAMIS_BUBURIMU_INTERLOPER,
        winQM = 16941677,
        entryPos = {155, -1, -169, 170, xi.zone.DYNAMIS_BUBURIMU},
        ejectPos = {154, -1, -170, 190, xi.zone.BUBURIMU_PENINSULA},
        sjRestrictionNPC = 16941676,
        sjRestrictionNPCNumber = 4,
        sjRestrictionLocation =
        {
            [1] = {-214.161, 15.360, -269.202, 54},
            [2] = {620.425, 7.306, -266.427, 71},
            [3] = {427.460, -0.308, 189.224, 50},
            [4] = {320.489, -0.642, 366.648, 101},
        }
    },
    [xi.zone.BUBURIMU_PENINSULA] =
    {
        dynaZone = xi.zone.DYNAMIS_BUBURIMU,
        dynaNameShort = "DynamisBub",
        dynaZoneMessageParam = 8,
    },
    [xi.zone.DYNAMIS_QUFIM] =
    {
        winVar = "DynaQufim_Win",
        dynamis_has_enteredVar = "DynaQufim_dynamis_has_entered",
        hasSeenWinCSVar = "DynaQufim_HasSeenWinCS",
        dynaNameShort = "DynamisQuf",
        winKI = xi.ki.DYNAMIS_QUFIM_SLIVER,
        winTitle = xi.title.DYNAMIS_QUFIM_INTERLOPER,
        winQM = 16945639,
        entryPos = {-19, -17, 104, 253, xi.zone.DYNAMIS_QUFIM},
        ejectPos = { 18, -19, 162, 240, xi.zone.QUFIM_ISLAND},
        sjRestrictionNPC = 16945638,
        sjRestrictionNPCNumber = 12,
        sjRestrictionLocation =
        {
            [1] = {-264.498, -19.255, 401.465, 54},
            [2] = {-264.655, -19.268, 240.580, 71},
            [3] = {-77.771, -19.068, 258.666, 50},
            [4] = {-137.127, -19.976, 228.789, 101},
            [5] = {-61.647, -19.868, 152.935, 35},
            [6] = {27.973, -20.270, 191.907, 195},
            [7] = {107.445, -20.368, 149.587, 64},
            [8] = {99.884, -19.557, 51.518, 27},
            [9] = {-29.895, -21.095, -57.154, 209},
            [10] = {88.474, -20.621, -49.333, 4},
            [11] = {-192.540, -20.477, -11.055, 151},
            [12] = {-340.976, -20.421, 31.154, 66},
        }
    },
    [xi.zone.QUFIM_ISLAND] =
    {
        dynaZone = xi.zone.DYNAMIS_QUFIM,
        dynaNameShort = "DynamisQuf",
        dynaZoneMessageParam = 9,
    },
    [xi.zone.DYNAMIS_TAVNAZIA] =
    {
        winVar = "DynaTavnazia_Win",
        dynamis_has_enteredVar = "DynaTavnazia_dynamis_has_entered",
        hasSeenWinCSVar = "DynaQufim_HasSeenWinCS",
        dynaNameShort = "DynamisTav",
        winKI = xi.ki.DYNAMIS_TAVNAZIA_SLIVER,
        winTitle = xi.title.DYNAMIS_TAVNAZIA_INTERLOPER,
        winQM = nil,
        entryPos = {0.1, -7, -21, 190, xi.zone.DYNAMIS_TAVNAZIA},
        ejectPos = {0  , -7, -23, 195, xi.zone.TAVNAZIAN_SAFEHOLD},
    },
    [xi.zone.TAVNAZIAN_SAFEHOLD] =
    {
        dynaZone = xi.zone.DYNAMIS_TAVNAZIA,
        dynaNameShort = "DynamisTav",
        dynaZoneMessageParam = 10,
    },

}

xi.dynamis.eyesEra =
{
    NONE    = 0,
    RED     = 1,
    BLUE    = 2,
    GREEN   = 3,
}

--------------------------------------------
--      onZoneTick Dynamis Functions      --
--------------------------------------------
xi.dynamis.handleDynamis = function(zone)
    if zone:GetServerVariable(string.format("[DYNA]ValidOnTick_%s", zone:getID())) == true then -- Check if dynamis should be active. This is to save resources when the zone is not in use.
        local zoneToken = zone:GetServerVariable(string.format("[DYNA]Token_%s", zone:getID()))
        local zoneExpireTime = zone:GetServerVariable(string.format("[DYNA]Timepoint_%s", zone:getID()))
        local playersInZone = zone:getPlayers()
        local playersLeftZone = zone:getLocalVar(string.format("[DYNA]_%s", zone:getID()))

        for _, player in pairs(playersInZone) do
            xi.dynamis.verifyHoldsValidHourglass(player, zoneToken, zoneExpireTime)

            if os.time() >= player:getCharVar(string.format("[DYNA]EjectPlayer_%s", zone:getID())) then
                xi.dynamis.ejectPlayer(player)
            end
        end

        if (zone:GetServerVariable(string.format("[DYNA]Given10MinuteWarning_%s", zone:getID())) == false) and (xi.dynamis.getDynaTimeRemaining(zone) < 660) then -- If now is < 11 minutes give warning.
            xi.dynamis.dynamisTimeWarning(zone) -- Send time warning.
            zone:SetServerVariable(string.format("[DYNA]Given10MinuteWarning_%s", zone:getID()), true) -- Sets to true to not give another warning.
        end

        if (zone:GetServerVariable(string.format("[DYNA]Given3MinuteWarning_%s", zone:getID())) == false) and (xi.dynamis.getDynaTimeRemaining(zone) < 240) then -- If now is < 4 minutes give warning.
            xi.dynamis.dynamisTimeWarning(zone) -- Send time warning.
            zone:SetServerVariable(string.format("[DYNA]Given3MinuteWarning_%s", zone:getID()), true) -- Sets to true to not give another warning.
        end

        if (zone:GetServerVariable(string.format("[DYNA]Given1MinuteWarning_%s", zone:getID())) == false) and (xi.dynamis.getDynaTimeRemaining(zone) < 120) then -- If now is < 4 minutes give warning.
            xi.dynamis.dynamisTimeWarning(zone) -- Send time warning.
            zone:SetServerVariable(string.format("[DYNA]Given1MinuteWarning_%s", zone:getID()), true) -- Sets to true to not give another warning.
        end

        if (zone:GetServerVariable(string.format("[DYNA]ExpireRoutine_%s", zone:getID())) == false) and (xi.dynamis.getDynaTimeRemaining(zone) < 0) then -- If now is < 0 minutes remove players and flag cleanup.
            xi.dynamis.ejectAllPlayers(zone) -- Eject players from the zone.
            zone:SetServerVariable(string.format("[DYNA]ExpireRoutine_%s", zone:getID()), os.time() + 30) -- Flags zone to start cleanup.
        end

        if zone:GetServerVariable(string.format("[DYNA]ExpireRoutine_%s", zone:getID())) ~= false then -- Zone should start cleanup.
            if zone:GetServerVariable(string.format("[DYNA]ExpireRoutine_%s", zone:getID())) <= os.time() then -- Checks to see if 30s passed between start and now.
                xi.dynamis.cleanupDynamis(zone) -- Runs cleanup function.
            end
        end

        if playersInZone == nil then
            zone:setLocalVar(string.format("[DYNA]_%s", zone:getID()), os.time + (60 * 15)) -- Give 15 minutes for zone to repopulate.
        else
            zone:setLocalVar(string.format("[DYNA]_%s", zone:getID()), os.time + (60 * 60 * 5)) -- Ignore for 5 hours or until zone empties.
        end

        if playersLeftZone <= os.time() then
            xi.dynamis.cleanupDynamis(zone)
        end
    else
        return
    end
end

--------------------------------------------
--         Dynamis Start Functions        --
--------------------------------------------

xi.dynamis.onNewDynamis = function(player)
    player:SetServerVariable(string.format("[DYNA]ValidOnTick_%s", dynaInfoEra[player:getZoneID()].dynaZone), true)
    local zone = entryInfoEra[player:getZoneID()].zoneName
    local iStart = 4096*4096+(4096*zone) -- Gets starting ID based on zoneID.
    local i = iStart -- Sets original index.
    local iEnd = iStart + 1023 -- Sets end of scope.
    
    if npcList == nil then print("npcList was nil") end -- Checks if npcList is nil.
    if npcList[zone] == nil then print("npcList[zone] was nil") end -- Checks to see if dynamis_mobs.lua npcList is nil.
    
    while i <= iEnd do

        if zones[zone].npc.NPC_Check[i] == i then -- Check if NPC is in the NPC array.
            entity = GetNPCByID(i) -- If yes then get the NPC from its ID.
        else -- Must be a Mob.
            entity = GetMobByID(i) -- Gets the Mob from its ID.
        end

        if entity ~= nil and entity:isNPC() then entity:setStatus(xi.status.DISAPPEAR) end -- Double check all NPCs are set to disappear.
        
        if entity:isMob() then -- Check if it is a mob.
            local mob = GetMobByID(i) -- Get mob entity by the ID
            mob:resetLocalVars() -- Clear localvars just in case.
            mob:setTP(0) -- Clear tp just in case.
            if mobList[zone][i].pos ~= nil then -- If mob has a valid position.
                mob:setSpawn(mobList[zone][i].pos[1],mobList[zone][i].pos[2],mobList[zone][i].pos[3],mobList[zone][i].pos[4]) -- Set spawn position for mob.
                if mobList[zone][i].waves ~= nil and mobList[zone][i].waves[1] ~= nil then -- Start spawning 1st wave. If Dreamlands handle setting SJ Restriction NPC.
                    SpawnMob(i) 
                    if dynaInfoEra[zone].csBit > 7 and dynaInfoEra[zone].sjRestrictionNPC ~= nil then -- Are we in dreamlands and there is a SJ Restriction NPC?
                        GetNPCByID(dynaInfoEra[zone].sjRestrictionNPC):setPos(dynamis.dynaInfoEra[zone].sjRestrictionLocation[math.random(1, dynamis.dynaInfoEra[zone].sjRestrictionNPCNumber)]) -- Pick a location for SJ NPC
                        GetNPCByID(dynaInfoEra[zone].sjRestrictionNPC):setStatus(xi.status.NORMAL) -- Make the NPC visible.
                    end
                end -- Spawn mob if it is wave 1.
            else mob:setSpawn(1,1,1,0) end -- If no position set to an invalid position.
            if mob:getFamily() >= 92 and mob:getFamily() <= 95 then -- If statue family.
                mob:addRoamFlag(256) -- scripted pathing only
            elseif mob:getID() == zones[zone].npc.Megaboss then -- If zone megaboss (only applicable for northlands and dreamlands)
                mob:addRoamFlag(256) -- scripted pathing only
            else -- Just covers nightmare mobs as everything else should be a statue or megaboss.
                mob:addMobMod(xi.mobMod.ROAM_DISTANCE, 5) -- Limit roam distance to 5'
                mob:addMobMod(xi.mobMod.ROAM_COOL, 5)
                mob:addMobMod(xi.mobMod.ROAM_RATE, 3)
                mob:addRoamFlag(0) -- Roam Freely
            end
        elseif npcList[zone][i] ~= nil and npcList[zone][i].spawnAtStart ~= nil then
            GetNPCByID(i):setStatus(xi.status.NORMAL)
        end
        i = i + 1
    end
end

--------------------------------------------
--         Dynamis Zone Functions         --
--------------------------------------------

xi.dynamis.clearDynaVars = function(zone) -- Just clears all variables set for the zone.
    zone:SetServerVariable(string.format("[DYNA]RegisteredPlayers_%s", zone:getID()), 0)
    zone:SetServerVariable(string.format("[DYNA]Token_%s", zone:getID()), 0)
    zone:SetServerVariable(string.format("[DYNA]Timepoint_%s", zone:getID()), 0)
    zone:SetServerVariable(string.format("[DYNA]OriginalRegistrant_%s", zone:getID()), 0)
    zone:SetServerVariable(string.format("[DYNA]CurrencyAutoDistribute_%s", zone:getID()), true)
    zone:SetServerVariable(string.format("[DYNA]Given10MinuteWarning_%s", zone:getID()), false)
    zone:SetServerVariable(string.format("[DYNA]Given3MinuteWarning_%s", zone:getID()), false)
    zone:SetServerVariable(string.format("[DYNA]Given1MinuteWarning_%s", zone:getID()), false)
    zone:SetServerVariable(string.format("[DYNA]ExpireRoutine_%s", zone:getID()), false)
    zone:SetServerVariable(string.format("[DYNA]ValidOnTick_%s", zone:getID()), false)
end

xi.dynamis.addTimetoDynamis = function(zone, extensionTime, msg)
    local prevExpire = zone:GetServerVariable(string.format("[DYNA]Timepoint_%s", zone:getID())) -- Determine previous expiration time.
    local expirationTime = prevExpire + (60 * extensionTime) -- Add more time to increase previous expiration point.
    playersInZone = zone:getPlayers()
    for _, player in pairs(playersInZone) do
        player:messageSpecial(zones[zone].text.DYNAMIS_TIME_EXTEND, extensionTime) -- Send extension time message.
        xi.dynamis.updateHourglass(player) -- Runs hourglass update function per player.
    end
    zone:SetServerVariable(string.format("[DYNA]Timepoint_%s", zone:getID()), (60 * expirationTime))

    local timeRemaining = xi.dynamis.getDynaTimeRemaining(zone) -- Gets the time remaining in seconds.
    if timeRemaining > 660 then -- Checks if time remaining > 11 minutes.
        zone:SetServerVariable(string.format("[DYNA]Given10MinuteWarning_%s", zone:getID()), false) -- Resets var if time remaining greater than threshold.
    end

    if timeRemaining > 240 then -- Checks if time remaining > 4 minutes.
        zone:SetServerVariable(string.format("[DYNA]Given3MinuteWarning_%s", zone:getID()), false) -- Resets var if time remaining greater than threshold.
    end

    if timeRemaining > 120 then -- Checks if time remaining > 2 minutes.
        zone:SetServerVariable(string.format("[DYNA]Given1MinuteWarning_%s", zone:getID()), false) -- Resets var if time remaining greater than threshold.
    end
end

xi.dynamis.ejectAllPlayers = function(zone)
    playersInZone = zone:getPlayers()
    for _, player in pairs(playersInZone) do
        xi.dynamis.ejectPlayer(player) -- Runs the ejectPlayer function per player.
    end
end

xi.dynamis.getDynaTimeRemaining = function(zone)
    local dynaTimeRemaining = (zone:GetServerVariable(string.format("[DYNA]Timepoint_%s", zone:getID())) - os.time()) -- Checks difference between the expiry timepoint and now.
    return dynaTimeRemaining -- Returns difference.
end

xi.dynamis.cleanupDynamis = function(zone)
    xi.dynamis.ejectAllPlayers(zone) -- Remove Players (This is precautionary but not necessary.)
    xi.dynamis.clearDynaVars(zone) -- Reset Variables
    
    -- Cleanup Zone
    local iStart = 4096*4096+(4096*zone:getID()) -- Grab start of ID range
    local i = iStart -- Set first ID
    local iEnd = iStart + 1023 -- Find end of ID range.
    local entity = nil
    
    while i <= iEnd do -- While IDs are valid do the following.
        if zones[zone:getID()].npc.NPC_Check[i] == i then -- Check if NPC is in the NPC array.
            entity = GetNPCByID(i) -- If yes then get the NPC from its ID.
        else -- Must be a Mob.
            entity = GetMobByID(i) -- Gets the Mob from its ID.
        end

        if entity ~= nil then
            if entity:isMob() then -- Double check if it is a mob.
                DespawnMob(i) -- Despawn if true.
            elseif entity:isNPC() then -- Double check if it is a NPC.
                entity:setStatus(xi.status.DISAPPEAR) -- Set it to disappear if true.
            end
        end
        i = i + 1 -- Increment by 1 ID.
    end
end

xi.dynamis.dynamisTimeWarning = function(zone)
    local playersInZone = zone:getPlayers()
    local timeRemaining = math.floor((xi.dynamis.getDynaTimeRemaining(zone) / 60)) -- Get time remaining, convert to minutes, floor value.
    for _, player in pairs(playersInZone) do
        if timeRemaining <= 2 then
            player:messageSpecial(zones[zone].text.DYNAMIS_TIME_UPDATE_1, timeRemaining, 1) -- Send 1 minute warning.
        else
            player:messageSpecial(zones[zone].text.DYNAMIS_TIME_UPDATE_2, timeRemaining, 1) -- Send [3/10] minutes warning.
        end
    end
end

--------------------------------------------
--        Dynamis Player Functions        --
--------------------------------------------
xi.dynamis.registerDynamis = function(player)
    xi.dynamis.setDynanamisToken(player) -- Generate token.
    xi.dynamis.setOriginalExpiryTimepoint(player) -- Create original expiry timepoint.
    xi.dynamis.onNewDynamis(player) -- Start spawning wave 1.

    while player:hasItem(dynamis_timeless) do -- Check for instances of timeless, players should only be able to carry one at a time.
        player:delItem(dynamis_timeless) -- Deletes timeless hourglass.
    end

    if player:GetServerVariable(string.format("[DYNA]Token_%s", dynaInfoEra[player:getZoneID()].dynaZone)) ~= 0 then
        local dynamisToken = player:GetServerVariable(string.format("[DYNA]Token_%s", dynaInfoEra[player:getZoneID()].dynaZone))
        local hourglassInitial = string.format("%s : %s", dynaInfoEra[player:getZoneID()].dynaNameShort, dynamisToken)
        player:addItem({id=dynamis_perpetual, signature=hourglassInitial}) -- Add a perpetual hourglass with token signature.
        player:messageSpecial(zones[player:getZoneID()].text.INFORMATION_RECORDED, dynamis_perpetual)
        player:messageSpecial(zones[player:getZoneID()].text.ITEM_OBTAINED, dynamis_perpetual)
    end
end

xi.dynamis.setDynanamisToken = function(player)
    zone:SetServerVariable(string.format("[DYNA]Token_%s", dynaInfoEra[player:getZoneID()].dynaZone), ((dynaInfoEra[player:getZoneID()].dynaZone * math.random(1,100)) + (zone:getID() * math.random(1, 50)))) -- Pseudo random function to generate unique token.
end

xi.dynamis.setOriginalExpiryTimepoint = function(player)
    expirationTime = os.time() + (60 * (60 + dynamis_staging_time)) -- Amount of time to extend timepoint by. 60 minutes by default for fresh zones.
    player:SetServerVariable(string.format("[DYNA]Timepoint_%s", dynaInfoEra[player:getZoneID()].dynaZone, expirationTime)) -- Sets timepoint which dynamis will expire.
end

xi.dynamis.registerPlayer = function(player)
    player:setCharVar(string.format("[DYNA]PlayerRegistered_%s", (dynaInfoEra[player:getZoneID()].dynaZone), player:GetServerVariable(string.format("[DYNA]Token_%s", dynaInfoEra[player:getZoneID()].dynaZone)) + player:getZoneID())) -- Obfuscate player registration value with dynamis token + player's zone ID info. (Ensures the player is counted as new registrant if token is different.)
    player:setCharVar(string.format("[DYNA]PlayerZoneToken_%s", dynaInfoEra[player:getZoneID()].dynaZone), player:GetServerVariable(string.format("[DYNA]Token_%s", dynaInfoEra[player:getZoneID()].dynaZone))) -- Give the player a copy of the token value.
end

xi.dynamis.isPlayerRegistered = function(player)
    local registerID = player:getCharVar(string.format("[DYNA]PlayerRegistered_%s", (dynaInfoEra[player:getZoneID()].dynaZone))) -- Get player's registered ID.
    local dynamisToken = player:GetServerVariable(string.format("[DYNA]Token_%s", dynaInfoEra[player:getZoneID()].dynaZone)) -- Get a copy of the dynamis token.

    if (registerID - dynamisToken) == player:getZoneID() then -- If the remainder is the player's zoneID then they are already registered.
        return true -- Treat as previous registrant.
    else
        return false -- Treat as new registrant.
    end
end

xi.dynamis.ejectPlayer = function(player)
    if player:getCurrentRegion() == xi.region.DYNAMIS then
        player:timer(1000, function(player) player:messageSpecial(zones[player:getZoneID()].text.NO_LONGER_HAVE_CLEARANCE, 0, 30) end) -- Wait 1 second, send no clearance message.
        player:setCharVar(string.format("[DYNA]PlayerRegistered_%s", dynaInfoEra[player:getZoneID()].dynaZone), 0) -- Reset player's registered status.
        player:setCharVar(string.format("[DYNA]PlayerZoneToken_%s", dynaInfoEra[player:getZoneID()].dynaZone), 0) -- Reset player's token.
        player:setCharVar(string.format("[DYNA]EjectPlayer_%s", zone:getID()), -1) -- Reset player's eject timer.
        player:disengage() -- Force disengage.
        player:timer(2000, function(player) player:startCutscene(100) end) -- Wait 2 seconds then play exit CS.
    end
end

xi.dynamis.updateHourglass = function(player)
    local zone = player:getZone()
    local newExpire = 0

    if zone:getType() == xi.zoneType.DYNAMIS then -- Check if they are in a dynamis zone. This determines the parameters for retrieving timepoint.
        newExpire = zone:GetServerVariable(string.format("[DYNA]Timepoint_%s", zone:getID())) -- Get timepoint.
    else
        newExpire = zone:GetServerVariable(string.format("[DYNA]Timepoint_%s", dynaInfoEra[zone:getID()].dynaZone)) -- Get timepoint.
    end

    local hourglassNew = string.format("%s : %s. %s, %s, %s:%s:%s%s", dynaInfoEra[player:getZoneID()].dynaNameShort, os.date("%b", newExpire), os.date("%d", 
                                            newExpire), os.date("%Y", newExpire), os.date("%I", newExpire), os.date("%M", newExpire), 
                                            os.date("%S", newExpire), os.date("%p", newExpire)) -- New Hourglass String Ex. DynamisSan : Jan. 01, 2001, 1:11:11pm
    local numHourglass = 0

    while player:hasItem(dynamis_perpetual) == true do
        player:delItem(dynamis_perpetual) -- Delete old hourglass.
        numHourglass = numHourglass + 1 -- Keep track of the number of hourglasses removed.
    end

    while numHourglass > 0 do -- Replace all hourglasses removed.
        player:addItem({id=dynamis_perpetual, signature=hourglassNew}) -- Add a new hourglass with new signature.
        numHourglass = numHourglass - 1 -- Keep track of the number of hourglasses given.
    end
end

xi.dynamis.verifyHoldsValidHourglass = function(player, zoneToken, zoneExpireTime)
    
    -- Nil functions are used to reduce the number of db requests. Ideally the function is provided zoneToken and zoneExpireTime
    if zoneToken == nil then -- If missing then look for it.
        zoneToken = player:GetServerVariable(string.format("[DYNA]Token_%s", player:getZoneID()))
    end

    if zoneExpireTime == nil then -- If missing then look for it.
        zoneExpireTime = player:GetServerVariable(string.format("[DYNA]Timepoint_%s", player:getZoneID()))
    end

    if player:getGMLevel() < 2 then -- Check if player is a GM.
        if (player:hasItem(dynamis_perpetual) == false) and (player:getCharVar(string.format("[DYNA]PlayerZoneToken_%s", player:getZoneID())) == zoneToken) then
            player:setCharVar(string.format("[DYNA]EjectPlayer_%s", player:getZoneID()), (os.time() + 30)) -- If player has no hourglass but is in the correct dynamis.
        elseif (player:hasItem(dynamis_perpetual) == false) then
            player:setCharVar(string.format("[DYNA]EjectPlayer_%s", player:getZoneID()), (os.time() + 0)) -- If player does not have hourglass and isn't in the correct dynamis.
        elseif (player:hasItem(dynamis_perpetual) == true) and (player:getCharVar(string.format("[DYNA]PlayerZoneToken_%s", player:getZoneID())) ~= zoneToken) then
            player:setCharVar(string.format("[DYNA]EjectPlayer_%s", player:getZoneID()), (os.time() + 0)) -- If player has an hourglass but isn't in the correct dynamis.
        elseif (player:hasItem(dynamis_perpetual) == true) and (player:getCharVar(string.format("[DYNA]PlayerZoneToken_%s", player:getZoneID())) == zoneToken) then
            player:setCharVar(string.format("[DYNA]EjectPlayer_%s", player:getZoneID()), zoneExpireTime) -- If player has an hourglass and is in the correct dynamis.
        else
            player:setCharVar(string.format("[DYNA]EjectPlayer_%s", player:getZoneID()), (os.time() + 0)) -- Fail closed and force eject player.
        end
    end
end

xi.dynamis.verifyTradeHourglass = function(player, trade)
    local dynamisToken = player:GetServerVariable(string.format("[DYNA]Token_%s", dynaInfoEra[player:getZoneID()].dynaZone))
    local expireTime = player:GetServerVariable(string.format("[DYNA]Timepoint_%s", dynaInfoEra[player:getZoneID()].dynaZone))
    local hourglassInfo = string.format("%s : %s. %s, %s, %s:%s:%s%s", dynaInfoEra[player:getZoneID()].dynaNameShort, os.date("%b", expireTime), os.date("%d", 
                                            expireTime), os.date("%Y", expireTime), os.date("%I", expireTime), os.date("%M", expireTime), 
                                            os.date("%S", expireTime), os.date("%p", expireTime)) -- New Hourglass String Ex. DynamisSan : Jan. 01, 2001, 1:11:11pm
    if trade:getItem(0):getSignature() == string.format("%s : %s", dynaInfoEra[player:getZoneID()].dynaNameShort, dynamisToken) then -- If signature doesn't have time then new hourglass.
        return 1 -- New hourglass.
    elseif trade:getItem(0):getSignature() == hourglassInfo then
        return 2 -- Current hourglass.
    else
        return 3 -- Not valid.
    end
end

m:addoverRide("xi.dynamis.onEventFinish", function(player, csid, option)
    if csid == 100 then -- Dynamis exit cutscene. 
        local info = dynaInfoEra[player:getZoneID()] -- Pull dynaInfo
        player:setPos(unpack(info.ejectPos)) -- Set position to the eject position.
    end
end)

--------------------------------------------
--       Dynamis Entry NPC Functions      --
--------------------------------------------

xi.dynamis.entryNpcOnTrade = function(player, npc, trade)
    local zoneID = npc:getZoneID()
    if entryInfoEra[zoneID].enabled == false then return end -- If zone is not enabled, return.
    if (player:getLocalVar(entryInfoEra[zoneID].dynamis_has_enteredVar) == 0) then -- Check if player has entered the Dynamis before.
    if (entryInfoEra[zoneID].reqs == false) then return end end -- Check if player meets all requirements or is a GM.


    local dynamis_time_remaining = (npc:GetServerVariable(string.format("[DYNA]Timepoint_%s", entryInfoEra[zoneID].enterPos[5])) - os.time())
    local dynamis_has_entered = player:getCharVar(entryInfoEra[zoneID].dynamis_has_enteredVar)
    local dynamis_last_reservation = (os.time() / 3600) - player:getCharVar("DynaReservationStart") -- Return Time of Last Reservation in Hours

    if npcUtil.tradeHas(trade, dynamis_timeless, true, false) then -- Check for timeless hourglass to trade for perpetual hourglass to start instance
        if dynamis_time_remaining > 0 then -- Check if another group is present.
            player:messageSpecial(zones[player:getZoneID()].text.ANOTHER_GROUP, entryInfoEra[zoneID].csBit)
        elseif player:getGMLevel() > 1 then -- If no other group, if GM bypass lockout and start new dynamis.
            player:starCutscene(entryInfoEra[zoneID].csRegisterGlass, entryInfoEra[zoneID].csBit, dynamis_has_entered == 1 and 0 or 1, dynamis_reservation_cancel, dynamis_reentry_days, entryInfoEra[zoneID].maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamis_timeless,dynamis_perpetual)
        elseif dynamis_last_reservation < dynamis_rentry_hours then -- Still in lockout period.
            player:messageSpecial(zones[player:getZoneID()].text.YOU_CANNOT_ENTER_DYNAMIS, math.ceil(dynamis_rentry_hours - dynamis_last_reservation), entryInfoEra[zoneID].csBit)
        else -- Proceed in starting new dynamis.
            player:starCutscene(entryInfoEra[zoneID].csRegisterGlass, entryInfoEra[zoneID].csBit, dynamis_has_entered == 1 and 0 or 1, dynamis_reservation_cancel, dynamis_reentry_days, entryInfoEra[zoneID].maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamis_timeless,dynamis_perpetual)
        end
    elseif npcUtil.tradeHas(trade, dynamis_perpetual, true, false) then -- Check for perpetual hourglass to  enter instance
        local dynamis_glass_valid = xi.dynamis.verifyTradeHourglass(player, trade)
        local isPlayerRegistered = xi.dynamis.isPlayerRegistered(player)
        local dynaCapacity = player:GetServerVariable(string.format("[DYNA]RegisteredPlayers_%s", entryInfoEra[zoneID].enterPos[5]))
        if dynamis_glass_valid < 3 then -- 1 = New Registrant, 2 = Re-entering, 3 = Not Valid
            if player:getGMLevel() > 1 then -- Don't register GMs.
                player:starCutscene(entryInfoEra[zoneID].csDyna, entryInfoEra[zoneID].csBit, dynamis_has_entered == 1 and 0 or 1, dynamis_reservation_cancel, dynamis_reentry_days, entryInfoEra[zoneID].maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamis_timeless, dynamis_perpetual)
            elseif dynamis_last_reservation < dynamis_rentry_hours then -- If in lockout, deny.
                player:messageSpecial(zones[player:getZoneID()].text.YOU_CANNOT_ENTER_DYNAMIS, (dynamis_rentry_hours - dynamis_last_reservation), entryInfoEra[zoneID].csBit)
            elseif isPlayerRegistered == true then -- Allow previous registrant into the zone.
                player:starCutscene(entryInfoEra[zoneID].csDyna, entryInfoEra[zoneID].csBit, dynamis_has_entered == 1 and 0 or 1, dynamis_reservation_cancel, dynamis_reentry_days, entryInfoEra[zoneID].maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamis_timeless, dynamis_perpetual)
                player:setCharVar(string.format("[DYNA]InflictWeakness_%s", entryInfoEra[zoneID].enterPos[5]), true) -- Tell dynamis to inflict weakness.
            elseif isPlayerRegistered == false then -- Initiate new registrant procedure.
                if dynaCapacity < entryInfoEra[player:getZoneID()].maxCapacity then -- If not at max capacity, allow in.
                    player:starCutscene(entryInfoEra[zoneID].csDyna, entryInfoEra[zoneID].csBit, dynamis_has_entered == 1 and 0 or 1, dynamis_reservation_cancel, dynamis_reentry_days, entryInfoEra[zoneID].maxCapacity, xi.ki.VIAL_OF_SHROUDED_SAND, dynamis_timeless, dynamis_perpetual)
                    player:setCharVar(string.format("[DYNA]InflictWeakness_%s", entryInfoEra[zoneID].enterPos[5]), false) -- Tell dynamis to not inflict weakness.
                    player:SetServerVariable(string.format("[DYNA]RegisteredPlayers_%s", entryInfoEra[zoneID].enterPos[5]), dynaCapacity + 1) -- Increment registered players by 1.
                else
                    player:PrintToPlayer("The Dynamis instance has reached its maximum capacity of".. entryInfoEra[zoneID].maxCapacity .. "registrants.", 29) -- Let player know max registration has taken place.
                end
            end
        else
            if dynamis_time_remaining > 0 then
                player:messageSpecial(zones[player:getZoneID()].text.ANOTHER_GROUP, entryInfoEra[zoneID].csBit) -- There is another group in dynamis.
            else
                player:PrintToPlayer("The Perpetual Hourglass' time has run out.", 29) -- Something is invalid, fail to time has run out.
            end
        end
    end
end

m:addOverride("xi.dynamis.entryNpcOnTrigger", function(player, npc)
    local zoneID = player:getZoneID()
    if entryInfoEra[zoneID].enabled == false then -- If not enabled give default message.
        player:messageSpecial(zones[player:getZoneID()].text.DYNA_NPC_DEFAULT_MESSAGE)
        return
    end
    if entryInfoEra[zoneID].csSand ~= nil and player:getCharVar("HasSeenXarcabardDynamisCS") == 1 and player:hasKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND) == false then -- If player does not have sand, start CS to give sand.
        player:starCutscene(entryInfoEra[zoneID].csSand)
    elseif entryInfoEra[zoneID].csWin ~= nil and player:hasKeyItem(entryInfoEra[zoneID].winKI) and player:getCharVar(entryInfoEra[zoneID].hasSeenWinCSVar) == 0 then -- If player hasn't seen win CS play win CS.
        player:starCutscene(entryInfoEra[zoneID].csWin)
    else
        player:messageSpecial(zones[player:getZoneID()].text.DYNA_NPC_DEFAULT_MESSAGE) -- Just play default message otherwise.
    end
end)

xi.dynamis.entryNpcOnEventUpdate = function(player, csid, option)
    local zoneID = player:getZoneID()
    if entryInfoEra[zoneID].enabled == false then return end -- If not enabled return.
    if csid == entryInfoEra[zoneID].csRegisterGlass then -- If dynamis register glass cs.
        if option == 0 then -- If completes the cutscene.
            xi.dynamis.registerDynamis(player) -- Trigger the generation of a token, timepoint, and start spawning wave 1.
        else
            player:release() -- Failed to complete CS.
            player:messageSpecial(zones[player:getZoneID()].text.UNABLE_TO_CONNECT)
        end
    end
end

m:addOverride("xi.dynamis.entryNpcOnEventFinish", function(player, csid, option)
    local zoneID = player:getZoneID()
    if entryInfoEra[zoneID].enabled == false then return end
    if csid == entryInfoEra[zoneID].csDyna then -- enter dynamis
        if option == 0 then
            local entryPos = entryInfoEra[zoneID].enterPos
            if entryPos == nil then return end -- If entryPos isn't there, don't teleport.
            player:setCharVar(entryInfoEra[zoneID].dynamis_has_enteredVar, 1) -- Mark the player as having entered at least once.
            player:messageSpecial(zones[player:getZoneID()].text.CONNECTING_WITH_THE_SERVER) -- Just to mimic what we have previously had.
            player:timer(3000, function (player) player:setPos(entryPos[1], entryPos[2], entryPos[3], entryPos[4], entryPos[5]) end) -- Do the teleport.
        end
    elseif csid == entryInfoEra[zoneID].csSand then -- Give Shrouded Sand KI
        npcUtil.giveKeyItem(player, xi.ki.VIAL_OF_SHROUDED_SAND)
    elseif csid == entryInfoEra[zoneID].csWin then -- Seen Win CS
        player:setCharVar(entryInfoEra[zoneID].hasSeenWinCSVar, 1)
    end
end)

--------------------------------------------
--      Dynamis Player/Zone Functions     --
--------------------------------------------

m:addOverride("xi.dynamis.zoneOnZoneIn", function(player, prevZone)
    local zone = player:getZone()
    local zoneId = player:getZoneID()
    local info = dynaInfoEra[zoneId]
    local ID = zones[zoneId]

    -- usually happens when zoning in with !zone command
    if player:getXPos() == 0 and player:getYPos() == 0 and player:getZPos() == 0 then player:setPos(info.entryPos[1], info.entryPos[2], info.entryPos[3], info.entryPos[4]) end -- If player is in void, move player to entry.

    if xi.dynamis.verifyHoldsValidHourglass(player) == true then -- Check if player has an hourglass and their personal token matches the zone token.
        xi.dynamis.updateHourglass(player) -- Proceed in swapping out the hourglass the player has.
        player:timer(1000, function(player)
            player:messageSpecial(ID.text.DYNAMIS_TIME_UPDATE_2, math.floor(player:getDynaTimeRemaining(player:getZone()) / 60), 1) -- Send message letting player know how long they have.
        end)

        if player:getCharVar(string.format("[DYNA]InflictWeakness_%s", player:getZoneID())) == true then -- Should I inflict weakness?
            player:addStatusEffect(xi.effect.WEAKNESS, 1, 3, 60 * 10) -- Inflict weakness.
            player:setCharVar(string.format("[DYNA]InflictWeakness_%s", player:getZoneID()), false) -- Reset var.
        end

        if dynamis.dynaInfoEra[zoneId].csBit >= 7 then  -- Is this dreamlands?
            if os.time() > player:getCharVar(string.format("[DYNA]SJUnlock_%s", player:getZoneID())) then -- Should the player be allowed to keep subjob?
                player:addStatusEffect(xi.effect.SJ_RESTRICTION, 1, 3, 0) -- Inflict SJ Restriction
            end
        end

    end

    return -1
end)

--------------------------------------------
--         Dynamis Mob Functions          --
--------------------------------------------

xi.dynamis.spawnWave = function(mobList, waveNumber)
    local zoneId = zone:getID()
    local iStart = 4096*4096+(4096*mobList.zoneID) -- Start of index.
    local i = iStart -- Curent index.
    local iEnd = iStart + 1023 -- End of index.

    while i <= iEnd do -- While index is less than or equal to the final index.
        if mobList[i].waves ~= nil and mobList[i].waves[waveNumber] ~= nil and GetMobByID(i):isSpawned() == false then SpawnMob(i) end -- If mob for this wave is not spawned, then spawn.
        i = i + 1 -- Increment up.
    end

end

xi.dynamis.statueOnSpawn = function(mob, eyes) -- Used to spawn mobs off of a single parent
    mob:setLocalVar("dynaReadyToSpawnChildren", 1) -- Marks mob available for spawning.
    if mob:getFamily() >= 92 and mob:getFamily() <= 95 then -- If statue
        mob:setLocalVar("eyeColor", eyes) -- Set Eyes if need be
        if eyes >= 2 then -- If HP or MP restore statue
            mob:setUnkillable(true) -- Set Unkillable as we will use skills then kill.
        end
    end
end

xi.dynamis.statueOnEngaged = function(mob, target, mobList)
    if mob:getFamily() >= 92 and mob:getFamily() <= 95 then -- If statue
        local eyes = mob:getLocalVar("eyeColor") -- Do we have eyes?
        mob:AnimationSub(eyes) -- Make the eyes glow
    end

    if mob:getLocalVar("dynaReadyToSpawnChildren") == 0 then return end -- If I can't spawn children return.
    mob:setLocalVar("dynaReadyToSpawnChildren", 0) -- Reset var.

    local mobID = mob:getID()
    specificChildrenList = mobList[mobID].specificChildren -- Look at my specific children list.
    local forceLink = false -- Make all my children link.
    local i = 1 -- Current index.
    while specificChildrenList ~= nil and specificChildrenList[i] ~= nil do -- As long as children list exists.
        if type(specificChildrenList[i]) == "boolean" then forceLink = specificChildrenList[i] -- Check if forcelink is true
        else
            local child = GetMobByID(specificChildrenList[i]) -- Get Mob from Child ID
            if mobList[specificChildrenList[i]].pos == nil then child:setSpawn(mob:getXPos()+math.random()*6-3, mob:getYPos()-0.3, mob:getZPos()+math.random()*6-3, mob:getRotPos()) end -- Find a random spot around parent.
            SpawnMob(specificChildrenList[i]) -- Spawn child.
            if forceLink == true then child:updateEnmity(target) end -- If forcelink was true then make child aggro whatever parent has enmity on.
        end
        i = i + 1 -- Increment up.
    end
end

xi.dynamis.statueOnFight = function(mob, target)
    if mob:getHP() == 1 then -- If my HP = 1
        if mob:AnimationSub() == 2 then -- I am an HP statue
            mob:useMobAbility(1124) -- Use Recover HP
        elseif mob:AnimationSub() == 3 then -- I am an MP statue
            mob:useMobAbility(1125) -- Use Recover MP
        end
    end
end

xi.dynamis.onStatueSkillFinished = function(mob, skill)
    if skill:getID() == 1124 or skill:getID() == 1125 then -- If I used one of the restore skills.
        mob:setUnkillable(false) -- Make me killable
        mob:setHP(0) -- Kill me
    end
end

xi.dynamis.mobOnRoamAction = function(mob)
    local zoneId = mob:getZoneID()
    if dynamis.dynaInfo[zoneId].updatedRoam == true then -- Are we using the updated roam function?
        local home = mob:getSpawnPos()
        local location = mob:getPos()
        if location.x == home.x and location.y == home.y and location.z == home.z and location.rot == home.rot then
            mob:setPos(location.x, location.y, location.z, home.rot)
        else
            mob:pathTo(home.x, home.y, home.z)
        end
    else
        local home = mob:getSpawnPos()
        local location = mob:getPos()
        mob:pathTo(home.x, home.y, home.z)
        if location.x == home.x and location.y == home.y and location.z == home.z and location.rot ~= home.rot then
            mob:setPos(location.x, location.y, location.z, home.rot)
        end
    end
end

m:addOverride("xi.dynamis.megaBossOnDeath", function(mob, player, isKiller) 
    local zone = mob:getZoneID()
    local ID = zones[zone]
    if mob:getLocalVar("GaveTimeExtension") ~= 1 then -- Ensure we don't give more than 1 time extension.
        xi.dynamis.mobOnDeath(mob, mobList[zone], ID.text.DYNAMIS_TIME_EXTEND) -- Process time extension and wave spawning
        mob:setLocalVar("GaveTimeExtension", 1)
    end
    local winQM = GetNPCByID(dynaInfoEra[ID].winQM) -- Set winQM
    local pos = mob:getPos()
    winQM:setPos(pos.x,pos.y,pos.z,pos.rot) -- Set winQM to death pos
    winQM:setStatus(xi.status.NORMAL) -- Make visible
    player:addTitle(dynaInfoEra[ID].winTitle) -- Give player the title
end)

xi.dynamis.mobOnRoamAction = function(mob) -- Handle statue pathing.
    local zoneId = mob:getZoneID()
    if dynamis.dynaInfoEra[zoneId].updatedRoam == true then
        local home = mob:getSpawnPos()
        local location = mob:getPos()
        if location.x == home.x and location.y == home.y and location.z == home.z and location.rot == home.rot then
            mob:setPos(location.x, location.y, location.z, home.rot)
        else
            mob:pathTo(home.x, home.y, home.z)
        end
    else
        local home = mob:getSpawnPos()
        local location = mob:getPos()
        mob:pathTo(home.x, home.y, home.z)
        if location.x == home.x and location.y == home.y and location.z == home.z and location.rot ~= home.rot then
            mob:setPos(location.x, location.y, location.z, home.rot)
        end
    end
end

xi.dynamis.mobOnDeath = function (mob, mobList, msg)
    if mob:getLocalVar("dynamisMobOnDeathTriggered") == 1 then return end
    mob:setLocalVar("dynamisMobOnDeathTriggered", 1) -- onDeath lua happens once per party member that killed the mob, but we want this to only run once per mob

    local mobID = mob:getID()
    if mobID ~= nil and mobList[mobID].timeExtension ~= nil then mob:addTimeToDynamis(mob:getZone(), mobList[mobID].timeExtension, msg) end
    if mob:getLocalVar("clearSpawnPosOnDeath") == 1 then mob:setSpawn(1,1,1,0) end

    local i = 2
    local j = 1
    local mobFound = false
    while mobList.waveDefeatRequirements[i] ~= nil and mobFound == false do
        while mobList.waveDefeatRequirements[i][j] ~= nil do
            if mobList.waveDefeatRequirements[i][j] == mobID then
                mobFound = true
                i = i - 1
                break
            end
            j = j + 1
        end
        j = 1
        i = i + 1
    end

    if mobFound == true then
        -- print(string.format("mob's defeat is a requirement for wave number %u",i))
        mob:setLocalVar("dynaIsDefeatedForWaveReq", 1)
        local allReqsMet = true
        while mobList.waveDefeatRequirements[i][j] ~= nil do
            if GetMobByID(mobList.waveDefeatRequirements[i][j]):getLocalVar("dynaIsDefeatedForWaveReq") == 0 then
                allReqsMet = false
                break
            end
            j = j + 1
        end
        if allReqsMet == true then dynamis.spawnWave(mobList, i) end
    end
end

xi.dynamis.mobOnRoam = function(mob) end

m:addOverride("xi.dynamis.qmOnTrigger", function(player, npc) -- Override standard qmOnTrigger()
    local zoneId = npc:getZoneID()
    if dynamis_win_aoe == true then -- Used to bypass normal KI mechanic which was causing issues on Topaz.
        local currTime = os.time()
        if npc:getLocalVar("lastActivation") + 5 > currTime then return end
        npc:setLocalVar("lastActivation", currTime)
        
        local nearbyPlayers = npc:getPlayersInRange(50)
        if nearbyPlayers == nil then return end -- If no players, ignore.
        local ID = zones[zoneId]
        
        for _,v in ipairs(nearbyPlayers) do -- Loop to do KI hand-outs
            if v:hasKeyItem(dynaInfoEra[zoneId].winKI) == false then
                v:addKeyItem(dynaInfoEra[zoneId].winKI)
                v:messageSpecial(ID.text.KEYITEM_OBTAINED, dynaInfoEra[zoneId].winKI)
            end
        end
    else -- Normal QM behavior
        player:addKeyItem(dynaInfoEra[zoneId].winKI)
        player:messageSpecial(ID.text.KEYITEM_OBTAINED, dynaInfoEra[zoneId].winKI)
    end
end)

xi.dynamis.sjQMOnTrigger = function(player, npc)
    local zoneId = npc:getZoneID()

    if dynamis.dynaInfoEra[zoneId].sjRestriction == true then -- Check to see if SJ Restriction exists
        zone = npc:getZone()
        local playersInZone = zone:getPlayers()
        for _, player in pairs(playersInZone) do
            if player:getZoneID() == player:getZoneID() and player:hasStatusEffect(xi.effect.SJ_RESTRICTION) == true then -- Does player have SJ restriction?
                if player:hasStatusEffect(xi.effect.RERAISE) then -- Check for reraise and store values.
                    player:setLocalVar("had_reraise", 1)
                    player:setLocalVar("reraise_power", player:getStatusEffect(xi.effect.RERAISE):getPower())
                    player:setLocalVar("reraise_duration", player:getStatusEffect(xi.effect.RERAISE):getDuration())
                end
                player:delStatusEffect(xi.effect.SJ_RESTRICTION) -- Remove SJ restriction
                player:setCharVar(string.format("[DYNA]SJUnlock_%s", player:getZoneID()), os.time() + 14400) -- Set Immune to reobtaining SJ_Restriction for 4 hours.
                if player:getLocalVar("had_reraise") == 1 and player:hasStatusEffect(xi.effect.RERAISE) == false then -- Reapply previous reraise if lost.
                        player:addStatusEffect(xi.effect.RERAISE, player:getLocalVar("reraise_power"), 0, player:getLocalVar("reraise_duration"))
                end
            end
        end
    end
end

xi.dynamis.setMobStats = function(mob)
    local job = mob:getMainJob()

    local familyEES =
    {
        [  3] = xi.jsa.EES_AERN,    -- Aern
        [ 25] = xi.jsa.EES_ANTICA,  -- Antica
        [115] = xi.jsa.EES_SHADE,   -- Fomor
        [126] = xi.jsa.EES_GIGA,    -- Gigas
        [127] = xi.jsa.EES_GIGA,    -- Gigas
        [128] = xi.jsa.EES_GIGA,    -- Gigas
        [129] = xi.jsa.EES_GIGA,    -- Gigas
        [130] = xi.jsa.EES_GIGA,    -- Gigas
        [133] = xi.jsa.EES_GOBLIN,  -- Goblin
        [169] = xi.jsa.EES_KINDRED, -- Kindred
        [171] = xi.jsa.EES_LAMIA,   -- Lamiae
        [182] = xi.jsa.EES_MERROW,  -- Merrow
        [184] = xi.jsa.EES_GOBLIN,  -- Moblin
        [189] = xi.jsa.EES_ORC,     -- Orc
        [200] = xi.jsa.EES_QUADAV,  -- Quadav
        [201] = xi.jsa.EES_QUADAV,  -- Quadav
        [202] = xi.jsa.EES_QUADAV,  -- Quadav
        [221] = xi.jsa.EES_SHADE,   -- Shadow
        [222] = xi.jsa.EES_SHADE,   -- Shadow
        [223] = xi.jsa.EES_SHADE,   -- Shadow
        [246] = xi.jsa.EES_TROLL,   -- Troll
        [270] = xi.jsa.EES_YAGUDO,  -- Yagudo
        [327] = xi.jsa.EES_GOBLIN,  -- Goblin
        [328] = xi.jsa.EES_GIGA,    -- Gigas
        [334] = xi.jsa.EES_ORC,     -- OrcNM
        [335] = xi.jsa.EES_MAAT,    -- Maat
        [337] = xi.jsa.EES_QUADAV,  -- QuadavNM
        [358] = xi.jsa.EES_KINDRED, -- Kindred
        [359] = xi.jsa.EES_SHADE,   -- Fomor
        [360] = xi.jsa.EES_YAGUDO,  -- YagudoNM
        [373] = xi.jsa.EES_GOBLIN,  -- Goblin_Armored
    }

    mob:setMaxHPP(132)
    mob:setMobType(MOBTYPE_NORMAL)
    mob:setMobLevel(math.random(78,80))
    mob:setTrueDetection(1)

    if     job == xi.job.WAR then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.MIGHTY_STRIKES
        params.specials.skill.hpp = math.random(55,80)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.MNK then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.HUNDRED_FISTS
        params.specials.skill.hpp = math.random(55,70)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.WHM then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.BENEDICTION
        params.specials.skill.hpp = math.random(40,60)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.BLM then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.MANAFONT
        params.specials.skill.hpp = math.random(55,80)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.RDM then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.CHAINSPELL
        params.specials.skill.hpp = math.random(55,80)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.THF then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.PERFECT_DODGE
        params.specials.skill.hpp = math.random(55,75)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.PLD then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.INVINCIBLE
        params.specials.skill.hpp = math.random(55,75)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.DRK then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.BLOOD_WEAPON
        params.specials.skill.hpp = math.random(55,75)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.BST then
    elseif job == xi.job.BRD then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.SOUL_VOICE
        params.specials.skill.hpp = math.random(55,80)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.RNG then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = familyEES[mob:getFamily()]
        params.specials.skill.hpp = math.random(55,75)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.SAM then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.MEIKYO_SHISUI
        params.specials.skill.hpp = math.random(55,80)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.NIN then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.MIJIN_GAKURE
        params.specials.skill.hpp = math.random(25,35)
        xi.mix.jobSpecial.config(mob, params)
    elseif job == xi.job.DRG then
    elseif job == xi.job.SMN then
    end

    -- Add Check After Calcs
    mob:setMobMod(xi.mobMod.CHECK_AS_NM, 2)

end

xi.dynamis.setNMStats = function(mob)
    local job = mob:getMainJob()

    mob:setMobType(MOBTYPE_NOTORIOUS)
    mob:setMaxHPP(132)
    mob:setMobLevel(math.random(80,82))
    mob:setMod(xi.mod.STR, -15)
    mob:setMod(xi.mod.VIT, -5)
    mob:setTrueDetection(1)

    if job == xi.job.NIN then
        local params = { }
        params.specials = { }
        params.specials.skill = { }
        params.specials.skill.id = xi.jsa.MIJIN_GAKURE
        params.specials.skill.hpp = math.random(15,25)
        xi.mix.jobSpecial.config(mob, params)
    end
end

xi.dynamis.setStatueStats = function(mob)
    mob:setMobType(MOBTYPE_NOTORIOUS)
    mob:setMobLevel(math.random(82,84))
    mob:setMod(xi.mod.STR, -5)
    mob:setMod(xi.mod.VIT, -5)
    mob:setMod(xi.mod.DMGMAGIC, -50)
    mob:setMod(xi.mod.DMGPHYS, -50)
    mob:setTrueDetection(1)
    -- Disabling WHM job trait mods because their job is set to WHM in the DB.
    mob:setMod(xi.mod.MDEF, 0)
    mob:setMod(xi.mod.REGEN, 0)
    mob:setMod(xi.mod.MPHEAL, 0)
end

xi.dynamis.setMegaBossStats = function(mob)
    mob:setMobType(MOBTYPE_NOTORIOUS)
    mob:setMobLevel(88)
    mob:setMod(xi.mod.STR, -10)
    mob:setTrueDetection(1)
end

xi.dynamis.setPetStats = function(mob)
    mob:setMobLevel(78)
    mob:setMod(xi.mod.STR, -40)
    mob:setMod(xi.mod.INT, -30)
    mob:setMod(xi.mod.VIT, -20)
    mob:setMod(xi.mod.RATTP, -20)
    mob:setMod(xi.mod.ATTP, -20)
    mob:setMod(xi.mod.DEFP, -5)
    mob:setTrueDetection(1)
end

xi.dynamis.setAnimatedWeaponStats = function(mob)
    mob:setMobMod(xi.mobMod.NO_MOVE, 0)
    mob:setMobMod(xi.mobMod.HP_HEAL_CHANCE, 90)
    mob:setMod(xi.mod.STUNRESTRAIT, 75)
    mob:setMod(xi.mod.PARALYZERESTRAIT, 100)
    mob:setMod(xi.mod.SLOWRESTRAIT, 100)
    mob:setMod(xi.mod.SILENCERESTRAIT, 100)
    mob:setMod(xi.mod.LULLABYRESTRAIT, 100)
    mob:setMod(xi.mod.SLEEPRESTRAIT, 100)
end

xi.dynamis.setEyeStats = function(mob)
    mob:setMobType(MOBTYPE_NOTORIOUS)
    mob:setMobLevel(math.random(82,84))
    mob:setMod(xi.mod.DEF, 420)
    mob:addMod(xi.mod.MDEF, 150)
    mob:addMod(xi.mod.DMGMAGIC, -25)
end

-- Disable Base LSB Additional Functions
m:addOverride("xi.dynamis.zoneOnInitialize", function(zone) end)
m:addOverride("xi.dynamis.somnialThresholdOnTrigger", function(player,npc) end)
m:addOverride("xi.dynamis.somnialThresholdOnEventFinish", function(player,npc) end)
m:addOverride("xi.dynamis.timeExtensionOnDeath", function(mob, player, isKiller) end)
m:addOverride("xi.dynamis.refillStatueOnSpawn", function(mob) end)
m:addOverride("xi.dynamis.refillStatueOnSDeath", function(mob, player, isKiller) end)
m:addOverride("xi.dynamis.qmOnTrade", function(player, npc, trade) end) -- Not used...  Era Dynamis does not have QM pops.
m:addOverride("xi.dynamis.getExtensions", function(player) end)

return m