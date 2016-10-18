function init_mod()
	global["nyan_enabled"] = {}
	global["rVar"] = {}
	global["bVar"] = {}
	global["gVar"] = {}
	global["rD"] = {}
	global["bD"] = {}
	global["gD"] = {}
	global["dec"] = -2
	global["inc"] = 2
	global["state"] = {}
	global["rBase"] = {}
	global["gBase"] = {}
	global["bBase"] = {}
end

function start_over(player_index)
	if global["nyan_enabled"] == nil then
		init_mod()
	end

	global["nyan_enabled"][player_index] = false
	global["rVar"][player_index] = 10
	global["bVar"][player_index] = 0
	global["gVar"][player_index] = 0
	global["rD"][player_index] = 0
	global["bD"][player_index] = 0
	global["gD"][player_index] = 0
	global["state"][player_index] = 1

	if game.players[player_index] ~= nil then
		game.players[player_index].color={r = global["rBase"][player_index], g = global["gBase"][player_index], b = global["bBase"][player_index], a = 1.0}
	end
end

function start_nyan(player)
	if game.players[player] ~= nil then
		global["rBase"][player] = game.players[player].color.r
		global["gBase"][player] = game.players[player].color.g
		global["bBase"][player] = game.players[player].color.b

		start_over(player)
		global["nyan_enabled"][player] = true
	end
end

function end_nyan(player)
	if game.players[player] ~= nil then
		global["nyan_enabled"][player] = false
		start_over(player)
	end
end

function draw_nyan_button(no)
	if global["nyan_enabled"][no] == false then
		game.players[no].gui.top.add{type = "button", name="start_nyan", caption = "Start Nyan"}
	else
		game.players[no].gui.top.add{type = "button", name="end_nyan", caption = "End Nyan"}
	end
end

script.on_event(defines.events.on_gui_click, function(event)
	if (global["nyan_enabled"] == nil) then
		init_mod()
	end
	-- start nyan
	if event.element.name == "start_nyan" then
		game.players[event.player_index].gui.top.start_nyan.destroy()
		start_nyan(event.player_index)
		draw_nyan_button(event.player_index)
	-- end nyan
	elseif event.element.name == "end_nyan" then
		game.players[event.player_index].gui.top.end_nyan.destroy()
		end_nyan(event.player_index)
		draw_nyan_button(event.player_index)
	end
end)


script.on_event(defines.events.on_player_created, function(event)
	count = 0
	for _ in pairs(game.players) do count = count + 1 end
	if count <= 1 then init_mod() end

	start_over(event.player_index)
	draw_nyan_button(event.player_index)
end)

script.on_init(function()
	init_mod()
end)

script.on_event(defines.events.on_tick, function(event)
	if (game.tick % 6) == 0 then
		for index, player in pairs(game.players) do
			if player ~= nil then
				if player.gui.top.start_nyan == nil and player.gui.top.end_nyan == nil then
					draw_nyan_button(player.index)
				else
				end
				if global["nyan_enabled"][index] == true then
					player.color={r = (global["rVar"][index] * 0.1), g = (global["gVar"][index] * 0.1), b = (global["bVar"][index] * 0.1), a = 1.0}

					if global["rVar"][index] >= 10 and global["rD"][index] == global["inc"] then
						global["state"][index] = 6
						global["rVar"][index] = 10
					elseif global["rVar"][index] <= 0 and global["rD"][index] == global["dec"] then
						global["state"][index] = 3
						global["rVar"][index] = 0
					elseif global["gVar"][index] >= 10 and global["gD"][index] == global["inc"] then
						global["state"][index] = 4
						global["gVar"][index] = 10
					elseif global["gVar"][index] <= 0 and global["gD"][index] == global["dec"] then
						global["state"][index] = 1
						global["gVar"][index] = 0
					elseif global["bVar"][index] >= 10 and global["bD"][index] == global["inc"] then
						global["state"][index] = 2
						global["bVar"][index] = 10
					elseif global["bVar"][index] <= 0 and global["bD"][index] == global["dec"] then
						global["state"][index] = 5
						global["bVar"][index] = 0
					end

					if global["state"][index] == 1 then
						global["rD"][index] = 0
						global["bD"][index] = global["inc"]
						global["gD"][index] = 0
					elseif global["state"][index] == 2 then
						global["rD"][index] = global["dec"]
						global["bD"][index] = 0
						global["gD"][index] = 0
					elseif global["state"][index] == 3 then
						global["rD"][index] = 0
						global["bD"][index] = 0
						global["gD"][index] = global["inc"]
					elseif global["state"][index] == 4 then
						global["rD"][index] = 0
						global["bD"][index] = global["dec"]
						global["gD"][index] = 0
					elseif global["state"][index] == 5 then
						global["rD"][index] = global["inc"]
						global["bD"][index] = 0
						global["gD"][index] = 0
					elseif global["state"][index] == 6 then
						global["rD"][index] = 0
						global["bD"][index] = 0
						global["gD"][index] = global["dec"]
					end

					global["rVar"][index] = global["rVar"][index] + global["rD"][index]
					global["bVar"][index] = global["bVar"][index] + global["bD"][index]
					global["gVar"][index] = global["gVar"][index] + global["gD"][index]
				end
			end
		end
	end
end)
