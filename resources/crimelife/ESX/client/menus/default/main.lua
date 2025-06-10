show = false

CreateThread(function()
	repeat
		Wait(100)
	until ESX ~= nil

	local GUI = {}
	GUI.Time = 3
	local MenuType = 'default'

	local openMenu = function(namespace, name, data)
		show = true
		SendNUIMessage({
			script = 'default',
			action = 'openMenu',
			namespace = namespace,
			name = name,
			data = data,
		})
	end

	local closeMenu = function(namespace, name)
		SendNUIMessage({
			script = 'default',
			action = 'closeMenu',
			namespace = namespace,
			name = name,
			data = data,
		})
	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('default/menu_submit', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.submit ~= nil then
			menu.submit(data, menu)
		end

		cb('OK')
	end);

	RegisterNUICallback('default/menu_cancel', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('OK')
	end);

	RegisterNUICallback('default/menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)

		for i = 1, #data.elements, 1 do
			menu.setElement(i, 'value', data.elements[i].value)

			if data.elements[i].selected then
				menu.setElement(i, 'selected', true)
			else
				menu.setElement(i, 'selected', false)
			end
		end

		if menu.change ~= nil then
			menu.change(data, menu)
		end

		cb('OK')
	end);

	local controlMappings = {
		[18] = "ENTER",
		[177] = "BACKSPACE",
		[27] = "TOP",
		[173] = "DOWN",
		[174] = "LEFT",
		[175] = "RIGHT"
	}

	CreateThread(function()
		while true do
			Wait(50)
			local currentTime = GetGameTimer()

			for control, action in next, (controlMappings) do
				if IsControlPressed(0, control) and GetLastInputMethod(2) and (currentTime - GUI.Time) > 150 then
					SendNUIMessage({
						script = 'default',
						action = 'controlPressed',
						control = action
					})
					GUI.Time = currentTime
				end
			end
		end
	end);
end);
