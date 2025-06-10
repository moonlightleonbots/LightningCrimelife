Config.DefaultWeaponTints = {
	[0] = 'standard',
	[1] = 'green',
	[2] = 'gold',
	[3] = 'pink',
	[4] = 'camouflage',
	[5] = 'blau',
	[6] = 'orange',
	[7] = 'platin'
}

Config.MkWeaponTints = {
	[0] = 'Klassisches Schwarz',
	[1] = 'Klassisches Grau',
	[2] = 'Klassisch Schwarz weiß',
	[3] = 'Klassisches Weiß',
	[4] = 'Klassisches Beige',
	[5] = 'Classic Green',
	[6] = 'Klassisches Blau',
	[7] = 'Classic Earth',
	[8] = 'Klassisches Braun und Schwarz',
	[9] = 'Roter Kontrast',
	[10] = 'Blauer Kontrast',
	[11] = 'Gelber Kontrast',
	[12] = 'Orange Kontrast',
	[13] = 'Bold Pink',
	[14] = 'Kräftiges Lila und Gelb',
	[15] = 'Fettes Orange',
	[16] = 'Kräftiges Grün und Lila',
	[17] = 'Rot Features',
	[18] = 'Grün Features',
	[19] = 'Cyan Features',
	[20] = 'Fettgelbe Merkmale',
	[21] = 'Kräftiges Rot und Weiß',
	[22] = 'Kräftiges Blau und Weiß',
	[23] = 'Metallisches Gold',
	[24] = 'Metallic Platinum',
	[25] = 'Metallic Grau und Lila',
	[26] = 'Metallic Purple & Lime',
	[27] = 'Metallic Rot',
	[28] = 'Metallic Grün',
	[29] = 'Metallic Blau',
	[30] = 'Metallic Weiß und Aqua',
	[31] = 'Metallic Rot und Gelb'
}

Config.Weapons = {
	{ name = 'WEAPON_AR15',         label = "AR-15",                 components = {} },
	{ name = 'WEAPON_DE',           label = "Desert Eagle",          components = {} },
	{ name = 'WEAPON_M4',           label = "M4",                    components = {} },
	{ name = 'WEAPON_M70',          label = "M70",                   components = {} },
	{ name = 'WEAPON_MK14',         label = "MK14",                  components = {} },
	{ name = 'WEAPON_REMINGTON',    label = "Remington 870",         components = {} },
	{ name = 'WEAPON_SCARH',        label = "SCAR-H",                components = {} },
	{ name = 'WEAPON_UZI',          label = "UZI",                   components = {} },
	{ name = 'WEAPON_MP9',          label = "MP9",                   components = {} },
	{ name = 'WEAPON_HK416',        label = "HK-416",                components = {} },
	{ name = 'WEAPON_MP5',          label = "MP5",                   components = {} },
	{ name = 'WEAPON_AKS74',        label = "AKS74-U",               components = {} },
	{ name = 'WEAPON_GLOCK18C',     label = "Glock18c",              components = {} },
	{ name = 'WEAPON_SHIV',         label = "Shiv",                  components = {} },
	{ name = 'WEAPON_SLEDGEHAMMER', label = "Sledge Hammer",         components = {} },
	{ name = 'WEAPON_COLBATON',     label = "Teleskop",              components = {} },
	{ name = 'WEAPON_BAYONETKNIFE', label = "Bayonet",               components = {} },
	{ name = 'WEAPON_KATANA',       label = "Katana",                components = {} },
	{ name = 'WEAPON_KHAMMER',      label = "Axe Of Kratos",         components = {} },
	{ name = 'WEAPON_BBAT',         label = "Crazy Bat",             components = {} },
	{ name = 'WEAPON_BBBAT',        label = "Vernichter",            components = {} },
	{ name = 'WEAPON_CANDYAXE',     label = "Candy Axe Pickaxe",     components = {} },
	{ name = 'WEAPON_DHAMMER',      label = "Deadric Hammer",        components = {} },
	{ name = 'WEAPON_DSWORD',       label = "Deadric Sword",         components = {} },
	{ name = 'WEAPON_DAXE',         label = "Deadric Axe",           components = {} },
	{ name = 'WEAPON_DDAGGER',      label = "Crazy Dagger",          components = {} },
	{ name = 'WEAPON_GOOFY',        label = "Goofy Hammer",          components = {} },
	{ name = 'WEAPON_HHAMMER',      label = "Crazy Hammer",          components = {} },
	{ name = 'WEAPON_KKNIFE',       label = "Knife",                 components = {} },
	{ name = 'WEAPON_MIST',         label = "Mist Splitter",         components = {} },
	{ name = 'WEAPON_RAINBOWSMASH', label = "Rainbow Smash Pickaxe", components = {} },
	{ name = 'WEAPON_SWORD',        label = "Yone Sword",            components = {} },
	{ name = 'WEAPON_DIA',          label = "Mini Diamond Pickaxe",  components = {} },

	{
		name = 'WEAPON_PISTOL',
		label = 'Pistole',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', price = 5500, hash = GetHashKey('COMPONENT_PISTOL_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        price = 750,  hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       price = 5000, hash = GetHashKey('COMPONENT_AT_PI_SUPP_02') },
		},
	},

	{
		name = 'WEAPON_PISTOL_MK2',
		label = 'Pistol MK2',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.MkWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', price = 7500,  hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        price = 1000,  hash = GetHashKey('COMPONENT_AT_PI_FLSH_02') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       price = 10000, hash = GetHashKey('COMPONENT_AT_PI_SUPP_02') },
			{ name = 'mounted_scope', label = 'Mounted Scope',       price = 1500,  hash = GetHashKey('COMPONENT_AT_PI_RAIL') },
			{ name = 'compensator',   label = 'Compensator',         price = 15000, hash = GetHashKey('COMPONENT_AT_PI_COMP') }
		}
	},

	{
		name = 'WEAPON_COMBATPISTOL',
		label = 'Kampfpistole',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
		},
	},

	{
		name = 'WEAPON_APPISTOL',
		label = 'AP Pistole',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_APPISTOL_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
		}
	},

	{
		name = 'WEAPON_PISTOL50',
		label = 'Pistole .50',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', price = 1000, hash = GetHashKey('COMPONENT_PISTOL50_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        price = 750,  hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       price = 7500, hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
		},
	},

	{
		name = 'WEAPON_SNSPISTOL',
		label = 'SNS Pistole',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', price = 1000, hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_02') },
		}
	},

	{
		name = 'WEAPON_SNSPISTOL_MK2',
		label = 'SNS Pistole MK2',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_PI_FLSH_03') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_PI_SUPP_02') },
			{ name = 'compensator',   label = 'Kompensator',         hash = GetHashKey('COMPONENT_AT_PI_COMP_02') },
			{ name = 'mounted_scope', label = 'Mounted Scope',       hash = GetHashKey('COMPONENT_AT_PI_RAIL_02') },
		}
	},

	{
		name = 'WEAPON_HEAVYPISTOL',
		label = 'Schwere Pistole',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
		}
	},

	{
		name = 'WEAPON_VINTAGEPISTOL',
		label = 'Vintage Pistole',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_02') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_PI_SUPP') }
		}
	},

	{
		name = 'WEAPON_MACHINEPISTOL',
		label = 'Maschinenpistole',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_02') },
			{ name = 'clip_drum',     label = 'trommelmagazin',      hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_03') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_PI_SUPP') }
		}
	},

	{ name = 'WEAPON_REVOLVER',       label = 'Schwerer Revolver',      tints = Config.DefaultWeaponTints, components = {},                                                ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') } },
	{ name = 'WEAPON_MARKSMANPISTOL', label = 'Marksman Pistole',       tints = Config.DefaultWeaponTints, components = {},                                                ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') } },
	{ name = 'WEAPON_DOUBLEACTION',   label = 'double-Action Revolver', components = {},                   ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') } },

	{
		name = 'WEAPON_SMG',
		label = 'SMG',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SMG') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_SMG_CLIP_02') },
			{ name = 'clip_drum',     label = 'trommelmagazin',      hash = GetHashKey('COMPONENT_SMG_CLIP_03') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
		}
	},

	{
		name = 'WEAPON_SMG_MK2',
		label = 'SMG MK2',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SMG') },
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_PI_SUPP') }
		}
	},

	{
		name = 'WEAPON_ASSAULTSMG',
		label = 'Kampf SMG',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SMG') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
		}
	},

	{
		name = 'WEAPON_MICROSMG',
		label = 'Mikro SMG',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SMG') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_MICROSMG_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
		}
	},

	{
		name = 'WEAPON_MINISMG',
		label = 'Mini SMG',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SMG') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_MINISMG_CLIP_02') }
		}
	},

	{
		name = 'WEAPON_COMBATPDW',
		label = 'Kampf PDW',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SMG') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_02') },
			{ name = 'clip_drum',     label = 'trommelmagazin',      hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_03') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') }
		}
	},

	{
		name = 'WEAPON_PUMPSHOTGUN',
		label = 'Pumpgun',
		ammo = { label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'flashlight', label = 'Taschenlampe',  hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_SR_SUPP') },
		}
	},

	{
		name = 'WEAPON_SAWNOFFSHOTGUN',
		label = 'Abgesägte Schrotflinte',
		ammo = { label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN') },
		tints = Config.DefaultWeaponTints,
		components = {
		}
	},

	{
		name = 'WEAPON_ASSAULTSHOTGUN',
		label = 'Kampf Schrotflinte',
		ammo = { label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},

	{
		name = 'WEAPON_BULLPUPSHOTGUN',
		label = 'Bullpup Schrotflinte',
		ammo = { label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'flashlight', label = 'Taschenlampe',  hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip',       label = 'Griff',         hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},

	{
		name = 'WEAPON_HEAVYSHOTGUN',
		label = 'Schwere Schrotflinte',
		ammo = { label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_02') },
			{ name = 'clip_drum',     label = 'trommelmagazin',      hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_03') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},

	{ name = 'WEAPON_DBSHOTGUN',   label = 'Doppelläufige Schrotflinte', tints = Config.DefaultWeaponTints, components = {}, ammo = { label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN') } },
	{ name = 'WEAPON_AUTOSHOTGUN', label = 'Auto Schrotflinte',          tints = Config.DefaultWeaponTints, components = {}, ammo = { label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN') } },
	{ name = 'WEAPON_MUSKET',      label = 'Muskete',                    tints = Config.DefaultWeaponTints, components = {}, ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SHOTGUN') } },

	{
		name = 'WEAPON_ASSAULTRIFLE',
		label = 'Kampfgewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02') },
			{ name = 'clip_drum',     label = 'trommelmagazin',      hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_03') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
		}
	},

	{
		name = 'WEAPON_ASSAULTRIFLE_MK2',
		label = 'Kampfgewehr MK2',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_02') },
			{ name = 'clip_drum',     label = 'trommelmagazin',      hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') }
		}
	},

	{
		name = 'WEAPON_SPECIALCARBINE_MK2',
		label = 'Spezial Karabiner Mk2',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') },
		}
	},


	{
		name = 'WEAPON_HEAVYSNIPER_MK2',
		label = 'Schwere Sniper Mk2',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_02') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_THERMAL') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_SR_SUPP_03') },
		}
	},

	{
		name = 'WEAPON_CARBINERIFLE',
		label = 'Karabinergewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02') },
			{ name = 'clip_box',      label = 'Kastenmagazin',       hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_03') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
		}
	},

	{
		name = 'WEAPON_ADVANCEDRIFLE',
		label = 'Advancedgewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
		}
	},

	{
		name = 'WEAPON_SPECIALCARBINE',
		label = 'Spezialkarabiner',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_02') },
			{ name = 'clip_drum',     label = 'trommelmagazin',      hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_03') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
		}
	},

	{
		name = 'WEAPON_BULLPUPRIFLE',
		label = 'Bullpupgewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
		}
	},

	{
		name = 'WEAPON_BULLPUPRIFLE_MK2',
		label = 'Bullpupgewehr MK2',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02_MK2') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') }
		}
	},

	{
		name = 'WEAPON_COMPACTRIFLE',
		label = 'Kampfgewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_02') },
			{ name = 'clip_drum',     label = 'trommelmagazin',      hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_03') }
		}
	},

	{
		name = 'WEAPON_TACTICALRIFLE',
		label = 'Dienstkarabiner',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_TACTICALRIFLE_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH_REH') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
		}
	},

	{
		name = 'WEAPON_MILITARYRIFLE',
		label = 'Militärgewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_MILITARYRIFLE_CLIP_02') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
		}
	},

	{
		name = 'WEAPON_HEAVYRIFLE',
		label = 'Schweres Gewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE') },
		tints = Config.DefaultWeaponTints,
		components = {}
	},

	{
		name = 'WEAPON_GADGETPISTOL',
		label = 'Tapper',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {}
	},

	{
		name = 'WEAPON_NAVYREVOLVER',
		label = 'Navy Revolver',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {}
	},

	{
		name = 'WEAPON_MG',
		label = 'MG',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_MG') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_MG_CLIP_02') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_02') },
		}
	},

	{
		name = 'WEAPON_COMBATMG',
		label = 'Kampf MG',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_MG') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_COMBATMG_CLIP_02') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
		}
	},

	{
		name = 'WEAPON_COMBATMG_MK2',
		label = 'Kampf MG MK2',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_MG') },
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_02') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') }
		}
	},

	{
		name = 'WEAPON_GUSENBERG',
		label = 'Gusenberg',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_MG') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_02') },
		}
	},

	{
		name = 'WEAPON_SNIPERRIFLE',
		label = 'Scharfschützengewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SNIPER') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'scope',          label = 'Zielfernrohr',             hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE') },
			{ name = 'scope_advanced', label = 'erweitertes Zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') },
			{ name = 'suppressor',     label = 'Schalldämpfer',            hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
		}
	},

	{
		name = 'WEAPON_HEAVYSNIPER',
		label = 'Schweres Sniper',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SNIPER') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'scope',          label = 'Zielfernrohr',             hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE') },
			{ name = 'scope_advanced', label = 'erweitertes Zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') }
		}
	},

	{
		name = 'WEAPON_MARKSMANRIFLE',
		label = 'Marksmangewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SNIPER') },
		tints = Config.DefaultWeaponTints,
		components = {
			{ name = 'clip_extended', label = 'Erweitertes Magazin', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_02') },
			{ name = 'flashlight',    label = 'Taschenlampe',        hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = 'Zielfernrohr',        hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM') },
			{ name = 'suppressor',    label = 'Schalldämpfer',       hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip',          label = 'Griff',               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
		}
	},

	{
		name = 'WEAPON_PRECISIONRIFLE',
		label = 'Präzisionsgewehr',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_SNIPER') },
		tints = Config.DefaultWeaponTints,
		components = {
		}
	},

	{
		name = 'WEAPON_RAYPISTOL',
		label = 'Alienpistole',
		ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') },
		tints = Config.DefaultWeaponTints,
		components = {}
	},

	{ name = 'WEAPON_REVOLVER_MK"',     label = 'Revolver MK2',         tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') } },

	{ name = 'WEAPON_ALUCARD',          label = 'CLS`s Casull',         tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'kugel(n)', hash = joaat('AMMO_PISTOL') } },

	{ name = 'WEAPON_MINIGUN',          label = 'Minigun',              tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_MINIGUN') } },
	{ name = 'WEAPON_RAILGUN',          label = 'Railgun',              tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_RAILGUN') } },
	{ name = 'WEAPON_STUNGUN',          label = 'Tazer',                tints = Config.DefaultWeaponTints, components = {} },
	{ name = 'WEAPON_STUNGUN_MP',       label = 'Tazer MP',             tints = Config.DefaultWeaponTints, components = {} },
	{ name = 'WEAPON_RPG',              label = 'RPG',                  tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'rakete(n)', hash = GetHashKey('AMMO_RPG') } },
	{ name = 'WEAPON_HOMINGLAUNCHER',   label = 'Homing Launcher',      tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'rakete(n)', hash = GetHashKey('AMMO_HOMINGLAUNCHER') } },
	{ name = 'WEAPON_GRENADELAUNCHER',  label = 'Granatwerfer',         tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'granate(n)', hash = GetHashKey('AMMO_GRENADELAUNCHER') } },
	{ name = 'WEAPON_COMPACTLAUNCHER',  label = 'Kompakt Granatwerfer', tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'granate(n)', hash = GetHashKey('AMMO_GRENADELAUNCHER') } },
	{ name = 'WEAPON_FLAREGUN',         label = 'Leuchtpistole',        tints = Config.DefaultWeaponTints, components = {},                                                             ammo = { label = 'signalfackeln(munition)', hash = GetHashKey('AMMO_FLAREGUN') } },
	{ name = 'WEAPON_FIREEXTINGUISHER', label = 'Feuerlöscher',         components = {},                   ammo = { label = 'Ladung', hash = GetHashKey('AMMO_FIREEXTINGUISHER') } },
	{ name = 'WEAPON_PETROLCAN',        label = 'Benzinkanister',       components = {},                   ammo = { label = 'liter Benzin', hash = GetHashKey('AMMO_PETROLCAN') } },
	{ name = 'WEAPON_FIREWORK',         label = 'Feuerwerk',            components = {},                   ammo = { label = 'feuerwerksrakete(n)', hash = GetHashKey('AMMO_FIREWORK') } },
	{ name = 'WEAPON_FLASHLIGHT',       label = 'Taschenlampe',         components = {} },
	{ name = 'GADGET_PARACHUTE',        label = 'Fallschirm',           components = {} },
	{ name = 'WEAPON_KNUCKLE',          label = 'Schlagring',           components = {} },
	{ name = 'WEAPON_HATCHET',          label = 'Mecha Katana',         components = {} },
	{ name = 'WEAPON_MACHETE',          label = 'Machete',              components = {} },
	{ name = 'WEAPON_SWITCHBLADE',      label = 'Klappmesser',          components = {} },
	{ name = 'WEAPON_BOTTLE',           label = 'Flasche',              components = {} },
	{ name = 'WEAPON_DAGGER',           label = 'Dolch',                components = {} },
	{ name = 'WEAPON_POOLCUE',          label = 'Billiard-Kö',          components = {} },
	{ name = 'WEAPON_WRENCH',           label = 'Rohrzange',            components = {} },
	{ name = 'WEAPON_BATTLEAXE',        label = 'Katana',               components = {} },
	{ name = 'WEAPON_KNIFE',            label = 'Messer',               components = {} },
	{ name = 'WEAPON_NIGHTSTICK',       label = 'Schlagstock',          components = {} },
	{ name = 'WEAPON_HAMMER',           label = 'Hammer',               components = {} },
	{ name = 'WEAPON_GOLFCLUB',         label = 'Golfschläger',         components = {} },
	{ name = 'WEAPON_CROWBAR',          label = 'Brecheisen',           components = {} },
	{ name = 'WEAPON_STONE_HATCHET',    label = 'Stein Axt',            components = {} },
	{ name = 'WEAPON_METALDETECTOR',    label = 'Metaldetector',        components = {} },

	{ name = 'WEAPON_GRENADE',          label = 'Granate',              components = {},                   ammo = { label = 'granate(n)', hash = GetHashKey('AMMO_GRENADE') } },
	{ name = 'WEAPON_SMOKEGRENADE',     label = 'Rauchgranate',         components = {},                   ammo = { label = 'bombe(n)', hash = GetHashKey('AMMO_SMOKEGRENADE') } },
	{ name = 'WEAPON_STICKYBOMB',       label = 'Haftbombe',            components = {},                   ammo = { label = 'bombe(n)', hash = GetHashKey('AMMO_STICKYBOMB') } },
	{ name = 'WEAPON_PIPEBOMB',         label = 'Rohrbombe',            components = {},                   ammo = { label = 'bombe(n)', hash = GetHashKey('AMMO_PIPEBOMB') } },
	{ name = 'WEAPON_BZGAS',            label = 'BZ Gas',               components = {},                   ammo = { label = 'can(n)', hash = GetHashKey('AMMO_BZGAS') } },
	{ name = 'WEAPON_MOLOTOV',          label = 'Molotov Cocktail',     components = {},                   ammo = { label = 'cocktail(s)', hash = GetHashKey('AMMO_MOLOTOV') } },
	{ name = 'WEAPON_PROXMINE',         label = 'Annäherungsmine',      components = {},                   ammo = { label = 'mine(n)', hash = GetHashKey('AMMO_PROXMINE') } },
	{ name = 'WEAPON_SNOWBALL',         label = 'Schneeball',           components = {},                   ammo = { label = 'schneebälle', hash = GetHashKey('AMMO_SNOWBALL') } },
	{ name = 'WEAPON_BALL',             label = 'Ball',                 components = {},                   ammo = { label = 'ball', hash = GetHashKey('AMMO_BALL') } },
	{ name = 'WEAPON_FLARE',            label = 'Leuchtfakel',          components = {},                   ammo = { label = 'signalfackel(n)', hash = GetHashKey('AMMO_FLARE') } },

	-- custom weapons
	{ name = 'WEAPON_GLOCKDM',          label = 'GLOCKDM',              components = {},                   ammo = { label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL') } },
	{
		name = 'WEAPON_CAVEIRA',
		label = 'CAVEIRA',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT", hash = GetHashKey('COMPONENT_LOUISON_CLIP_01') },
			{ name = 'luxary_finish', label = "VARMOD2",      hash = GetHashKey('COMPONENT_CAVEIRA_VARMOD2') },
			{ name = 'flashlight',    label = "FLASHLIGHT",   hash = GetHashKey('COMPONENT_AT_LOUISON_FLSH') },
			{ name = 'suppressor',    label = "SUPPRESSOR",   hash = GetHashKey('COMPONENT_AT_LOUISON_SUPP') }
		}
	},
	{
		name = 'WEAPON_MIDASGUN',
		label = 'Midas Gun',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_03') },
			{ name = 'flashlight',    label = "FLASHLIGHT",    hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope',         label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip',          label = "GRIP",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},
	{
		name = 'WEAPON_REDL',
		label = 'AK-REDL',
		components = {}
	},
	{
		name = 'WEAPON_GUTSLING',
		label = 'Yoshi`s Minigun',
		components = {}
	},
	{
		name = 'WEAPON_SNAKEU',
		label = 'Kylo`s Schlange',
		components = {}
	},
	{
		name = 'WEAPON_AKORUS',
		label = 'AKORUS',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_AKORUS_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_AKORUS_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_AKORUS_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_AKORUS_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_MILITARM4',
		label = 'MILITARM4',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_M4LEOSHOP_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_M4LEOSHOP_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_M4LEOSHOP_CLIP_03') },
			{ name = 'scope',         label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_M4LEOSHOP_MEDIUM') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_M4LEOSHOP_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_GOLDM',
		label = 'GOLDM',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_GOLDM_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_GOLDM_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_GOLDM_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_GOLDM_SUPP') }
		}
	},
	{
		name = 'WEAPON_PREDATOR',
		label = 'PREDATOR',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_PREDATOR_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_PREDATOR_CLIP_02') },
			{ name = 'clip_box',      label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_PREDATOR_CLIP_03') },
			{ name = 'scope',         label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_PREDATOR_MEDIUM') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_PREDATOR_SUPP_02') },
			{ name = 'grip',          label = "GRIP",          hash = GetHashKey('COMPONENT_AT_PREDATOR_AFGRIP') }
		}
	},
	{
		name = 'WEAPON_KINETIC',
		label = 'KINETIC',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_KINETIC_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_KINETIC_CLIP_02') },
			{ name = 'clip_box',      label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_KINETIC_CLIP_03') },
			{ name = 'scope',         label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_KINETIC_MEDIUM') },
			{ name = 'flashlight',    label = "FLASHLIGHT",    hash = GetHashKey('COMPONENT_AT_KINETIC_FLSH') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_KINETIC_SUPP_02') },
			{ name = 'grip',          label = "GRIP",          hash = GetHashKey('COMPONENT_AT_KINETIC_AFGRIP') }
		}
	},
	{
		name = 'WEAPON_SCARSC',
		label = 'SCARSC',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_SCARSC_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_SCARSC_CLIP_02') },
			{ name = 'clip_box',      label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_SCARSC_CLIP_03') },
			{ name = 'scope',         label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_SCOPE_SCARSC') },
			{ name = 'flashlight',    label = "FLASHLIGHT",    hash = GetHashKey('COMPONENT_AT_SCARSC_FLSH') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_SCARSC_SUPP_02') },
			{ name = 'grip',          label = "GRIP",          hash = GetHashKey('COMPONENT_AT_SCARSC_AFGRIP') }
		}
	},
	{
		name = 'WEAPON_TEC9M',
		label = "TEC9M",
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_TEC9M_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_TEC9M_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_TEC9M_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_TEC9M_SUPP') }
		}
	},
	{
		name = 'WEAPON_TEC9MF',
		label = "TEC9MF",
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_TEC9MF_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_TEC9MF_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_TEC9MF_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_TEC9MF_SUPP') }
		}
	},
	{
		name = 'WEAPON_TEC9MB',
		label = "TEC9MB",
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_TEC9MB_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_TEC9MB_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_TEC9MB_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_TEC9MB_SUPP') }
		}
	},
	{
		name = 'WEAPON_BLASTAK',
		label = 'BLASTAK',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_BLASTAK_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_BLASTAK_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_BLASTAK_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_BLASTAK_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_BLASTM4',
		label = 'BLASTM4',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_BLASTM4_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_BLASTM4_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_BLASTM4_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_BLASTM4_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_SIG550',
		label = 'SIG550',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_SG550_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_SG550_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_SG550_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_SG550_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_BLACKSNIPER',
		label = "BLACKSNIPER",
		components = {
			{ name = 'clip_default',   label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_BLACKLEOSHOP_CLIP_01') },
			{ name = 'clip_extended',  label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_BLACKLEOSHOP_CLIP_02') },
			{ name = 'scope',          label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_BLACKLEOSHOP_MAX') },
			{ name = 'scope_advanced', label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_BLACKLEOSHOP_MAX') },
			{ name = 'suppressor',     label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_AR_SUPPBLACKLEOSHOP_02') }
		}
	},

	{
		name = 'WEAPON_SOVEREIGN',
		label = "SOVEREIGN",
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_SOVEREIGN_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_SOVEREIGN_CLIP_02') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_SOVEREIGN_SUPP') }
		}
	},

	{
		name = 'WEAPON_GLOCK17',
		label = "GLOCK17",
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_GLOCKLEOSHOP_CLIP_02') },
			{ name = 'flashlight',    label = "FLASHLIGHT",    hash = GetHashKey('COMPONENT_AT_GLOCKLEOSHOP_FLSH') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_GLOCKLEOSHOP_SUPP') }
		}
	},

	{
		name = 'WEAPON_COACHGUN',
		label = "COACHGUN",
		components = {
			{ name = 'clip_default', label = "CLIP DEFAULT", hash = GetHashKey('COMPONENT_COACHGUN_CLIP_01') }
		}
	},
	{
		name = 'WEAPON_SHOTGUNK',
		label = "SHOTGUNK",
		components = {
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_SHOTGUNKLEOSHOPFLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_SHOTGUNK_SUPP') }
		}
	},
	{
		name = 'WEAPON_VSCO',
		label = "VSCO",
		components = {
			{ name = 'clip_default',   label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_VSCO_CLIP_01') },
			{ name = 'clip_extended',  label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_VSCO_CLIP_02') },
			{ name = 'clip_drum',      label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_VSCO_CLIP_03') },
			{ name = 'scope',          label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_VSCO_MAX') },
			{ name = 'scope_advanced', label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_VSCO_MAX2') },
			{ name = 'suppressor',     label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_AR_VSCO_02') }
		}
	},
	{
		name = 'WEAPON_BLUERIOT',
		label = "BLUERIOT",
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_BLUERIOT_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_BLUERIOT_CLIP_02') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_BLUERIOT_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_ANCIENT',
		label = 'ANCIENT',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_ANCIENT_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_ANCIENT_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_ANCIENT_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_ANCIENT_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_SNAKE',
		label = 'SNAKE',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_SNAKE_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_SNAKE_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_SNAKE_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_SNAKE_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_HELL',
		label = 'HELL',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_HELL_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_HELL_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_HELL_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_HELL_SUPP') }
		}
	},
	{
		name = 'WEAPON_OBLIVION',
		label = 'OBLIVION',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_OBLIVION_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_OBLIVION_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_OBLIVION_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_OBLIVION_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_ALIEN',
		label = 'ALIEN',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_ALIEN_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_ALIEN_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_ALIEN_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_ALIENAR_SUPP') }
		}
	},
	{
		name = 'WEAPON_MIDGARD',
		label = 'MIDGARD',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_MIDGARD_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_MIDGARD_CLIP_02') },
			{ name = 'clip_box',      label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_MIDGARD_CLIP_03') },
			{ name = 'scope',         label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_MIDGARDSCOPE_MEDIUM') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_MIDGARDAR_SUPP') }
		}
	},
	{
		name = 'WEAPON_CHAINSAW',
		label = 'CHAINSAW',
		components = {}
	},
	{
		name = 'WEAPON_SPECIALHAMMER',
		label = 'SPECIALHAMMER',
		components = {}
	},
	{
		name = 'WEAPON_CARROTKNIFE',
		label = 'KAROTTE',
		components = {}
	},
	{
		name = 'WEAPON_WOLFKNIFE',
		label = 'Wolfsklinge',
		components = {}
	},
	{
		name = 'WEAPON_PENIS',
		label = 'PENIS',
		components = {}
	},
	{
		name = 'WEAPON_MAZE',
		label = 'MAZE',
		components = {}
	},
	{
		name = 'WEAPON_REVOLVERVAMP',
		label = 'REVOLVERVAMP',
		components = {}
	},
	{
		name = 'WEAPON_GUARD',
		label = 'AK_GUARD',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_GUARD_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_GUARD_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_GUARD_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_GUARD_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_GRAU',
		label = 'GRAU',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_GRAU_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_GRAU_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_GRAU_CLIP_03') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_GRAU_CLIP_03_V2') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_GRAU_CLIP_03_V3') },
			{ name = 'flashlight',    label = "FLASHLIGHT",    hash = GetHashKey('COMPONENT_AT_GRAU_AR_FLSH') },
			{ name = 'scope',         label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_GRAU_SCOPE_MEDIUM') },
			{ name = 'scope',         label = "SCOPE 2",       hash = GetHashKey('COMPONENT_AT_GRAU_SCOPE_MEDIUM2') },
			{ name = 'scope',         label = "SCOPE 3",       hash = GetHashKey('COMPONENT_AT_GRAU_SCOPE_MEDIUM3') },
			{ name = 'scope',         label = "SCOPE LONG",    hash = GetHashKey('COMPONENT_AT_GRAU_SCOPE_LONG') },
			{ name = 'scope',         label = "SCOPE LONG X",  hash = GetHashKey('COMPONENT_AT_GRAU_SCOPE_LONGX') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_AR_GRAU_SUPP_02') },
			{ name = 'suppressor',    label = "SUPPRESSOR 2",  hash = GetHashKey('COMPONENT_AT_AR_GRAU_SUPP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR 3",  hash = GetHashKey('COMPONENT_AT_AR_GRAU_SUPP_04') },
			{ name = 'stock',         label = "STOCK 1",       hash = GetHashKey('COMPONENT_GRAU_STOCK') },
			{ name = 'stock',         label = "STOCK 2",       hash = GetHashKey('COMPONENT_GRAU_STOCK2') },
			{ name = 'stock',         label = "STOCK 3",       hash = GetHashKey('COMPONENT_GRAU_STOCK3') },
			{ name = 'stock',         label = "STOCK 4",       hash = GetHashKey('COMPONENT_GRAU_STOCK4') },
			{ name = 'stock',         label = "STOCK 5",       hash = GetHashKey('COMPONENT_GRAU_STOCK1_V2') },
			{ name = 'stock',         label = "STOCK 6",       hash = GetHashKey('COMPONENT_GRAU_STOCK2_V3') },
			{ name = 'grip',          label = "GRIP 1",        hash = GetHashKey('COMPONENT_AT_GRAU_AR_AFGRIP') },
			{ name = 'grip',          label = "GRIP 2",        hash = GetHashKey('COMPONENT_AT_GRAU_AR_AFGRIP2') },
			{ name = 'grip',          label = "GRIP 3",        hash = GetHashKey('COMPONENT_AT_GRAU_AR_AFGRIP3') },
			{ name = 'grip',          label = "GRIP 4",        hash = GetHashKey('COMPONENT_AT_GRAU_AR_AFGRIP4') },
			{ name = 'luxary_finish', label = "VARMOD5",       hash = GetHashKey('COMPONENT_GRAU_VARMOD_V5') },
			{ name = 'luxary_finish', label = "VARMOD3",       hash = GetHashKey('COMPONENT_GRAU_VARMOD_V3') },
			{ name = 'luxary_finish', label = "VARMOD4",       hash = GetHashKey('COMPONENT_GRAU_VARMOD_V4') },
			{ name = 'luxary_finish', label = "VARMOD4",       hash = GetHashKey('COMPONENT_GRAU_VARMOD_V2F') },
			{ name = 'luxary_finish', label = "VARMOD4",       hash = GetHashKey('COMPONENT_GRAU_VARMOD_V3F') },
			{ name = 'luxary_finish', label = "VARMOD2",       hash = GetHashKey('COMPONENT_GRAU_VARMOD_V2') }
		}
	},
	{
		name = 'WEAPON_SCAR17',
		label = 'SCAR17',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",    hash = GetHashKey('COMPONENT_SCAR17_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_SCAR17_CLIP_02') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_SCAR17_V2_CLIP_02') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_SCAR17_V3_CLIP_02') },
			{ name = 'clip_drum',     label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_SCAR17_CLIP_03') },
			{ name = 'clip_drum',     label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_SCAR17_V2_CLIP_03') },
			{ name = 'clip_drum',     label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_SCAR17_V3_CLIP_03') },
			{ name = 'clip_drum',     label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_SCAR17_V4_CLIP_03') },
			{ name = 'flashlight',    label = "FLASHLIGHT",      hash = GetHashKey('COMPONENT_AT_SCAR17_FLSH') },
			{ name = 'scope',         label = "SCOPE",           hash = GetHashKey('COMPONENT_AT_SCAR17_MEDIUM') },
			{ name = 'scope',         label = "SCOPE 2",         hash = GetHashKey('COMPONENT_AT_SCAR17_V3_MEDIUM') },
			{ name = 'scope',         label = "SCOPE 3",         hash = GetHashKey('COMPONENT_AT_GRAU_SCOPE_MEDIUM3') },
			{ name = 'suppressor',    label = "SUPPRESSOR",      hash = GetHashKey('COMPONENT_AT_AR_SCAR17_SUPP_02') },
			{ name = 'suppressor',    label = "SUPPRESSOR 2",    hash = GetHashKey('COMPONENT_AT_AR_SCAR17_SUPP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR 3",    hash = GetHashKey('COMPONENT_AT_AR_SCAR17_SUPP_04') },
			{ name = 'stock',         label = "STOCK 1",         hash = GetHashKey('COMPONENT_SCAR17_STOCK') },
			{ name = 'stock',         label = "STOCK 2",         hash = GetHashKey('COMPONENT_SCAR17_STOCK2') },
			{ name = 'stock',         label = "STOCK 3",         hash = GetHashKey('COMPONENT_SCAR17_STOCK3') },
			{ name = 'stock',         label = "STOCK 4",         hash = GetHashKey('COMPONENT_SCAR17_STOCK4') },
			{ name = 'stock',         label = "STOCK 5",         hash = GetHashKey('COMPONENT_SCAR17_STOCK5') },
			{ name = 'stock',         label = "STOCK 6",         hash = GetHashKey('COMPONENT_SCAR17_V2_STOCK3') },
			{ name = 'stock',         label = "STOCK 7",         hash = GetHashKey('COMPONENT_SCAR17_V3_STOCK') },
			{ name = 'stock',         label = "STOCK 8",         hash = GetHashKey('COMPONENT_SCAR17_V4_STOCK5') },
			{ name = 'luxary_finish', label = "VARMOD2",         hash = GetHashKey('COMPONENT_SCAR17_VARMOD_V2') },
			{ name = 'luxary_finish', label = "VARMOD3",         hash = GetHashKey('COMPONENT_SCAR17_VARMOD_V3') },
			{ name = 'luxary_finish', label = "VARMOD SMALL",    hash = GetHashKey('COMPONENT_SCAR17_VARMOD_SMALL') },
			{ name = 'luxary_finish', label = "VARMOD4",         hash = GetHashKey('COMPONENT_SCAR17_VARMOD_V4') }
		}
	},
	{
		name = 'WEAPON_UZILS',
		label = 'UZI',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",    hash = GetHashKey('COMPONENT_UZILS_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_UZILS_CLIP_02') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_UZILS_CLIP_03') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_UZILS_CLIP_04') },
			{ name = 'clip_extended', label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_UZILS_CLIP_01v4') },
			{ name = 'clip_extended', label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_UZILS_CLIP_02v18') },
			{ name = 'clip_extended', label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_UZILS_CLIP_02v13') },
			{ name = 'clip_extended', label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_UZILS_CLIP_03v3') },
			{ name = 'clip_extended', label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_UZILS_CLIP_03v16') },
			{ name = 'suppressor',    label = "SUPPRESSOR",      hash = GetHashKey('COMPONENT_AT_UZILS_SUPP_02') },
			{ name = 'suppressor',    label = "SUPPRESSOR 2",    hash = GetHashKey('COMPONENT_AT_UZILS_SUPP_02v3') },
			{ name = 'stock',         label = "STOCK 1",         hash = GetHashKey('COMPONENT_UZILS_STOCK') },
			{ name = 'stock',         label = "STOCK 2",         hash = GetHashKey('COMPONENT_UZILS_STOCK2') },
			{ name = 'stock',         label = "STOCK 3",         hash = GetHashKey('COMPONENT_UZILS_STOCK3') },
			{ name = 'stock',         label = "STOCK 4",         hash = GetHashKey('COMPONENT_UZILS_STOCK4') },
			{ name = 'stock',         label = "STOCK 5",         hash = GetHashKey('COMPONENT_UZILS_STOCK3v3') },
			{ name = 'stock',         label = "STOCK 6",         hash = GetHashKey('COMPONENT_UZILS_STOCKv13') },
			{ name = 'stock',         label = "STOCK 7",         hash = GetHashKey('COMPONENT_UZILS_STOCKv18') },
			{ name = 'stock',         label = "BARREL 1",        hash = GetHashKey('COMPONENT_UZILS_BARREL') },
			{ name = 'stock',         label = "BARREL 2",        hash = GetHashKey('COMPONENT_UZILS_BARREL2') },
			{ name = 'stock',         label = "BARREL 3",        hash = GetHashKey('COMPONENT_UZILS_BARREL3') },
			{ name = 'stock',         label = "BARREL 4",        hash = GetHashKey('COMPONENT_UZILS_BARREL4') },
			{ name = 'stock',         label = "BARREL 1 SKIN5",  hash = GetHashKey('COMPONENT_UZILS_BARRELv18') },
			{ name = 'stock',         label = "BARREL 1 SKIN3",  hash = GetHashKey('COMPONENT_UZILS_BARREL4v13') },
			{ name = 'luxary_finish', label = "SKIN 1",          hash = GetHashKey('COMPONENT_UZILS_VARMOD_V3') },
			{ name = 'luxary_finish', label = "SKIN 2",          hash = GetHashKey('COMPONENT_UZILS_VARMOD_V4') },
			{ name = 'luxary_finish', label = "SKIN 3",          hash = GetHashKey('COMPONENT_UZILS_VARMOD_V13') },
			{ name = 'luxary_finish', label = "SKIN 4",          hash = GetHashKey('COMPONENT_UZILS_VARMOD_V16') },
			{ name = 'luxary_finish', label = "SKIN 5",          hash = GetHashKey('COMPONENT_UZILS_VARMOD_V18') }
		}
	},
	{
		name = 'WEAPON_M19',
		label = "M19",
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",    hash = GetHashKey('COMPONENT_M19_CLIP_01') },
			{ name = 'clip_default',  label = "CLIP DEFAULT",    hash = GetHashKey('COMPONENT_M19_CLIP_01V2') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_M19_CLIP_02') },
			{ name = 'clip_drum',     label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_M19_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR 2",    hash = GetHashKey('COMPONENT_AT_PI_M19_SUPP2') },
			{ name = 'luxary_finish', label = "VARMOD2",         hash = GetHashKey('COMPONENT_M19_VARMOD_V2') },
			{ name = 'luxary_finish', label = "VARMOD3",         hash = GetHashKey('COMPONENT_M19_VARMOD_V3') },
			{ name = 'luxary_finish', label = "VARMOD4",         hash = GetHashKey('COMPONENT_M19_VARMOD_V4') },
			{ name = 'luxary_finish', label = "VARMOD5",         hash = GetHashKey('COMPONENT_M19_VARMOD_V5') },
			{ name = 'suppressor',    label = "SUPPRESSOR",      hash = GetHashKey('COMPONENT_AT_PI_M19_SUPP') }
		}
	},
	{
		name = 'WEAPON_SPIDERAK',
		label = 'SPIDERAK',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_SPIDERAK_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_SPIDERAK_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_SPIDERAK_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_SPIDERAK_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_PUMPKIN',
		label = 'PUMPKIN',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_PUMPKIN_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_PUMPKIN_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_PUMPKIN_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_PUMPKIN_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_BONEPER',
		label = "BONEPER",
		components = {
			{ name = 'clip_default',   label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_BONEPER_CLIP_01') },
			{ name = 'clip_extended',  label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_BONEPER_CLIP_02') },
			{ name = 'scope',          label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') },
			{ name = 'scope_advanced', label = "SCOPE",         hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') },
			{ name = 'suppressor',     label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_BONEPER_AR_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_DESERTPURPLE',
		label = "DESERTPURPLE",
		components = {
			{ name = 'clip_default',  label = 'component_clip_default',  hash = GetHashKey('COMPONENT_DESERT_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_DESERT_CLIP_02') },
			{ name = 'flashlight',    label = 'component_flashlight',    hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor',    label = 'component_suppressor',    hash = GetHashKey('COMPONENT_AT_DESERT_SUPP') }
		}
	},
	{
		name = 'WEAPON_DESERTNIKE',
		label = "DESERT NIKE",
		components = {
			{ name = 'clip_default',  label = 'component_clip_default',  hash = GetHashKey('COMPONENT_DESERTNIKE_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_DESERTNIKE_CLIP_02') },
			{ name = 'suppressor',    label = 'component_suppressor',    hash = GetHashKey('COMPONENT_DESERTNIKE_PI_SUPP') }
		}
	},
	{
		name = 'WEAPON_GLOCDKM',
		label = "GLOCDKM",
		components = {
			{ name = 'clip_default',  label = 'component_clip_default',  hash = GetHashKey('COMPONENT_GLOCKDM_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_GLOCKDM_CLIP_02') },
			{ name = 'suppressor',    label = 'component_suppressor',    hash = GetHashKey('COMPONENT_AT_GLOCKDM_SUPP') },
			{ name = 'suppressor',    label = 'component_suppressor',    hash = GetHashKey('COMPONENT_AT_GLOCKDMR_SUPP') },
			{ name = 'suppressor',    label = 'component_suppressor',    hash = GetHashKey('COMPONENT_AT_GLOCKDMG_SUPP') },
			{ name = 'suppressor',    label = 'component_suppressor',    hash = GetHashKey('COMPONENT_AT_GLOCKDMN_SUPP') },
			{ name = 'suppressor',    label = 'component_suppressor',    hash = GetHashKey('COMPONENT_AT_GLOCKDMB_SUPP') },
			{ name = 'luxary_finish', label = "VARMOD2",                 hash = GetHashKey('COMPONENT_GLOCKDM_VARMOD2') },
			{ name = 'luxary_finish', label = "VARMOD3",                 hash = GetHashKey('COMPONENT_GLOCKDM_VARMOD3') },
			{ name = 'luxary_finish', label = "VARMOD4",                 hash = GetHashKey('COMPONENT_GLOCKDM_VARMOD4') },
			{ name = 'luxary_finish', label = "VARMOD5",                 hash = GetHashKey('COMPONENT_GLOCKDM_VARMOD5') }
		}
	},
	{
		name = 'WEAPON_M4BEAST',
		label = 'M4BEAST',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_M4BEAST_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_M4BEAST_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_M4BEAST_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_M4BEAST_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_M4GOLDBEAST',
		label = 'M4GOLDBEAST',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_M4GOLDBEAST_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_M4GOLDBEAST_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_M4GOLDBEAST_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_M4GOLDBEAST_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_HELLSNIPER',
		label = 'HELLSNIPER',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_HELLSNIPER_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_HELLSNIPER_CLIP_02') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_HELLSNIPER_SUPP') },
			{ name = 'scope',         label = "SCOPE",         hash = GetHashKey('COMPONENT_HELLSNIPER_SCOPE_MAX') }
		}
	},
	{
		name = 'WEAPON_357',
		label = ".357",
		components = {
			{ name = 'clip_default',  label = 'component_clip_default', hash = GetHashKey('COMPONENT_357_CLIP_01') },
			{ name = 'luxary_finish', label = "VARMOD2",                hash = GetHashKey('COMPONENT_REVOLVER_VARMOD4') },
			{ name = 'luxary_finish', label = "VARMOD3",                hash = GetHashKey('COMPONENT_REVOLVER_VARMOD6') },
			{ name = 'luxary_finish', label = "VARMOD4",                hash = GetHashKey('COMPONENT_REVOLVER_VARMOD17') },
			{ name = 'luxary_finish', label = "VARMOD5",                hash = GetHashKey('COMPONENT_REVOLVER_VARMOD22') },
			{ name = 'luxary_finish', label = "VARMOD6",                hash = GetHashKey('COMPONENT_REVOLVER_VARMOD23') }
		}
	},
	{
		name = 'WEAPON_REVOLVERULTRA',
		label = "REVOLVERULTRA",
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_REVOLVERULTRA_CLIP_01') },
			{ name = 'suppressor',   label = 'component_suppressor',   hash = GetHashKey('COMPONENT_AT_REVOLVERLEOSHOP_SUPP') }
		}
	},

	{
		name = 'WEAPON_MCX',
		label = 'MCX MODULAR',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",    hash = GetHashKey('COMPONENT_MCX_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_MCX_CLIP_02') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_MCX_CLIP_04') },
			{ name = 'clip_extended', label = "EXTENDED CLIP",   hash = GetHashKey('COMPONENT_MCX_CLIP_05') },
			{ name = 'clip_drum',     label = "EXTENDED 2 CLIP", hash = GetHashKey('COMPONENT_MCX_CLIP_03') },
			{ name = 'flashlight',    label = "FLASHLIGHT",      hash = GetHashKey('COMPONENT_MCX_FLSH_01') },
			{ name = 'scope',         label = "SCOPE",           hash = GetHashKey('COMPONENT_MCX_SCOPE_01') },
			{ name = 'scope',         label = "SCOPE 2",         hash = GetHashKey('COMPONENT_MCX_SCOPE_02') },
			{ name = 'scope',         label = "SCOPE 3",         hash = GetHashKey('COMPONENT_MCX_SCOPE_03') },
			{ name = 'scope',         label = "SCOPE 4",         hash = GetHashKey('COMPONENT_MCX_SCOPE_04') },
			{ name = 'scope',         label = "SCOPE 5",         hash = GetHashKey('COMPONENT_MCX_SCOPE_05') },
			{ name = 'scope',         label = "SCOPE 6",         hash = GetHashKey('COMPONENT_MCX_SCOPE_06') },
			{ name = 'scope',         label = "SCOPE 7",         hash = GetHashKey('COMPONENT_MCX_SCOPE_07') },
			{ name = 'scope',         label = "SCOPE 8",         hash = GetHashKey('COMPONENT_MCX_SCOPE_08') },
			{ name = 'scope',         label = "SCOPE 9",         hash = GetHashKey('COMPONENT_MCX_SCOPE_09') },
			{ name = 'scope',         label = "SCOPE 10",        hash = GetHashKey('COMPONENT_MCX_SCOPE_10') },
			{ name = 'scope',         label = "SCOPE 11",        hash = GetHashKey('COMPONENT_MCX_SCOPE_11') },
			{ name = 'suppressor',    label = "SUPPRESSOR",      hash = GetHashKey('COMPONENT_AT_AR_SCAR17_SUPP_02') },
			{ name = 'suppressor',    label = "SUPPRESSOR 2",    hash = GetHashKey('COMPONENT_AT_AR_SCAR17_SUPP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR 3",    hash = GetHashKey('COMPONENT_AT_AR_SCAR17_SUPP_04') },
			{ name = 'stock',         label = "STOCK 1",         hash = GetHashKey('COMPONENT_MCX_STOCK1') },
			{ name = 'stock',         label = "STOCK 2",         hash = GetHashKey('COMPONENT_MCX_STOCK1V2') },
			{ name = 'stock',         label = "STOCK 3",         hash = GetHashKey('COMPONENT_MCX_STOCK1V3') },
			{ name = 'stock',         label = "STOCK 4",         hash = GetHashKey('COMPONENT_MCX_STOCK2') },
			{ name = 'stock',         label = "STOCK 5",         hash = GetHashKey('COMPONENT_MCX_STOCK3') },
			{ name = 'stock',         label = "STOCK 6",         hash = GetHashKey('COMPONENT_MCX_STOCK4') },
			{ name = 'stock',         label = "STOCK 7",         hash = GetHashKey('COMPONENT_MCX_STOCK5') },
			{ name = 'stock',         label = "STOCK 8",         hash = GetHashKey('COMPONENT_MCX_STOCK6') },
			{ name = 'stock',         label = "STOCK 7",         hash = GetHashKey('COMPONENT_MCX_STOCK7') },
			{ name = 'stock',         label = "STOCK 8",         hash = GetHashKey('COMPONENT_MCX_STOCK8') },
			{ name = 'stock',         label = "STOCK 7",         hash = GetHashKey('COMPONENT_MCX_STOCK9') },
			{ name = 'grip',          label = "GRIP",            hash = GetHashKey('COMPONENT_AT_MCX_AFGRIP2') },
			{ name = 'grip',          label = "GRIP 2",          hash = GetHashKey('COMPONENT_AT_MCX_AFGRIP3') },
			{ name = 'grip',          label = "GRIP 3",          hash = GetHashKey('COMPONENT_AT_MCX_AFGRIP4') },
			{ name = 'grip',          label = "GRIP 4",          hash = GetHashKey('COMPONENT_AT_MCX_AFGRIP5') },
			{ name = 'grip',          label = "GRIP 5",          hash = GetHashKey('COMPONENT_AT_MCX_AFGRIP6') },
			{ name = 'grip',          label = "GRIP 6",          hash = GetHashKey('COMPONENT_AT_MCX_AFGRIP7') },
			{ name = 'luxary_finish', label = "VARMOD1",         hash = GetHashKey('COMPONENT_MCX_FRAME_01') },
			{ name = 'luxary_finish', label = "VARMOD2",         hash = GetHashKey('COMPONENT_MCX_FRAME_02') },
			{ name = 'luxary_finish', label = "VARMOD3",         hash = GetHashKey('COMPONENT_MCX_FRAME_03') },
			{ name = 'luxary_finish', label = "VARMOD4",         hash = GetHashKey('COMPONENT_MCX_FRAME_04') },
			{ name = 'luxary_finish', label = "VARMOD5",         hash = GetHashKey('COMPONENT_MCX_FRAME_05') }
		}
	},
	{
		name = 'WEAPON_SCOM',
		label = "SCOM",
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",         hash = GetHashKey('COMPONENT_SCOM_CLIP_01') },
			{ name = 'clip_default',  label = "CLIP DEFAULT",         hash = GetHashKey('COMPONENT_SCOM4_CLIP_01') },
			{ name = 'clip_default',  label = "EXTENDED CLIP",        hash = GetHashKey('COMPONENT_SCOM6_CLIP_01') },
			{ name = 'clip_default',  label = "EXTENDED 2 CLIP",      hash = GetHashKey('COMPONENT_SCOM7_CLIP_01') },
			{ name = 'clip_default',  label = "EXTENDED 2 CLIP",      hash = GetHashKey('COMPONENT_SCOM7_CLIP_01') },
			{ name = 'clip_default',  label = "EXTENDED 2 CLIP",      hash = GetHashKey('COMPONENT_SCOM_CLIP_02') },
			{ name = 'clip_drum',     label = "EXTENDED 2 CLIP",      hash = GetHashKey('COMPONENT_SCOM_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR 1",         hash = GetHashKey('COMPONENT_AT_SCOM_SUPP') },
			{ name = 'suppressor',    label = "SUPPRESSOR 2",         hash = GetHashKey('COMPONENT_AT_SCOM2_SUPP') },
			{ name = 'suppressor',    label = "SUPPRESSOR 3",         hash = GetHashKey('COMPONENT_AT_SCOM3_SUPP') },
			{ name = 'suppressor',    label = "SUPPRESSOR 4",         hash = GetHashKey('COMPONENT_AT_SCOM4_SUPP') },
			{ name = 'suppressor',    label = "SUPPRESSOR 5",         hash = GetHashKey('COMPONENT_AT_SCOM5_SUPP') },
			{ name = 'suppressor',    label = "SUPPRESSOR 6",         hash = GetHashKey('COMPONENT_AT_SCOM6_SUPP') },
			{ name = 'suppressor',    label = "SUPPRESSOR 7",         hash = GetHashKey('COMPONENT_AT_SCOM7_SUPP') },
			{ name = 'flashlight',    label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_SCOM_FLSH') },
			{ name = 'flashlight',    label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_SCOM4_FLSH') },
			{ name = 'flashlight',    label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_SCOM6_FLSH') },
			{ name = 'flashlight',    label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_SCOM7_FLSH') },
			{ name = 'luxary_finish', label = "VARMOD2",              hash = GetHashKey('COMPONENT_SCOM_VARMOD2') },
			{ name = 'luxary_finish', label = "VARMOD3",              hash = GetHashKey('COMPONENT_SCOM_VARMOD3') },
			{ name = 'luxary_finish', label = "VARMOD4",              hash = GetHashKey('COMPONENT_SCOM_VARMOD4') },
			{ name = 'luxary_finish', label = "VARMOD5",              hash = GetHashKey('COMPONENT_SCOM_VARMOD5') },
			{ name = 'luxary_finish', label = "VARMOD6",              hash = GetHashKey('COMPONENT_SCOM_VARMOD6') },
			{ name = 'luxary_finish', label = "VARMOD7",              hash = GetHashKey('COMPONENT_SCOM_VARMOD7') }
		}
	},
	{
		name = 'WEAPON_BONEAK',
		label = 'BONEAK',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_AKBONE_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_AKBONE_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_AKBONE_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_AKBONE_SUPP_02') }
		}
	},
	--Hotstore_16_04
	{
		name = 'WEAPON_RAVENPISTOL',
		label = 'KRÄHENKNARRE',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_RAVENPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_RAVENPISTOL_CLIP_02') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_RAVEN_SUPP') }
		}
	},
	{
		name = 'WEAPON_WOLFVERN',
		label = 'WOLFVERN',
		components = {
		}
	},
	{
		name = 'WEAPON_RAVENKNIFE',
		label = 'KRÄHENKRALLE',
		components = {
		}
	},
	{
		name = 'WEAPON_SCARWHITE',
		label = 'SCARWHITE',
		components = {
			{ name = 'clip_default',  label = "CLIP DEFAULT",  hash = GetHashKey('COMPONENT_SCARWHITE_CLIP_01') },
			{ name = 'clip_extended', label = "EXTENDED CLIP", hash = GetHashKey('COMPONENT_SCARWHITE_CLIP_02') },
			{ name = 'clip_drum',     label = "DRUM CLIP",     hash = GetHashKey('COMPONENT_SCARWHITE_CLIP_03') },
			{ name = 'suppressor',    label = "SUPPRESSOR",    hash = GetHashKey('COMPONENT_AT_SCARWHITE_SUPP_02') }
		}
	},
	{
		name = 'WEAPON_BAT',
		label = 'Bratwurst Axt',
		components = {}
	},
	{
		name = 'WEAPON_WOLFKNIFE',
		label = 'Wolfsklinge',
		components = {}
	},
}
