// PLEASE REMEMBER THIS ADDON IS UNDER THE LICENSE: "GNU Lesser General Public License v3"
// READ THE LICENSE UNDER THE MAIN FOLDER TO READ THE FULL LICENSE AND DESCRIPTION OF PERMISSIONS!

-- ADD THIS CODE TO ANYTHING YOU WANT THE COLOR MENU TO AFFECT: "Color(GetConVarNumber("hex_colorred"),GetConVarNumber("hex_colorgreen"),GetConVarNumber("hex_colorblue"))"




if colorschemeacceptlicense == false then return end

if SERVER then
    AddCSLuaFile()
    util.AddNetworkString("OpenMixer")

    hook.Add("PlayerSay", "ColorMixerOpen", function(ply, newtext)
        local newtext = string.lower(newtext)

        // This is where you can add ranks to access th color changer.
        // PLEASE keep to the format provided below.


        if ply:IsUserGroup("founder")
        or ply:IsUserGroup("admin")
        or ply:IsUserGroup("founder")
        or ply:IsUserGroup("superadmin")
        or ply:IsUserGroup("user")
        and (string.sub(newtext, 1, 7) == "!hvcolor") then
            net.Start("OpenMixer")
            net.Send(ply)
            return ""
        else 
            return "You are not the right user group to use this command."
        end
    end)
end


if CLIENT then
    --local hv_colorbase = CreateClientConVar("hex_color", "255, 255, 0", true, true)
    local hv_colorred = CreateClientConVar("hex_colorred", "255", true, false)
    local hv_colorgreen = CreateClientConVar("hex_colorgreen", "255", true, false)
    local hv_colorblue = CreateClientConVar("hex_colorblue", "255", true, false)
    local alpha = 0

    local function GrabColor()
        return Color(hv_colorred:GetInt(), hv_colorgreen:GetInt(), hv_colorblue:GetInt())
    end

    net.Receive("OpenMixer", function(len, ply)
        local Frame = vgui.Create("DFrame")
        Frame:SetTitle("Hex vault Color Option")
        Frame:SetSize(300, 400)
        Frame:Center()
        Frame:MakePopup()
        local colMix = vgui.Create("DColorMixer", Frame)
        colMix:Dock(TOP)
        colMix:SetPalette(true)
        colMix:SetAlphaBar(false)
        colMix:SetWangs(false)
        colMix:SetColor(GrabColor())
        local Butt = vgui.Create("DButton", Frame)
        Butt:SetText("Save Color")
        Butt:SetSize(150, 70)
        Butt:SetPos(70, 290)

        Butt.DoClick = function(Butt)
            local colors = colMix:GetColor()
            --RunConsoleCommand("hex_color", colstringred .. "," .. colstringgreen .. "," .. colstringblue)
            RunConsoleCommand("hex_colorred", colors.r)
            RunConsoleCommand("hex_colorgreen", colors.g)
            RunConsoleCommand("hex_colorblue", colors.b)
            Frame:Close()
        end
    end)
else
    return
end


