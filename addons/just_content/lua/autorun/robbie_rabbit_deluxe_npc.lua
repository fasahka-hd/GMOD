--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--� ������ �� �������, ��� ���� �������� NPC, �������� ��������� �� ��������� ������. 
--������ ������ ���� ������� ������������ NPC, � ���������� � ������� ����������, � ������� ����������� ����: ���� ��� �������, ����� �������� � ���� �.�.�.
--��, �����, ��� ��. 
--"��� ��� npc_citizen � npc_combine_s, �� half-life 2, � �� ������ ��� � �������, ������ �� ������ ������� �������� ��� ������� ��������"
--���� �����, ������.

local Category = "Silent Hill (PsycedeliCum)"

local NPC = { 	Name = "Robbie Rabbit Red (Enemy)", 
				Class = "npc_combine_s",
				Model = "models/psycedelicum/sh3/robbie_rabbit_deluxe/npc/robbie_body_combine.mdl",
				Health = "150",
				Squadname = "MEA01",
				Numgrenades = "4",
                                Category = Category    }

list.Set( "NPC", "npc_robbie_body_combine", NPC )

local NPC = { 	Name = "Robbie Rabbit Blue (Enemy)", 
				Class = "npc_combine_s",
				Model = "models/psycedelicum/sh3/robbie_rabbit_deluxe/npc/robbie_body_blue_combine.mdl",
				Health = "150",
				Squadname = "MEA01",
				Numgrenades = "4",
                                Category = Category    }

list.Set( "NPC", "npc_robbie_body_blue_combine", NPC )

local NPC = { 	Name = "Robbie Rabbit Green (Enemy)", 
				Class = "npc_combine_s",
				Model = "models/psycedelicum/sh3/robbie_rabbit_deluxe/npc/robbie_body_green_combine.mdl",
				Health = "150",
				Squadname = "MEA01",
				Numgrenades = "4",
                                Category = Category    }

list.Set( "NPC", "npc_robbie_body_green_combine", NPC )

local NPC = { 	Name = "Robbie Rabbit Red (Good Boy)", 
				Class = "npc_citizen",
				Model = "models/psycedelicum/sh3/robbie_rabbit_deluxe/npc/robbie_clean_citizen.mdl",
				Health = "250",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "npc_robbie_clean_citizen", NPC )

local NPC = { 	Name = "Robbie Rabbit Blue (Good Boy)", 
				Class = "npc_citizen",
				Model = "models/psycedelicum/sh3/robbie_rabbit_deluxe/npc/robbie_clean_blue_citizen.mdl",
				Health = "250",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "npc_robbie_clean_blue_citizen", NPC )

local NPC = { 	Name = "Robbie Rabbit Green (Good Boy)", 
				Class = "npc_citizen",
				Model = "models/psycedelicum/sh3/robbie_rabbit_deluxe/npc/robbie_clean_green_citizen.mdl",
				Health = "250",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "npc_robbie_clean_green_citizen", NPC )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
