--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local money = 100
 
SWEP.PrintName  = "Своровать" // Это название нашего оружия. 
SWEP.Instructions   = "Нажми ЛКМ и ты ограбишь человека!" // Это инструкция по аддону.
SWEP.Category = "RP"
 
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
 
SWEP.Primary.ClipSize   = -1 // Это функция отвечает за количество патрон в магазине,если значение = -1 как в нашем случае,то патронов в магазине бесконечно.
SWEP.Primary.DefaultClip    = -1 // Количество патрон при получения оружия.
SWEP.Primary.Automatic  = false // Тип оружия автомат или винтовка.В нашем случае = true это автомат,при случае = false это винтовка.
SWEP.Primary.Ammo   = "none" // Тип патрон.
 
SWEP.Secondary.ClipSize = -1 // Вот тут всё то же самое как и в верхних
// функциях.
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo = "none"
 
SWEP.Weight = 1 // Вес оружия.
SWEP.AutoSwitchTo   = false // Авто переключение оружия.
SWEP.AutoSwitchFrom = false
 
SWEP.Slot   = 2 // Слот оружия,если = 1,то наше оружие будет в первом слоте рядом с монтировкой.
SWEP.SlotPos    = 10 // Позиция оружия в слоте.
SWEP.DrawAmmo   = false // Скрытие количества патрон в hudе,если = false,то патроны скрываются,если = true то патроны остаются.
SWEP.DrawCrosshair  = true // Скрытие прицела.
SWEP.HoldType   = "slam"
 
 
SWEP.ViewModel 					= Model('models/weapons/v_hands.mdl')
SWEP.ViewModelFOV 				= 62
SWEP.UseHands = true
SWEP.DrawWorldModel = false

function SWEP:PreDrawViewModel(vm)
	vm:SetMaterial('engine/occlusionproxy')
end

function SWEP:Deploy()
	if timer.Exists("pizdeccc") then timer.Remove("pizdeccc") end -- Fucking SWEP function order
	if not self.UseHands then self.UseHands = true end
	timer.Create("pizdeccc", 1, 1, function() self.UseHands = false end)
end

function SWEP:OnRemove()
	if timer.Exists("pizdeccc") then timer.Remove("pizdeccc") end
	
	if not IsValid(self.Owner) then return end
	
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then vm:SetMaterial("") end
end

function SWEP:Holster()
	self:OnRemove()
	return true
end
 
function SWEP:Reload()
end
 
function SWEP:Think()
return false
end
 
local function formatSec()

end

if SERVER then
    local math = math
    local timer, util, net = timer, util, net
    util.AddNetworkString("grabej")
    util.AddNetworkString('silentsound')
    PLAYER = PLAYER || debug.getregistry().Player
    function PLAYER:PlaySound(name, dsp, hard, vol)
        if !self || !self:IsValid() then return end;
        net.Start('silentsound')
        net.WriteString(name)
        net.WriteUInt(dsp || 75, 7)
        net.WriteUInt(hard || 100, 7)
        net.WriteFloat(vol || 1)
        net.Send(self)
    end
    net.Receivers.grabej = function(_,p)
        if p.nextAye || 0 > CurTime() then return end;
        p.nextAye = CurTime() + 1
        p:ChatPrint("Фартук в масле оливье.")
    end
    -- util.AddNetworkString("EndGrab") нахуй оно нужно
    local static = 150 * 150
    local ents, table = ents, table
    local spawns = rp.cfg.Spawns[game.GetMap()]
    function SWEP:PrimaryAttack() // ВАЖНО:Эта функция отвечает за свойства выстрела из левой кнопки мыши. || НИХУЯ ПРАВДА ЧТО ЛИ ПИЗДЕЦ
        local p = self.Owner
        local target = p:GetEyeTrace().Entity
        local tra = p:GetEyeTrace()
        if !target || !target:IsValid() || !target:IsPlayer() then return end;
        if p:GetPos():DistToSqr(target:GetPos()) > static then return end;
        local checkSpawnProtect = ents.FindInBox(spawns[1],spawns[2] )
        if table.HasValue( checkSpawnProtect,p ) || table.HasValue( checkSpawnProtect,target ) then return rp.Notify(p, NOTIFY_ERROR, 'На спавне запрещено воровать.') end
        if target:IsRoot() then return rp.Notify(self:GetOwner(), NOTIFY_ERROR, 'Ho-ho-ho, no.') end 
        if target:Team() == TEAM_ADMIN  then return rp.Notify(p, NOTIFY_ERROR, 'У администратора нельзя своровать.') end-- ставь лайк есть ли донат помойка опять мешает рпшить >:C
        
        if --[[p:SteamID() ~= 'STEAM_0:1:36843180' &&]] (target.NextGrabTime || 0) > CurTime() then return rp.Notify(p, NOTIFY_ERROR, 'Беднягу кто-то уже обворовал, подождите ;c') end;
        local value = math.random(1000,5000)
        if target:IsBot() || target:GetMoney() >= value then
            local time = CurTime() + 5
            net.Start("grabej")
            net.WriteBit(1)
            net.WriteFloat(CurTime())
            net.WriteFloat(time)
            net.Send(p)

            p:PlaySound('physics/body/body_medium_impact_soft6.wav', 40, math.random(90,110), .5)
            timer.Create(p:AccountID() .. 'grabej', .5, 12, function()
                local trace = p:GetEyeTrace().Entity
                
                if !p || !p:IsValid() || trace ~= target || !trace || !trace:IsValid() || p:GetPos():DistToSqr(target:GetPos()) > static then 
                    net.Start("grabej")
                    net.WriteBit(0)
                    net.WriteBit(0)
                    net.WriteUInt(target:EntIndex(),7)
                    net.WriteFloat(value)
                    net.Send(p)
                    p:PlaySound('physics/body/body_medium_impact_soft4.wav', 40, math.random(90,110), .5)
                    timer.Remove(p:AccountID() .. 'grabej') 
                    return 
                end;



                if time <= CurTime() then
                    if target && target:IsValid() then
                        value = target:GetMoney() >= value && value || target:GetMoney()
                        target:AddMoney(-value, 'Его ограбил чубрик ' .. p:SteamID64())
                        p:AddMoney(value, 'Ограбил чубрика ' .. target:SteamID64())
                        local randomSec = math.random(2,7)
                        timer.Simple(randomSec, function()
                            if !target || !target:IsValid() then return end;
                            target:ChatPrint("Ваш кошелек полегчал на "..rp.FormatMoney(value)..".")
                            target:PlaySound('physics/cardboard/cardboard_box_impact_soft7.wav', 40, math.random(90,110), .5)
                        end)
                        p:ChatPrint("Через " .. randomSec .. ' секунд жертва заподозрит неладное, беги!)')

                        target.NextGrabTime = CurTime() + math.random(50,69)
                    end

                    net.Start("grabej")
                    net.WriteBit(0)
                    net.WriteBit(1)
                    net.WriteUInt(target:EntIndex(),7)
                    net.WriteFloat(value)
                    net.Send(p)
                    timer.Remove(p:AccountID() .. 'grabej') 
                    p:PlaySound('npc/combine_soldier/gear5.wav', 40, math.random(90,110), .5)

                    return 
                end;
                p:PlaySound('physics/body/body_medium_impact_soft'.. math.random(7) ..'.wav', 40, math.random(90,110), .5)
                
            end)
            
        end
    end
    return
end
  
function SWEP:SecondaryAttack()return end;function SWEP:PrimaryAttack()return end;function SWEP:Reload()return end
 
local alpha = 0
local n = 0
local st = 0
local et = 0
zwr = zwr or net
local mr = math.Round
local ma = math.Approach
local mc = math.Clamp
local mm = math.max
local mtf = math.TimeFraction
local b = false
local ent = NULL
local money = 0
local success = false
net.Receivers.grabej = function(p,d)
    b = net.ReadBit() == 1
    if b then
        -- LocalPlayer():EmitSound('physics/body/body_medium_impact_soft6.wav', 75, math.random(90,110), .5)
        st = net.ReadFloat()
        et = net.ReadFloat()
    else
        -- LocalPlayer():EmitSound('physics/body/body_medium_impact_soft7.wav', 75, math.random(90,110), .5)
        success = net.ReadBit() == 1
        alpha = mr(ma(alpha, 0, 25))
        timer.Simple(2,function()
            st = 0
            et = 0
            ent = NULL
            money= 0
        end)
        ent = Entity(net.ReadUInt(7))
        money = rp.FormatMoney(net.ReadFloat())
    end
end
net.Receivers.silentsound = function()
    LocalPlayer():EmitSound(net.ReadString(), net.ReadUInt(7) || 75, net.ReadUInt(7) || 100, net.ReadFloat() || .5)
end
local Color = Color
local txt = draw.SimpleText
local ENTITY = debug.getregistry().Entity
local box = draw.RoundedBox
timer.Simple(0, function()
hook("PostDrawHUD", "PC", function()
    if !b && alpha == 0 then return end
    local self = LocalPlayer()
    local w, h = ScrW(), ScrH()
	local cur = CurTime()
    local blyat = '.'
    local k = st - et

	n = 1 - mtf(et, st, cur)
	if b then
		alpha = mr(ma(alpha, 255, 1))
	else
		alpha = mr(ma(alpha, 0, 2))
	end

    local value = mc(mm(250 * n, 8) - 8, 0, 250)
    txt('Воруем','ui.25',w*.5,h*.5 + 90,Color(245,245,225,alpha), 1, 1)
    -- box(0,w*.5-100, h*.5, 200, 20, rgb(235,235,235,alpha))
    box(0,w*.5-125, h*.5+105, 250, 10, Color(15,15,15,alpha-75))
    box(0,w*.5-125, h*.5+105, value, 10, Color(250-value, value, 25))
    --surface.SetDrawColor(clr)
    --surface.DrawOutlinedRect(w*.5-125, h*.5+105, 250, 15)
end)
end)

do 
local Color = Color
local color_green = Color(45,235,75)
local color_red = Color(235,75,45)
local alpha = 0
local draw, cam = draw, cam
local ColorAlpha = ColorAlpha
local function DrawName( ply )
    if ply ~= ent then alpha = 255 return end;
    
    alpha = Lerp(FrameTime(), alpha, 0)
    local offset = Vector( -10, 5, 45 )
	local ang = LocalPlayer():EyeAngles()
    local pos = ply:GetPos() + offset + ang:Up()
    
    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )
    
    cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )
        draw.DrawText( money, "ui.20", 2, 2, ColorAlpha(success && color_green || color_red, alpha), TEXT_ALIGN_CENTER )
    cam.End3D2D()
end
hook( "PostPlayerDraw", "DrawName", DrawName )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
