--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--Пиши свои скрипты, додик.  Joch#0522

 AddCSLuaFile() ENT.Base='media_base' ENT.PrintName='Large TV' ENT.Category='RP' ENT.Spawnable=true ENT.MediaPlayer=true ENT.Model='models/hunter/plates/plate2x3.mdl' local ​=Color(10,10,10)  function ENT:Initialize()  self:SetMaterial('models/debug/debugwhite') self:SetColor(​) self.BaseClass.Initialize(self) end  function ENT:CanUse(‌﻿)  return  ‌﻿:IsSuperAdmin() or ( ‌﻿ == self:CPPIGetOwner()) end if (CLIENT) then  local ‌﻿=Vector(0,0,1.8) local ﻿﻿=Angle(0,90,0)  function ENT:Draw()  self:DrawModel() cam.Start3D2D(self:LocalToWorld(‌﻿),self:LocalToWorldAngles(﻿﻿),0.074) self:DrawScreen( - 960, - 540,1920,1080) cam.End3D2D() end end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
