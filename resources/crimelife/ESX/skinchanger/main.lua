local Components = {
	{ label = 'Geschlecht',                   name = 'sex',          value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65 },
	{ label = 'Gesicht',                      name = 'face',         value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65, vip = false },
	{ label = 'Skin',                         name = 'skin',         value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65, vip = false },
	{ label = 'Haare 1',                      name = 'hair_1',       value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65 },
	{ label = 'Haare 2',                      name = 'hair_2',       value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65 },
	{ label = 'Haarfarbe 1',                  name = 'hair_color_1', value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65 },
	{ label = 'haarfarbe 2',                  name = 'hair_color_2', value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65 },
	{ label = 'T-Shirt 1',                    name = 'tshirt_1',     value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'T-Shirt 2',                    name = 'tshirt_2',     value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15, textureof = 'tshirt_1' },
	{ label = 'Torso 1',                      name = 'torso_1',      value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Torso 2',                      name = 'torso_2',      value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15, textureof = 'torso_1' },
	{ label = 'Tattoos 1',                    name = 'decals_1',     value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Tattoos 2',                    name = 'decals_2',     value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15, textureof = 'decals_1' },
	{ label = 'Arme',                         name = 'arms',         value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Arme 2',                       name = 'arms_2',       value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Hosen 1',                      name = 'pants_1',      value = 0,  min = 0,   zoomOffset = 0.8,  camOffset = -0.5 },
	{ label = 'Hosen 2',                      name = 'pants_2',      value = 0,  min = 0,   zoomOffset = 0.8,  camOffset = -0.5, textureof = 'pants_1' },
	{ label = 'Schuhe 1',                     name = 'shoes_1',      value = 0,  min = 0,   zoomOffset = 0.8,  camOffset = -0.8 },
	{ label = 'Schuhe 2',                     name = 'shoes_2',      value = 0,  min = 0,   zoomOffset = 0.8,  camOffset = -0.8, textureof = 'shoes_1' },
	{ label = 'Maske 1',                      name = 'mask_1',       value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65 },
	{ label = 'Maske 2',                      name = 'mask_2',       value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65, textureof = 'mask_1' },
	{ label = 'Schusssichere Weste 1',        name = 'bproof_1',     value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Schusssichere Weste 2',        name = 'bproof_2',     value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15, textureof = 'bproof_1' },
	{ label = 'Kette 1',                      name = 'chain_1',      value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65 },
	{ label = 'Kette 2',                      name = 'chain_2',      value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65, textureof = 'chain_1' },
	{ label = 'Helm 1',                       name = 'helmet_1',     value = -1, min = -1,  zoomOffset = 0.6,  camOffset = 0.65, componentId = 0 },
	{ label = 'Helm 2',                       name = 'helmet_2',     value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65, textureof = 'helmet_1' },
	{ label = 'Brille 1',                     name = 'glasses_1',    value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65 },
	{ label = 'Brille 2',                     name = 'glasses_2',    value = 0,  min = 0,   zoomOffset = 0.6,  camOffset = 0.65, textureof = 'glasses_1' },
	{ label = 'Watches 1',                    name = 'watches_1',    value = -1, min = -1,  zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Watches 2',                    name = 'watches_2',    value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15, textureof = 'watches_1' },
	{ label = 'Bracelets 1',                  name = 'bracelets_1',  value = -1, min = -1,  zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Bracelets 2',                  name = 'bracelets_2',  value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15, textureof = 'bracelets_1' },
	{ label = 'Rucksack',                     name = 'bags_1',       value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Rucksackfarbe',                name = 'bags_2',       value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15, textureof = 'bags_1' },
	{ label = 'Augenfarbe',                   name = 'eye_color',    value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Augenöffnung',                 name = 'eye_squint',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65, vip = true },
	{ label = 'Augenbrauen Größe',            name = 'eyebrows_2',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Augenbrauen Typ',              name = 'eyebrows_1',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Augenbrauenfarbe 1',           name = 'eyebrows_3',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Augenbrauenfarbe 2',           name = 'eyebrows_4',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Augenbrauen Höhe',             name = 'eyebrows_5',   value = 0,  min = -10, zoomOffset = 0.4,  camOffset = 0.65, vip = true },
	{ label = 'Augenbrauen Tiefe',            name = 'eyebrows_6',   value = 0,  min = -10, zoomOffset = 0.4,  camOffset = 0.65, vip = true },
	{ label = 'Makeup Typ',                   name = 'makeup_1',     value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Makeup dicke',                 name = 'makeup_2',     value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Makeupfarbe 1',                name = 'makeup_3',     value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Makeupfarbe 2',                name = 'makeup_4',     value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Lippenstift Typ',              name = 'lipstick_1',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Lippenstift Dicke',            name = 'lipstick_2',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Lippenstiffarbe 1',            name = 'lipstick_3',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Lippenstiffarbe 2',            name = 'lipstick_4',   value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Ohr Accessories',              name = 'ears_1',       value = -1, min = -1,  zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Ohr Accessories Farbe',        name = 'ears_2',       value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65, textureof = 'ears_1' },
	{ label = 'Brusthaar',                    name = 'chest_1',      value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Brusthaar Größe',              name = 'chest_2',      value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Brusthaar Farbe',              name = 'chest_3',      value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Körperunreinheiten',           name = 'bodyb_1',      value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Dicke der Körperunreinheiten', name = 'bodyb_2',      value = 0,  min = 0,   zoomOffset = 0.75, camOffset = 0.15 },
	{ label = 'Falten',                       name = 'age_1',        value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Faltendicke',                  name = 'age_2',        value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Flecken',                      name = 'blemishes_1',  value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Flecken Größe',                name = 'blemishes_2',  value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Erröten',                      name = 'blush_1',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Erröten dicke',                name = 'blush_2',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Erröten farbe',                name = 'blush_3',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Teint',                        name = 'complexion_1', value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Teint Dicke',                  name = 'complexion_2', value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Sonne',                        name = 'sun_1',        value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Sonnendicke',                  name = 'sun_2',        value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Sommersprossen',               name = 'moles_1',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Dicke der Sommersprossen',     name = 'moles_2',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Bart Typ',                     name = 'beard_1',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Bartdichte',                   name = 'beard_2',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Bartfarbe 1',                  name = 'beard_3',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 },
	{ label = 'Bartfarbe 2',                  name = 'beard_4',      value = 0,  min = 0,   zoomOffset = 0.4,  camOffset = 0.65 }
}

local LastSex = -1
local LoadSkin = nil
local LoadClothes = nil
local Character = {}

for i = 1, #Components, 1 do
	Character[Components[i].name] = Components[i].value
end

function LoadDefaultModel(malePed, cb)
	local playerPed = PlayerPedId()
	local characterModel

	if malePed then
		characterModel = `mp_m_freemode_01`
	else
		characterModel = `mp_f_freemode_01`
	end

	RequestModel(characterModel)

	CreateThread(function()
		while not HasModelLoaded(characterModel) do
			RequestModel(characterModel)
			Wait(0)
		end

		if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(playerPed)
		end

		SetModelAsNoLongerNeeded(characterModel)

		if cb ~= nil then
			cb()
		end

		TriggerEvent('skinchanger:modelLoaded')
	end);
end

function GetMaxVals()
	local playerPed = PlayerPedId()

	local data = {
		sex          = 1,
		face         = 45,
		skin         = 45,
		age_1        = GetNumHeadOverlayValues(3) - 1,
		age_2        = 10,
		beard_1      = GetNumHeadOverlayValues(1) - 1,
		beard_2      = 10,
		beard_3      = GetNumHairColors() - 1,
		beard_4      = GetNumHairColors() - 1,
		hair_1       = GetNumberOfPedDrawableVariations(playerPed, 2) - 1,
		hair_2       = GetNumberOfPedTextureVariations(playerPed, 2, Character['hair_1']) - 1,
		hair_color_1 = GetNumHairColors() - 1,
		hair_color_2 = GetNumHairColors() - 1,
		eye_color    = 31,
		eyebrows_1   = GetNumHeadOverlayValues(2) - 1,
		eyebrows_2   = 10,
		eyebrows_3   = GetNumHairColors() - 1,
		eyebrows_4   = GetNumHairColors() - 1,
		makeup_1     = GetNumHeadOverlayValues(4) - 1,
		makeup_2     = 10,
		makeup_3     = GetNumHairColors() - 1,
		makeup_4     = GetNumHairColors() - 1,
		lipstick_1   = GetNumHeadOverlayValues(8) - 1,
		lipstick_2   = 10,
		lipstick_3   = GetNumHairColors() - 1,
		lipstick_4   = GetNumHairColors() - 1,
		blemishes_1  = GetNumHeadOverlayValues(0) - 1,
		blemishes_2  = 10,
		blush_1      = GetNumHeadOverlayValues(5) - 1,
		blush_2      = 10,
		blush_3      = GetNumHairColors() - 1,
		complexion_1 = GetNumHeadOverlayValues(6) - 1,
		complexion_2 = 10,
		sun_1        = GetNumHeadOverlayValues(7) - 1,
		sun_2        = 10,
		moles_1      = GetNumHeadOverlayValues(9) - 1,
		moles_2      = 10,
		chest_1      = GetNumHeadOverlayValues(10) - 1,
		chest_2      = 10,
		chest_3      = GetNumHairColors() - 1,
		bodyb_1      = GetNumHeadOverlayValues(11) - 1,
		bodyb_2      = 10,
		ears_1       = GetNumberOfPedPropDrawableVariations(playerPed, 1) - 1,
		ears_2       = GetNumberOfPedPropTextureVariations(playerPed, 1, Character['ears_1'] - 1),
		tshirt_1     = GetNumberOfPedDrawableVariations(playerPed, 8) - 1,
		tshirt_2     = GetNumberOfPedTextureVariations(playerPed, 8, Character['tshirt_1']) - 1,
		torso_1      = GetNumberOfPedDrawableVariations(playerPed, 11) - 1,
		torso_2      = GetNumberOfPedTextureVariations(playerPed, 11, Character['torso_1']) - 1,
		decals_1     = GetNumberOfPedDrawableVariations(playerPed, 10) - 1,
		decals_2     = GetNumberOfPedTextureVariations(playerPed, 10, Character['decals_1']) - 1,
		arms         = GetNumberOfPedDrawableVariations(playerPed, 3) - 1,
		arms_2       = 10,
		pants_1      = GetNumberOfPedDrawableVariations(playerPed, 4) - 1,
		pants_2      = GetNumberOfPedTextureVariations(playerPed, 4, Character['pants_1']) - 1,
		shoes_1      = GetNumberOfPedDrawableVariations(playerPed, 6) - 1,
		shoes_2      = GetNumberOfPedTextureVariations(playerPed, 6, Character['shoes_1']) - 1,
		mask_1       = GetNumberOfPedDrawableVariations(playerPed, 1) - 1,
		mask_2       = GetNumberOfPedTextureVariations(playerPed, 1, Character['mask_1']) - 1,
		bproof_1     = GetNumberOfPedDrawableVariations(playerPed, 9) - 1,
		bproof_2     = GetNumberOfPedTextureVariations(playerPed, 9, Character['bproof_1']) - 1,
		chain_1      = GetNumberOfPedDrawableVariations(playerPed, 7) - 1,
		chain_2      = GetNumberOfPedTextureVariations(playerPed, 7, Character['chain_1']) - 1,
		bags_1       = GetNumberOfPedDrawableVariations(playerPed, 5) - 1,
		bags_2       = GetNumberOfPedTextureVariations(playerPed, 5, Character['bags_1']) - 1,
		helmet_1     = GetNumberOfPedPropDrawableVariations(playerPed, 0) - 1,
		helmet_2     = GetNumberOfPedPropTextureVariations(playerPed, 0, Character['helmet_1']) - 1,
		glasses_1    = GetNumberOfPedPropDrawableVariations(playerPed, 1) - 1,
		glasses_2    = GetNumberOfPedPropTextureVariations(playerPed, 1, Character['glasses_1'] - 1),
		watches_1    = GetNumberOfPedPropDrawableVariations(playerPed, 6) - 1,
		watches_2    = GetNumberOfPedPropTextureVariations(playerPed, 6, Character['watches_1']) - 1,
		bracelets_1  = GetNumberOfPedPropDrawableVariations(playerPed, 7) - 1,
		bracelets_2  = GetNumberOfPedPropTextureVariations(playerPed, 7, Character['bracelets_1'] - 1)
	}

	return data
end

function ApplySkin(skin, clothes)
	local playerPed = PlayerPedId()

	-- Set skin data
	for k, v in next, (skin) do
		Character[k] = v
	end

	-- Set clothes data
	if clothes ~= nil then
		for k, v in next, (clothes) do
			if
				k ~= 'sex' and
				k ~= 'face' and
				k ~= 'skin' and
				k ~= 'age_1' and
				k ~= 'age_2' and
				k ~= 'eye_color' and
				k ~= 'beard_1' and
				k ~= 'beard_2' and
				k ~= 'beard_3' and
				k ~= 'beard_4' and
				k ~= 'hair_1' and
				k ~= 'hair_2' and
				k ~= 'hair_color_1' and
				k ~= 'hair_color_2' and
				k ~= 'eyebrows_1' and
				k ~= 'eyebrows_2' and
				k ~= 'eyebrows_3' and
				k ~= 'eyebrows_4' and
				k ~= 'makeup_1' and
				k ~= 'makeup_2' and
				k ~= 'makeup_3' and
				k ~= 'makeup_4' and
				k ~= 'lipstick_1' and
				k ~= 'lipstick_2' and
				k ~= 'lipstick_3' and
				k ~= 'lipstick_4' and
				k ~= 'blemishes_1' and
				k ~= 'blemishes_2' and
				k ~= 'blush_1' and
				k ~= 'blush_2' and
				k ~= 'blush_3' and
				k ~= 'complexion_1' and
				k ~= 'complexion_2' and
				k ~= 'sun_1' and
				k ~= 'sun_2' and
				k ~= 'moles_1' and
				k ~= 'moles_2' and
				k ~= 'chest_1' and
				k ~= 'chest_2' and
				k ~= 'chest_3' and
				k ~= 'bodyb_1' and
				k ~= 'bodyb_2'
			then
				Character[k] = v
			end
		end
	end

	-- Set Ped Head and Face attributes
	SetPedHeadBlendData(playerPed, Character['face'], Character['face'], Character['face'], Character['skin'],
		Character['skin'], Character['skin'], 1.0, 1.0, 1.0, true)
	SetPedHairColor(playerPed, Character['hair_color_1'], Character['hair_color_2'])
	SetPedHeadOverlay(playerPed, 3, Character['age_1'], (Character['age_2'] / 10) + 0.0)
	SetPedHeadOverlay(playerPed, 0, Character['blemishes_1'], (Character['blemishes_2'] / 10) + 0.0)
	SetPedHeadOverlay(playerPed, 1, Character['beard_1'], (Character['beard_2'] / 10) + 0.0)
	SetPedEyeColor(playerPed, Character['eye_color'], 0, 1)
	SetPedHeadOverlay(playerPed, 2, Character['eyebrows_1'], (Character['eyebrows_2'] / 10) + 0.0)
	SetPedHeadOverlay(playerPed, 4, Character['makeup_1'], (Character['makeup_2'] / 10) + 0.0)
	SetPedHeadOverlay(playerPed, 8, Character['lipstick_1'], (Character['lipstick_2'] / 10) + 0.0)
	SetPedComponentVariation(playerPed, 2, Character['hair_1'], Character['hair_2'], 2)
	SetPedHeadOverlayColor(playerPed, 1, 1, Character['beard_3'], Character['beard_4'])
	SetPedHeadOverlayColor(playerPed, 2, 1, Character['eyebrows_3'], Character['eyebrows_4'])
	SetPedHeadOverlayColor(playerPed, 4, 1, Character['makeup_3'], Character['makeup_4'])
	SetPedHeadOverlayColor(playerPed, 8, 1, Character['lipstick_3'], Character['lipstick_4'])
	SetPedHeadOverlay(playerPed, 5, Character['blush_1'], (Character['blush_2'] / 10) + 0.0)
	SetPedHeadOverlayColor(playerPed, 5, 2, Character['blush_3'])
	SetPedHeadOverlay(playerPed, 6, Character['complexion_1'], (Character['complexion_2'] / 10) + 0.0)
	SetPedHeadOverlay(playerPed, 7, Character['sun_1'], (Character['sun_2'] / 10) + 0.0)
	SetPedHeadOverlay(playerPed, 9, Character['moles_1'], (Character['moles_2'] / 10) + 0.0)
	SetPedHeadOverlay(playerPed, 10, Character['chest_1'], (Character['chest_2'] / 10) + 0.0)
	SetPedHeadOverlayColor(playerPed, 10, 1, Character['chest_3'])
	SetPedHeadOverlay(playerPed, 11, Character['bodyb_1'], (Character['bodyb_2'] / 10) + 0.0)

	-- Accessories and Components
	if Character['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex(playerPed, 2, Character['ears_1'], Character['ears_2'], 2)
	end

	SetPedComponentVariation(playerPed, 8, Character['tshirt_1'], Character['tshirt_2'], 2)
	SetPedComponentVariation(playerPed, 11, Character['torso_1'], Character['torso_2'], 2)
	SetPedComponentVariation(playerPed, 3, Character['arms'], Character['arms_2'], 2)
	SetPedComponentVariation(playerPed, 10, Character['decals_1'], Character['decals_2'], 2)
	SetPedComponentVariation(playerPed, 4, Character['pants_1'], Character['pants_2'], 2)
	SetPedComponentVariation(playerPed, 6, Character['shoes_1'], Character['shoes_2'], 2)
	SetPedComponentVariation(playerPed, 1, Character['mask_1'], Character['mask_2'], 2)
	SetPedComponentVariation(playerPed, 9, Character['bproof_1'], Character['bproof_2'], 2)
	SetPedComponentVariation(playerPed, 7, Character['chain_1'], Character['chain_2'], 2)
	SetPedComponentVariation(playerPed, 5, Character['bags_1'], Character['bags_2'], 2)

	-- **New Vest Component**
	SetPedComponentVariation(playerPed, 13, Character['vest_1'], Character['vest_2'], 2) -- vest component

	if Character['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex(playerPed, 0, Character['helmet_1'], Character['helmet_2'], 2)
	end

	if Character['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex(playerPed, 1, Character['glasses_1'], Character['glasses_2'], 2)
	end

	if Character['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex(playerPed, 6, Character['watches_1'], Character['watches_2'], 2)
	end

	if Character['bracelets_1'] == -1 then
		ClearPedProp(playerPed, 7)
	else
		SetPedPropIndex(playerPed, 7, Character['bracelets_1'], Character['bracelets_2'], 2)
	end
end

AddEventHandler('skinchanger:loadDefaultModel', function(loadMale, cb)
	LoadDefaultModel(loadMale, cb)
end);

AddEventHandler('skinchanger:getData', function(cb)
	local components = json.decode(json.encode(Components))

	for k, v in next, (Character) do
		for i = 1, #components, 1 do
			if k == components[i].name then
				components[i].value = v
			end
		end
	end

	cb(components, GetMaxVals())
end);

AddEventHandler('skinchanger:change', function(key, val)
	Character[key] = val

	if key == 'sex' then
		TriggerEvent('skinchanger:loadSkin', Character)
	else
		ApplySkin(Character)
	end
end);

AddEventHandler('skinchanger:getSkin', function(cb)
	cb(Character)
end);

AddEventHandler('skinchanger:modelLoaded', function()
	ClearPedProp(PlayerPedId(), 0)

	if LoadSkin ~= nil then
		ApplySkin(LoadSkin)
		LoadSkin = nil
	end

	if LoadClothes ~= nil then
		ApplySkin(LoadClothes.playerSkin, LoadClothes.clothesSkin)
		LoadClothes = nil
	end
end);

RegisterNetEvent('skinchanger:loadSkin', function(skin, cb)
	if skin['sex'] ~= LastSex then
		LoadSkin = skin

		if skin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', true, cb)
		else
			TriggerEvent('skinchanger:loadDefaultModel', false, cb)
		end
	else
		ApplySkin(skin)

		if cb ~= nil then
			cb()
		end
	end

	LastSex = skin['sex']
end);

RegisterNetEvent('skinchanger:loadClothes', function(playerSkin, clothesSkin)
	if playerSkin['sex'] ~= LastSex then
		LoadClothes = {
			playerSkin = playerSkin,
			clothesSkin = clothesSkin
		}

		if playerSkin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', true)
		else
			TriggerEvent('skinchanger:loadDefaultModel', false)
		end
	else
		ApplySkin(playerSkin, clothesSkin)
	end

	LastSex = playerSkin['sex']
end);
