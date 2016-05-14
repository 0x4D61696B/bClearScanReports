-- =============================================================================
--  bClearScanReports
--    by: BurstBiscuit
-- =============================================================================

require "math"
require "table"
require "unicode"

require "lib/lib_ChatLib"
require "lib/lib_Debug"
require "lib/lib_Slash"

Debug.EnableLogging(false)


-- =============================================================================
--  Functions
-- =============================================================================

function Notification(message)
    ChatLib.Notification({text = "[bClearScanReports] " .. tostring(message)})
end

function OnSlashCommand(args)
    local argument          = unicode.lower(args.text)
    local playerTargetId    = Player.GetTargetId()
    local resourceScanIds   = Game.GetResourceScanIds()

    Debug.Table("resourceScanIds", resourceScanIds)

    if (unicode.match(argument, "^a")) then
        Notification("Removing ALL scan reports")

        for _, resourceScanId in pairs(resourceScanIds) do
            Game.AcceptResourceScan(resourceScanId, false)
        end

    elseif (unicode.match(argument, "^o")) then
        Notification("Removing scan reports of other player")

        for _, resourceScanId in pairs(resourceScanIds) do
            local resourceScanInfo = Game.GetResourceScanInfo(resourceScanId)

            if (not isequal(resourceScanInfo.ownerId, playerTargetId)) then
                Game.AcceptResourceScan(resourceScanId, false)
            end
        end

    else
        Notification("Removing personal scan reports")

        for _, resourceScanId in pairs(resourceScanIds) do
            local resourceScanInfo = Game.GetResourceScanInfo(resourceScanId)

            if (isequal(resourceScanInfo.ownerId, playerTargetId)) then
                Game.AcceptResourceScan(resourceScanId, false)
            end
        end
    end
end


-- =============================================================================
--  Events
-- =============================================================================

function OnComponentLoad()
    LIB_SLASH.BindCallback({
        slash_list  = "bclearscanreports, bcsr",
        description = "bClearScanReports",
        func        = OnSlashCommand
    })
end
