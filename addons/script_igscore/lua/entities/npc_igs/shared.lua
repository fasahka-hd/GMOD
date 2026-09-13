if not ENT then return end  -- FIX: GMod auto-runs shared.lua without ENT context

ENT.Base      = "base_ai"
ENT.Type      = "ai"
ENT.PrintName = "Донат NPC"
ENT.Author    = "GMDonate"
ENT.Category  = "IGS"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
