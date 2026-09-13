--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--Пиши свои скрипты, додик.  Joch#0522

 AddCSLuaFile() ENT.Base='media_base' ENT.PrintName='Small TV' ENT.Category='RP' ENT.Spawnable=true ENT.MediaPlayer=true ENT.Model='models/props/cs_office/TV_plasma.mdl' if (CLIENT) then  local ﻿=Vector(6,0,19) local ​=Angle(0,90,90)  function ENT:Draw()  self:DrawModel() cam.Start3D2D(self:LocalToWorld(﻿),self:LocalToWorldAngles(​),0.065) self:DrawScreen(  - 860 * .5, - 256,860,512) cam.End3D2D() end end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
