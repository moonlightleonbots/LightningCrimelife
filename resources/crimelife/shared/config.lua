Config.PlayerData = {}

Config.Discord = {
    roles = {
        ["FrakVerwaltung"] = "1302118049050263643",
        ["Blacklist"] = "1302123836702982237",
        ["Clip"] = "1302123946568843335",
        ["Booster"] = "1303752694321647677",
        ["XPBoost"] = "1302159067695022090",

        ["Team"] = "1302111424256016424",
        ["Event"] = "1302118680251076669",
        ["Support"] = "1302117519808790549",
        ["Moderator"] = "1302117460580761693",
        ["Admin"] = "1302117393421832222",
        ["Super Admin"] = "1302117393421832222",
        ["Teamleitung"] = "1302117273309282325",
        ["Manager"] = "1302117215969218620",
        ["pl"] = "1302116831867310181",
    },

    Booster = {
        name = "WEAPON_PISTOL_MK2",
        label = "Pistole MK2",
    },

    designs = {
        logo = "https://i.ibb.co/ryWXKL0/Logo-bg.png",
        banner = {
            normal = "https://i.ibb.co/tB0P4jf/Lightning-Crimelife.png",
            streak = "https://i.ibb.co/pxdFM8p/Killstreak.png",
            dashboard = "https://i.ibb.co/0QnvztK/Dashboard.png",

            factions = {
                points = "https://i.ibb.co/SsyX7zW/Fraktions-Punkte.png",
                list = "https://i.ibb.co/gMjbHCX/Fraktions-Liste.png",
            },

            pvp = {
                ffa = "https://i.ibb.co/zs2fz62/FFA.png",
                gangkrieg = "https://i.ibb.co/J2xfDWw/Gang-Kriege.png",
                gungame = "https://i.ibb.co/60DpnkN/Gungame.png",
            },



            gangwar = {
                start = "https://i.ibb.co/Fzfb8gS/Angegriffen.png",
                win = "https://i.ibb.co/M98XJBh/Gewonnen.png",
                lose = "https://i.ibb.co/nL4y4YT/Verloren.png",
            }
        }
    },
}

Config.Server = {
    Debug = function(message)
        return print("^1[DEBUG]^0 - ^1" .. GetCurrentResourceName() .. "^0 " .. tostring(message))
    end,

    GuildID = "1302105599097704528",
    color = { r = 180, g = 0, b = 0 },

    zones = {
        Army = vec3(-2265.0110, 3224.2046, 32.8102),
        Observatorium = vec3(-425.9966, 1121.9567, 325.8537),
        md = vec3(298.8010, -584.4880, 43.2607),
    },

    cams = {
        [1] = {
            name = "Army",
            position = vec4(-2145.1938, 3129.6533, 47.5502, 38.7217),
            spawn = vec3(-2265.0110, 3224.2046, 32.8102),
        },

        [2] = {
            name = "Observatorium",
            position = vec4(-459.5357, 1267.2883, 356.1366, 191.4606),
            spawn = vec3(-425.9966, 1121.9567, 325.8537),
        },
    },

    Tatoo = {
        AllTattooList = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/AllTattoos.json')),

        TattooCats = {
            { "ZONE_HEAD",      "Kopf",          { vec(0.0, 0.7, 0.7), vec(0.7, 0.0, 0.7), vec(0.0, -0.7, 0.7), vec(-0.7, 0.0, 0.7) }, vec(0.0, 0.0, 0.5) },
            { "ZONE_LEFT_LEG",  "Linkes Bein",   { vec(-0.2, 0.7, -0.7), vec(-0.7, 0.0, -0.7), vec(-0.2, -0.7, -0.7) },                vec(-0.2, 0.0, -0.6) },
            { "ZONE_LEFT_ARM",  "Linker Arm",    { vec(-0.4, 0.5, 0.2), vec(-0.7, 0.0, 0.2), vec(-0.4, -0.5, 0.2) },                   vec(-0.2, 0.0, 0.2) },
            { "ZONE_RIGHT_LEG", "Rechtes Bein",  { vec(0.2, 0.7, -0.7), vec(0.7, 0.0, -0.7), vec(0.2, -0.7, -0.7) },                   vec(0.2, 0.0, -0.6) },
            { "ZONE_RIGHT_ARM", "Rechter Arm",   { vec(0.4, 0.5, 0.2), vec(0.7, 0.0, 0.2), vec(0.4, -0.5, 0.2) },                      vec(0.2, 0.0, 0.2) },
            { "ZONE_TORSO",     "Oberkörper",    { vec(0.0, 0.7, 0.2), vec(0.0, -0.7, 0.2) },                                          vec(0.0, 0.0, 0.2) },
            { "ZONE_DEGRADE",   "Haar Übergang", { vec(0.0, 0.7, 0.7), vec(0.7, 0.0, 0.7), vec(0.0, -0.7, 0.7), vec(-0.7, 0.0, 0.7) }, vec(0.0, 0.0, 0.5) },
        },

        Shops = {
            vec4(-2256.9087, 3211.9863, 32.8102, 241.8598), --military
        }
    },

    hashToLabel = {
        -- Melee's
        [GetHashKey('WEAPON_DAGGER')] = 'Dolch',
        [GetHashKey('WEAPON_BAT')] = 'Schläger',
        [GetHashKey('WEAPON_BOTTLE')] = 'Flasche',
        [GetHashKey('WEAPON_CROWBAR')] = 'Brecheisen',
        [GetHashKey('WEAPON_UNARMED')] = 'Unbewaffnet',
        [GetHashKey('WEAPON_FLASHLIGHT')] = 'Taschenlampe',
        [GetHashKey('WEAPON_GOLFCLUB')] = 'Golfclub',
        [GetHashKey('WEAPON_HAMMER')] = 'Hammer',
        [GetHashKey('WEAPON_HATCHET')] = 'Beil',
        [GetHashKey('WEAPON_KNUCKLE')] = 'Schlagring',
        [GetHashKey('WEAPON_KNIFE')] = 'Messer',
        [GetHashKey('WEAPON_MACHETE')] = 'Machete',
        [GetHashKey('WEAPON_SWITCHBLADE')] = 'Springmesser',
        [GetHashKey('WEAPON_NIGHTSTICK')] = 'Schlagstock',
        [GetHashKey('WEAPON_WRENCH')] = 'Schraubenschlüssel',
        [GetHashKey('WEAPON_BATTLEAXE')] = 'Streitaxt',
        [GetHashKey('WEAPON_POOLCUE')] = 'Billardqueue',
        [GetHashKey('WEAPON_STONE_HATCHET')] = 'Steinbeil',
        -- Pistol's
        [GetHashKey('WEAPON_PISTOL')] = 'Pistole',
        [GetHashKey('WEAPON_COMBATPISTOL')] = 'Kampf Pistole',
        [GetHashKey('WEAPON_PISTOL_MK2')] = 'Pistole Mk II',
        [GetHashKey('WEAPON_APPISTOL')] = 'Automatikpistole',
        [GetHashKey('WEAPON_STUNGUN')] = 'Elektroschocker',
        [GetHashKey('WEAPON_PISTOL50')] = 'Pistole Kal. 50',
        [GetHashKey('WEAPON_SNSPISTOL')] = 'SNS-Pistole',
        [GetHashKey('WEAPON_SNSPISTOL_MK2')] = 'SNS-Pistole Mk II',
        [GetHashKey('WEAPON_HEAVYPISTOL')] = 'Schwerpistole',
        [GetHashKey('WEAPON_VINTAGEPISTOL')] = 'Vintage-Pistole',
        [GetHashKey('WEAPON_FLAREGUN')] = 'Leuchtpistole',
        [GetHashKey('WEAPON_MARKSMANPISTOL')] = 'Scharfschützenpistole',
        [GetHashKey('WEAPON_REVOLVER')] = 'Revolver',
        [GetHashKey('WEAPON_REVOLVER_MK2')] = 'Revolver Mk II',
        [GetHashKey('WEAPON_DOUBLEACTION')] = 'Doppelaktionsrevolver',
        [GetHashKey('WEAPON_RAYPISTOL')] = 'Ray-Pistole',
        [GetHashKey('WEAPON_CERAMICPISTOL')] = 'Keramikpistole',
        [GetHashKey('WEAPON_NAVYREVOLVER')] = 'Marine-Revolver',
        [GetHashKey('WEAPON_GADGETPISTOL')] = 'Gadget-Pistole',
        -- SMG's
        [GetHashKey('WEAPON_MICROSMG')] = 'Micro-SMG',
        [GetHashKey('WEAPON_SMG')] = 'SMG',
        [GetHashKey('WEAPON_SMG_MK2')] = 'SMG Mk II',
        [GetHashKey('WEAPON_ASSAULTSMG')] = 'Sturmgewehr-SMG',
        [GetHashKey('WEAPON_COMBATPDW')] = 'Kampf-PDW',
        [GetHashKey('WEAPON_MACHINEPISTOL')] = 'Maschinenpistole',
        [GetHashKey('WEAPON_MINISMG')] = 'Mini-SMG',
        [GetHashKey('WEAPON_RAYCARBINE')] = 'Ray-Karabiner',
        -- Shotgun's
        [GetHashKey('WEAPON_PUMPSHOTGUN')] = 'Pumpgun',
        [GetHashKey('WEAPON_PUMPSHOTGUN_MK2')] = 'Pumpgun Mk II',
        [GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = 'Abgesägte Schrotflinte',
        [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = 'Sturmgewehr-Schrotflinte',
        [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = 'Bullpup-Schrotflinte',
        [GetHashKey('WEAPON_MUSKET')] = 'Steinschlossgewehr',
        [GetHashKey('WEAPON_HEAVYSHOTGUN')] = 'Schwere Schrotflinte',
        [GetHashKey('WEAPON_DBSHOTGUN')] = 'Doppelläufige Schrotflinte',
        [GetHashKey('WEAPON_AUTOSHOTGUN')] = 'Automatik-Schrotflinte',
        [GetHashKey('WEAPON_COMBATSHOTGUN')] = 'Kampf-Schrotflinte',
        -- Rifle's
        [GetHashKey('WEAPON_ASSAULTRIFLE')] = 'Sturmgewehr',
        [GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] = 'Sturmgewehr Mk II',
        [GetHashKey('WEAPON_CARBINERIFLE')] = 'Karabiner',
        [GetHashKey('WEAPON_CARBINERIFLE_MK2')] = 'Karabiner Mk II',
        [GetHashKey('WEAPON_ADVANCEDRIFLE')] = 'Fortgeschrittenes Gewehr',
        [GetHashKey('WEAPON_SPECIALCARBINE')] = 'Spezialkarabiner',
        [GetHashKey('WEAPON_SPECIALCARBINE_MK2')] = 'Spezialkarabiner Mk II',
        [GetHashKey('WEAPON_BULLPUPRIFLE')] = 'Bullpup-Gewehr',
        [GetHashKey('WEAPON_BULLPUPRIFLE_MK2')] = 'Bullpup-Gewehr Mk II',
        [GetHashKey('WEAPON_COMPACTRIFLE')] = 'Kompaktgewehr',
        [GetHashKey('WEAPON_MILITARYRIFLE')] = 'Militärgewehr',
        [GetHashKey('WEAPON_HEAVYRIFLE')] = 'Schweres Gewehr',
        [GetHashKey('WEAPON_TACTICALRIFLE')] = 'Taktisches Gewehr',
        -- MG's
        [GetHashKey('WEAPON_MG')] = 'MG',
        [GetHashKey('WEAPON_COMBATMG')] = 'Kampf-MG',
        [GetHashKey('WEAPON_COMBATMG_MK2')] = 'Kampf-MG Mk II',
        [GetHashKey('WEAPON_GUSENBERG')] = 'Gusenberg-MG',
        -- Sniper's
        [GetHashKey('WEAPON_SNIPERRIFLE')] = 'Scharfschützengewehr',
        [GetHashKey('WEAPON_HEAVYSNIPER')] = 'Schweres Scharfschützengewehr',
        [GetHashKey('WEAPON_HEAVYSNIPER_MK2')] = 'Schweres Scharfschützengewehr Mk II',
        [GetHashKey('WEAPON_MARKSMANRIFLE')] = 'Scharfschützengewehr (Präzision)',
        [GetHashKey('WEAPON_MARKSMANRIFLE_MK2')] = 'Scharfschützengewehr (Präzision) Mk II',
        [GetHashKey('WEAPON_PRECISIONRIFLE')] = 'Präzisionsgewehr',
        -- Heavies
        [GetHashKey('WEAPON_RPG')] = 'Raketenwerfer',
        [GetHashKey('WEAPON_GRENADELAUNCHER')] = 'Granatwerfer',
        [GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE')] = 'Rauchgranatwerfer',
        [GetHashKey('WEAPON_MINIGUN')] = 'Minigun',
        [GetHashKey('WEAPON_FIREWORK')] = 'Feuerwerkwerfer',
        [GetHashKey('WEAPON_RAILGUN')] = 'Railgun',
        [GetHashKey('WEAPON_HOMINGLAUNCHER')] = 'Lenkraketenwerfer',
        [GetHashKey('WEAPON_COMPACTLAUNCHER')] = 'Kompakt-Raketenwerfer',
        [GetHashKey('WEAPON_RAYMINIGUN')] = 'Ray-Minigun',
        [GetHashKey('WEAPON_EMPLAUNCHER')] = 'EMP-Werfer',
        -- Throwables
        [GetHashKey('WEAPON_GRENADE')] = 'Granate',
        [GetHashKey('WEAPON_BZGAS')] = 'Betäubungsgas-Granate',
        [GetHashKey('WEAPON_MOLOTOV')] = 'Molotow-Cocktail',
        [GetHashKey('WEAPON_STICKYBOMB')] = 'Haftbombe',
        [GetHashKey('WEAPON_PROXMINE')] = 'Näherungsmine',
        [GetHashKey('WEAPON_SNOWBALL')] = 'Schneeball',
        [GetHashKey('WEAPON_PIPEBOMB')] = 'Rohrbombe',
        [GetHashKey('WEAPON_BALL')] = 'Ball',
        [GetHashKey('WEAPON_SMOKEGRENADE')] = 'Rauchgranate',
        [GetHashKey('WEAPON_FLARE')] = 'Leuchtfackel',
        -- Other
        [GetHashKey('WEAPON_PETROLCAN')] = 'Benzinkanister',
        [GetHashKey('GADGET_PARACHUTE')] = 'Fallschirm',
        [GetHashKey('WEAPON_FIREEXTINGUISHER')] = 'Feuerlöscher',
        -- Additional Weapons
        [GetHashKey('AR-15')] = 'AR-15',
        [GetHashKey('DesertEagle')] = 'Desert Eagle',
        [GetHashKey('M4')] = 'M4',
        [GetHashKey('M70')] = 'M70',
        [GetHashKey('MK14')] = 'MK14',
        [GetHashKey('Remington870')] = 'Remington 870',
        [GetHashKey('SCARH')] = 'SCAR-H',
        [GetHashKey('UZI')] = 'UZI',
        [GetHashKey('MP9')] = 'MP9',
        [GetHashKey('HK-416')] = 'HK-416',
        [GetHashKey('MP5')] = 'MP5',
        [GetHashKey('AKS74-U')] = 'AKS74-U',
        [GetHashKey('Glock18c')] = 'Glock18c',
        -- Additional Melees
        [GetHashKey('Shiv')] = 'Shiv',
        [GetHashKey('SledgeHammer')] = 'Sledge Hammer',
        [GetHashKey('Telescope')] = 'Teleskop',
        [GetHashKey('Bayonet')] = 'Bayonet',
        [GetHashKey('Katana')] = 'Katana',
        [GetHashKey('AxeOfKratos')] = 'Axe Of Kratos',
        [GetHashKey('CrazyBat')] = 'Crazy Bat',
        [GetHashKey('Vernichter')] = 'Vernichter',
        [GetHashKey('CandyAxePicaxe')] = 'Candy Axe Picaxe',
        [GetHashKey('Lightsaber')] = 'Lightsaber',
        [GetHashKey('DeadricHammer')] = 'Deadric Hammer',
        [GetHashKey('DeadricSword')] = 'Deadric Sword',
        [GetHashKey('DeadricAxe')] = 'Deadric Axe',
        [GetHashKey('CrazyDagger')] = 'Crazy Dagger',
        [GetHashKey('GoofyHammer')] = 'Goofy Hammer',
        [GetHashKey('CrazyHammer')] = 'Crazy Hammer',
        [GetHashKey('Knife')] = 'Knife',
        [GetHashKey('MistSplitter')] = 'Mist Splitter',
        [GetHashKey('RainbowSmashPicaxe')] = 'Rainbow Smash Picaxe',
        [GetHashKey('WhiteLightsaber')] = 'White Lightsaber',
    },

    Prices = {
        [1] = { type = 'money', name = 'money', count = math.random(550, 2500), probability = { min = 1, max = 1 } },
        [2] = { type = 'item', name = 'moneyboost', count = math.random(1, 2), probability = { min = 1, max = 2 } },
        [3] = { type = 'item', name = 'xpboost', count = math.random(1, 3), probability = { min = 1, max = 3 } },
        [4] = { type = "weapon", name = ("weapon_golfclub"):upper(), probability = { min = 1, max = 1 } }
    },

    ScorePeds = {
        Highteam = {
            {
                name = 'angel',
                position = vec4(-2269.4929, 3233.2654, 31.8101, 200.7311),
                scenario = 'WORLD_HUMAN_SMOKING',
                texthigh = 1.6,
                identifier = '6411bb12b6ecb57f9afad2cb40bb8fc6560d9527',
                Loaded = false,
                Ped = nil,
                skinData = nil
            },
            {
                name = 'Jayy',
                position = vec4(-2276.5447, 3230.1829, 31.8102, 239.2334),
                scenario = 'WORLD_HUMAN_STAND_FIRE',
                texthigh = 1.6,
                identifier = 'ceada0835929dc253fd79c87bc7ba7c930efef44',
                Loaded = false,
                Ped = nil,
                skinData = nil
            },

            {
                name = 'Kilian',
                position = vec4(-2275.6038, 3225.7622, 31.8101, 234.0396),
                scenario = 'WORLD_HUMAN_GUARD_STAND',
                texthigh = 1.6,
                identifier = '6294ad23e299d7ac36cf886ccf09c29c79cf1855',
                Loaded = false,
                Ped = nil,
                skinData = nil
            },

            -- {
            --     name = 'leoon #tür klopfer',
            --     position = vec4(-2274.6348, 3233.3718, 31.8102, 64.2094),
            --     scenario = 'WORLD_HUMAN_HAMMERING',
            --     texthigh = 1.6,
            --     identifier = '8d6050aa5f56188b0ebb4ac23bd829ca571474eb',
            --     Loaded = false,
            --     Ped = nil,
            --     skinData = nil
            -- },
        },

        Spawns = {
            [1] = vector4(-2266.0713, 3218.1582, 31.8103, 336.0378),
            [2] = vector4(-2265.3938, 3216.5481, 31.8102, 327.4893),
            [3] = vector4(-2267.6440, 3217.8965, 31.8102, 325.6316),
        },

        Texts = {
            title = 'KILLS',
            kills = '~r~%s~w~ KILLS',
            midrolls = '~r~%s~w~ MIDROLLS',
        },

        Colors = {
            [1] = 'FFD700',
            [2] = 'a19f9f',
            [3] = 'bf8970',
        },

        midrollPed = {
            [1] = vec4(-2260.9695, 3215.1753, 31.8103, 324.7489)
        }
    },

    shop = {
        ["WEAPONS"] = {
            ["WEAPON_PISTOL"] = {
                label = "Pistole",
                price = 2500,
            },
            ["WEAPON_PISTOL50"] = {
                label = "Pistole 50.",
                price = 10000,
            },

            ["WEAPON_KATANA"] = {
                label = "Katana",
                price = 20000,
            },
            ["WEAPON_KHAMMER"] = {
                label = "Axe Of Kratos",
                price = 40000,
            },
            ["WEAPON_BBAT"] = {
                label = "Crazy Bat",
                price = 30000,
            },
            ["WEAPON_CANDYAXE"] = {
                label = "Candy Pickaxe",
                price = 1000000,
            },
            ["WEAPON_DHAMMER"] = {
                label = "Deadric Hammer",
                price = 80000,
            },
            ["WEAPON_RAINBOWSMASH"] = {
                label = "Rainbow Pickaxe",
                price = 750000,
            },
            ["WEAPON_DIA"] = {
                label = "Diamond Pickaxe",
                price = 500000,
            },
            ["WEAPON_DAXE"] = {
                label = "Diamond Pickaxe",
                price = 100000,
            },
        },

        ["ITEMS"] = {
            ["xpboost"] = {
                label = "XP Boost",
                price = 5000,
            },

            ["moneyboost"] = {
                label = "Moneyboost",
                price = 8000,
            },

            ["token"] = {
                label = "Glücksrad Tokens",
                price = 350000,
            },
        },

        ["KILLEFFECTS"] = {
            ["Lightning"] = {
                price = 25000,
                img = "img/effects/Lightning.png",
                data = {
                    particleDictionary = "scr_bike_adversary",
                    particleName = "scr_adversary_gunsmith_weap_smoke"
                }
            },
            ["Fire"] = {
                price = 32000,
                img = "img/effects/Fire.png",
                data = {
                    particleDictionary = "core",
                    particleName = "fire_wrecked_plane_cockpit"
                }
            },
            ["Blood"] = {
                price = 35000,
                img = "img/effects/Blood.png",
                data = {
                    particleDictionary = "cut_trevor1",
                    particleName = "cs_head_kick_blood"
                }
            },
            ["Money"] = {
                price = 55000,
                img = "img/effects/Money.png",
                data = {
                    particleDictionary = "scr_xs_celebration",
                    particleName = "scr_xs_money_rain"
                }
            },
            ["Molten Liquid"] = {
                price = 85000,
                img = "img/effects/Molten_Liquid.png",
                data = {
                    particleDictionary = "core",
                    particleName = "ent_sht_molten_liquid"
                }
            },
            ["Elec Fire"] = {
                price = 100000,
                img = "img/effects/Elec_Fire.png",
                data = {
                    particleDictionary = "scr_carrier_heist",
                    particleName = "scr_heist_carrier_elec_fire"
                }
            },
            ["Linger Smoke"] = {
                price = 165000,
                img = "img/effects/Linger_Smoke.png",
                data = {
                    particleDictionary = "scr_agencyheistb",
                    particleName = "scr_agency3b_linger_smoke"
                }
            },
            ["Nitrous"] = {
                price = 200000,
                img = "img/effects/Nitrous.png",
                data = {
                    particleDictionary = "veh_xs_vehicle_mods",
                    particleName = "veh_nitrous"
                }
            },
            ["Confetti"] = {
                price = 280000,
                img = "img/effects/Confetti.png",
                data = {
                    particleDictionary = "scr_xs_celebration",
                    particleName = "scr_xs_confetti_burst"
                }
            }
        },

        ["CASES"] = {
            [1] = {
                class = "bronze",
                price = 500,

                rewards = {
                    ["money"] = math.random(1000, 2000),
                    ["PREMIUM"] = false,
                    ["items"] = {
                        xpboost = 1,
                        moneyboost = 1,
                        token = 1,
                    }
                }
            },

            [2] = {
                class = "silber",
                price = 750,

                rewards = {
                    ["money"] = math.random(3000, 4000),
                    ["PREMIUM"] = false,
                    ["items"] = {
                        xpboost = 1,
                        moneyboost = 1,
                        token = math.random(1, 2),
                    }
                }
            },
            [3] = {
                class = "gold",
                price = 1000,

                rewards = {
                    ["money"] = math.random(4000, 5000),
                    ["PREMIUM"] = false,
                    ["items"] = {
                        xpboost = 1,
                        moneyboost = 1,
                        token = math.random(1, 3),
                    }
                }
            },
            [4] = {
                class = "platin",
                price = 1150,

                rewards = {
                    ["money"] = math.random(5000, 6000),
                    ["PREMIUM"] = false,
                    ["items"] = {
                        xpboost = 1,
                        moneyboost = 1,
                        token = math.random(1, 4),
                    }
                }
            },
            [5] = {
                class = "diamond",
                price = 1350,

                rewards = {
                    ["money"] = math.random(6000, 7000),
                    ["PREMIUM"] = false,
                    ["items"] = {
                        xpboost = 1,
                        moneyboost = 1,
                        token = math.random(1, 5),
                    }
                }
            },
            [6] = {
                class = "elite",
                price = 1500,

                rewards = {
                    ["money"] = math.random(7000, 10000),
                    ["PREMIUM"] = true,
                    ["items"] = {
                        xpboost = 1,
                        moneyboost = 1,
                        token = math.random(1, 6),
                    }
                }
            }
        }
    },

    Settings = {
        hud = true,
        killfeed = true,
        dauermap = vec3(-2265.0110, 3224.2046, 32.8102),

        fps = {
            boost = false,
            show = false
        },

        killmarker = true,
        speak = false,

        time = 12,
        freeze = false,
        weather = "EXTRASUNNY",

        killeffect = {
            particleDictionary = "",
            particleName = "",
        },

        funk = {
            toggle = false,
            number = 0,
            sound = true,

            animation = {
                animdict = "random@arrests",
                anim = "generic_radio_enter"
            }
        },
    },

    safezone = {
        toggle = false,
        toggle2 = false,

        zones = {
            {
                name = "Observatorium",
                radius = 20.0,
                position = vec3(-425.9966, 1121.9567, 325.8537),

                marker = {
                    {
                        name = "SPAWN AUSWAHL",
                        event = "spawn:show",

                        marker = {
                            type = 5,
                            position = vec3(-424.4543, 1127.4663, 325.8541),
                            size = vec3(1.0, 1.0, 1.0),
                            color = { r = 180, g = 0, b = 0 },
                        }
                    }
                }
            },

            {
                name = "Army",
                radius = 25.0,
                position = vec3(-2265.0110, 3224.2046, 32.8102),

                marker = {
                    -- {
                    --     name = "ADVENTSKALENDER",
                    --     event = "adv:open",

                    --     marker = {
                    --         type = 31,
                    --         position = vec3(-2272.0430, 3220.7534, 32.8101),
                    --         size = vec3(1.0, 1.0, 1.0),
                    --         color = { r = 180, g = 0, b = 0 },
                    --     }
                    -- },
                },
            },
        }
    }
}

Config.Battlepass = {
    xpPerKill = 10,
    multiplier = {
        [5] = 1.3,
        [7] = 1.5,
        [10] = 2,
        [15] = 2.2,
    },

    Levels = {
        [1] = {
            needxp = 3000,
            ["free"] = { reward = { type = "money", data = 500 }, label = "500$" },
            ["premium"] = { reward = { type = "money", data = 600 }, label = "700$" }
        },
        [2] = {
            needxp = 5000,
            ["free"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" },
            ["premium"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" }
        },
        [3] = {
            needxp = 7000,
            ["free"] = { reward = { type = "money", data = 700 }, label = "700$" },
            ["premium"] = { reward = { type = "money", data = 800 }, label = "800$" }
        },
        [4] = {
            needxp = 10000,
            ["free"] = { reward = { type = "vehicle", data = "faggio" }, label = "FAGGIO" },
            ["premium"] = { reward = { type = "vehicle", data = "shotaro" }, label = "SHOTARO" }
        },
        [5] = {
            needxp = 12000,
            ["free"] = { reward = { type = "money", data = 1500 }, label = "1.500$" },
            ["premium"] = { reward = { type = "weapon", data = "WEAPON_KNIFE" }, label = "MESSER" },
        },
        [6] = {
            needxp = 15000,
            ["free"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "SPEED BOOST" }
        },
        [7] = {
            needxp = 19000,
            ["free"] = { reward = { type = "coins", data = 50 }, label = "COINS 20X" },
            ["premium"] = { reward = { type = "coins", data = 70 }, label = "COINS 30X" }
        },
        [8] = {
            needxp = 24000,
            ["free"] = { reward = { type = "money", data = 2000 }, label = "2.000$" },
            ["premium"] = { reward = { type = "money", data = 2200 }, label = "2.200$" }
        },
        [9] = {
            needxp = 30000,
            ["free"] = { reward = { type = "boost", data = "xpboost" }, label = "SPEED BOOST" },
            ["premium"] = { reward = { type = "money", data = 2400 }, label = "2.400$" }
        },
        [10] = {
            needxp = 37000,
            ["free"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" },
            ["premium"] = { reward = { type = "weapon", data = "WEAPON_HAMMER" }, label = "HAMMER" },
        },
        [11] = {
            needxp = 47000,
            ["free"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" },
            ["premium"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" }
        },
        [12] = {
            needxp = 58000,
            ["free"] = { reward = { type = "vehicle", data = "bifta" }, label = "BIFTA" },
            ["premium"] = { reward = { type = "vehicle", data = "vagrant" }, label = "VAGRANT" }
        },
        [13] = {
            needxp = 68000,
            ["free"] = { reward = { type = "boost", data = "xpboost" }, label = "SPEED BOOST" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" }
        },
        [14] = {
            needxp = 79000,
            ["free"] = { reward = { type = "money", data = 2600 }, label = "2.600$" },
            ["premium"] = { reward = { type = "money", data = 2800 }, label = "2.800$" }
        },
        [15] = {
            needxp = 91000,
            ["free"] = { reward = { type = "coins", data = 30 }, label = "COINS 30X" },
            ["premium"] = { reward = { type = "coins", data = 50 }, label = "COINS 40X" }
        },
        [16] = {
            needxp = 104000,
            ["free"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" },
            ["premium"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" }
        },
        [17] = {
            needxp = 118000,
            ["free"] = { reward = { type = "money", data = 3000 }, label = "3.000$" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "SPEED BOOST" }
        },
        [18] = {
            needxp = 133000,
            ["free"] = { reward = { type = "vehicle", data = "veto" }, label = "VETO" },
            ["premium"] = { reward = { type = "vehicle", data = "veto2" }, label = "VETO2" }
        },
        [19] = {
            needxp = 149000,
            ["free"] = { reward = { type = "coins", data = 60 }, label = "COINS 30X" },
            ["premium"] = { reward = { type = "coins", data = 80 }, label = "COINS 50X" }
        },
        [20] = {
            needxp = 169000,
            ["free"] = { reward = { type = "weapon", data = "GADGET_PARACHUTE" }, label = "FALLSCHIRM" },
            ["premium"] = { reward = { type = "weapon", data = "WEAPON_REVOLVER" }, label = "REVOLVER" }
        },
        [21] = {
            needxp = 189000,
            ["free"] = { reward = { type = "vehicle", data = "scorcher" }, label = "SCORCHER" },
            ["premium"] = { reward = { type = "vehicle", data = "bmx" }, label = "BMX" }
        },
        [22] = {
            needxp = 209000,
            ["free"] = { reward = { type = "money", data = 3200 }, label = "3.200$" },
            ["premium"] = { reward = { type = "money", data = 3400 }, label = "3.400$" }
        },
        [23] = {
            needxp = 229000,
            ["free"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "SPEED BOOST" }
        },
        [24] = {
            needxp = 249000,
            ["free"] = { reward = { type = "money", data = 3600 }, label = "3.600$" },
            ["premium"] = { reward = { type = "money", data = 3800 }, label = "3.800$" }
        },
        [25] = {
            needxp = 269000,
            ["free"] = { reward = { type = "vehicle", data = "stryder" }, label = "STRYDER" },
            ["premium"] = { reward = { type = "vehicle", data = "rrocket" }, label = "ROCKET" }
        },
        [26] = {
            needxp = 289000,
            ["free"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" }
        },
        [27] = {
            needxp = 309000,
            ["free"] = { reward = { type = "money", data = 4000 }, label = "4.000$" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" }
        },
        [28] = {
            needxp = 329000,
            ["free"] = { reward = { type = "weapon", data = "WEAPON_GOLFCLUB" }, label = "GOLFSCHLÄGER" },
            ["premium"] = { reward = { type = "weapon", data = "WEAPON_WRENCH" }, label = "ROHRZANGE" }
        },
        [29] = {
            needxp = 349000,
            ["free"] = { reward = { type = "money", data = 4500 }, label = "4.500$" },
            ["premium"] = { reward = { type = "money", data = 4700 }, label = "4.700$" }
        },
        [30] = {
            needxp = 369000,
            ["free"] = { reward = { type = "vehicle", data = "kuruma" }, label = "KURUMA" },
            ["premium"] = { reward = { type = "vehicle", data = "italirsx" }, label = "ITALI RSX" }
        },
        [31] = {
            needxp = 389000,
            ["free"] = { reward = { type = "money", data = 4400 }, label = "4.400$" },
            ["premium"] = { reward = { type = "money", data = 4600 }, label = "4.600$" }
        },
        [32] = {
            needxp = 399000,
            ["free"] = { reward = { type = "money", data = 4600 }, label = "4.600$" },
            ["premium"] = { reward = { type = "money", data = 4800 }, label = "4.800$" }
        },
        [33] = {
            needxp = 419000,
            ["free"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "SPEED BOOST" }
        },
        [34] = {
            needxp = 439000,
            ["free"] = { reward = { type = "weapon", data = "WEAPON_KNUCKLE" }, label = "SCHLAGRING" },
            ["premium"] = { reward = { type = "weapon", data = "WEAPON_MINECRAFTAXE" }, label = "MINECRAFT SPITZHACKE" }
        },
        [35] = {
            needxp = 459000,
            ["free"] = { reward = { type = "vehicle", data = "tempesta" }, label = "TEMPESTA" },
            ["premium"] = { reward = { type = "vehicle", data = "dominator2" }, label = "DRIFT AUTO" }
        },
        [36] = {
            needxp = 479000,
            ["free"] = { reward = { type = "money", data = 4200 }, label = "4.200$" },
            ["premium"] = { reward = { type = "money", data = 4400 }, label = "4.400$" }
        },
        [37] = {
            needxp = 499000,
            ["free"] = { reward = { type = "coins", data = 30 }, label = "COINS 30X" },
            ["premium"] = { reward = { type = "coins", data = 50 }, label = "COINS 50X" }
        },
        [38] = {
            needxp = 519000,
            ["free"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" }
        },
        [39] = {
            needxp = 539000,
            ["free"] = { reward = { type = "money", data = 4500 }, label = "4.500$" },
            ["premium"] = { reward = { type = "money", data = 4700 }, label = "4.700$" }
        },
        [40] = {
            needxp = 559000,
            ["free"] = { reward = { type = "weapon", data = "WEAPON_PRECISIONRIFLE" }, label = "PRÄZISIONSGEWEHR" },
            ["premium"] = { reward = { type = "weapon", data = "WEAPON_MARKSMANRIFLE" }, label = "SCHARFSCHÜTZENGEWEHR" }
        },
        [41] = {
            needxp = 579000,
            ["free"] = { reward = { type = "money", data = 3500 }, label = "3.500$" },
            ["premium"] = { reward = { type = "money", data = 3700 }, label = "3.700$" }
        },
        [42] = {
            needxp = 599000,
            ["free"] = { reward = { type = "money", data = 4000 }, label = "4.000$" },
            ["premium"] = { reward = { type = "money", data = 4200 }, label = "4.200$" }
        },
        [43] = {
            needxp = 619000,
            ["free"] = { reward = { type = "money", data = 4200 }, label = "4.200$" },
            ["premium"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" }
        },
        [44] = {
            needxp = 639000,
            ["free"] = { reward = { type = "boost", data = "xpboost" }, label = "XPBOOST" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "SPEED BOOST" }
        },
        [45] = {
            needxp = 659000,
            ["free"] = { reward = { type = "vehicle", data = "fbi" }, label = "FBI AUTO" },
            ["premium"] = { reward = { type = "vehicle", data = "lguard" }, label = "RETTUNGS AUTO" }
        },
        [46] = {
            needxp = 679000,
            ["free"] = { reward = { type = "boost", data = "moneyboost" }, label = "MONEY BOOST" },
            ["premium"] = { reward = { type = "money", data = 3000 }, label = "3.000$" }
        },
        [47] = {
            needxp = 699000,
            ["free"] = { reward = { type = "money", data = 3500 }, label = "3.500$" },
            ["premium"] = { reward = { type = "money", data = 3700 }, label = "3.700$" }
        },
        [48] = {
            needxp = 719000,
            ["free"] = { reward = { type = "money", data = 4500 }, label = "4.500$" },
            ["premium"] = { reward = { type = "boost", data = "xpboost" }, label = "XP BOOST" }
        },
        [49] = {
            needxp = 739000,
            ["free"] = { reward = { type = "weapon", data = "WEAPON_DAGGER" }, label = "DOLCH" },
            ["premium"] = { reward = { type = "weapon", data = "WEAPON_PISTOLXM3" }, label = "PISTOLE XM3" }
        },
        [50] = {
            needxp = 759000,
            ["free"] = { reward = { type = "vehicle", data = "seasparrow" }, label = "SEASPARROW" },
            ["premium"] = { reward = { type = "vehicle", data = "deluxo" }, label = "DELUXO" }
        }
    },

    quests = {
        ["kills"] = {
            count = 100,

            title = "KILLS",
            label = "ERREICHE 100 KILLS IN OPEN WORLD",
        },

        ["ffa_kills"] = {
            count = 100,

            title = "FFA KILLS",
            label = "ERREICHE 100 KILLS IM FFA",
        },

        ["streaks"] = {
            count = 3,
            streak = 7,

            title = "STREAKS",
            label = "ERREICHE 3x EINE 7er KILLSTREAK",
        },

        ["headshots"] = {
            count = 5,

            title = "HEADSHOTS",
            label = "ERREICHE 5 HEADSHOTS IN OPEN WORLD",
        },

        ["gungamejoin"] = {
            count = 5,

            title = "GUNGAME JOIN",
            label = "TRETE 5x EINEM GUNGAME BEI",
        },

        ["ffajoin"] = {
            count = 5,

            title = "FFA JOIN",
            label = "TRETE 5x EINEM FFA BEI",
        },
    },

    GetLevel = function(xp)
        if xp >= Config.Battlepass.Levels[1].needxp then
            for i, data in next, Config.Battlepass.Levels do
                local higher = Config.Battlepass.Levels[i + 1];
                if higher and higher.needxp then
                    if xp >= data.needxp and xp < higher.needxp then
                        return {
                            level = i,
                            max = higher.needxp,
                            raw = data.needxp,
                            xp = xp
                        };
                    end
                else
                    return {
                        level = i,
                        max = data.needxp,
                        raw = data.needxp,
                        xp = xp
                    };
                end
            end
        else
            return {
                level = 0,
                max = Config.Battlepass.Levels[1].needxp,
                raw = Config.Battlepass.Levels[1].needxp,
                xp = xp
            };
        end
    end,
}

Config.factions = {
    max = 10,

    lager = {
        join_leave = vec3(198.1515, -1004.7470, -99.0001),
        weaponskin = vec3(204.2843, -995.2436, -99.0001)
    },

    canTintWeapon = {
        "WEAPON_PISTOL",
        "WEAPON_PISTOL_MK2",
        "WEAPON_PISTOL50",
    },

    tints = {
        ["green"] = {
            label = "Grüne",
            normal = 1,
            mk2 = 16
        },

        ["army"] = {
            label = "Army",
            normal = 4,
        },

        ["lspd"] = {
            label = "LSPD",
            normal = 5,
        },

        ["orange"] = {
            label = "Orangene",
            normal = 6,
            mk2 = 15
        },

        ["gold"] = {
            label = "Goldene",
            normal = 2,
            mk2 = 23
        },

        ["pink"] = {
            label = "Pinke",
            normal = 3,
            mk2 = 13
        },

        ["platinum"] = {
            label = "Platin",
            normal = 7,
            mk2 = 24
        },
    },

    fractions = {},
    table = {}
}

Config.HUD = {
    Ranks = {
        {
            min = 0,
            label = 'Bronze 1',
            icon = 'bronze1',
            death = 1,
        },

        {
            min = 150,
            label = 'Bronze 2',
            icon = 'bronze2',
            death = 1,
        },

        {
            min = 300,
            label = 'Bronze 3',
            icon = 'bronze3',
            death = 2,
        },

        {
            min = 500,
            label = 'Bronze 4',
            icon = 'bronze4',
            death = 2,
        },

        {
            min = 750,
            label = 'Bronze 5',
            icon = 'bronze5',
            death = 3,
        },

        {
            min = 1000,
            label = 'Bronze 6',
            icon = 'bronze6',
            death = 3,
        },

        {
            min = 1250,
            label = 'Silber 1',
            icon = 'silber1',
            death = 4,
        },

        {
            min = 1500,
            label = 'Silber 2',
            icon = 'silber2',
            death = 4,
        },

        {
            min = 1750,
            label = 'Silber 3',
            icon = 'silber3',
            death = 5,
        },

        {
            min = 2000,
            label = 'Silber 4',
            icon = 'silber4',
            death = 5,
        },

        {
            min = 2250,
            label = 'Silber 5',
            icon = 'silber5',
            death = 6,
        },

        {
            min = 2500,
            label = 'Silber 6',
            icon = 'silber6',
            death = 6,
        },

        {
            min = 3000,
            label = 'Gold 1',
            icon = 'gold1',
            death = 7,
        },

        {
            min = 3250,
            label = 'Gold 2',
            icon = 'gold2',
            death = 7,
        },

        {
            min = 3500,
            label = 'Gold 3',
            icon = 'gold3',
            death = 8,
        },

        {
            min = 3750,
            label = 'Gold 4',
            icon = 'gold4',
            death = 8,
        },

        {
            min = 4000,
            label = 'Gold 5',
            icon = 'gold5',
            death = 9,
        },

        {
            min = 4250,
            label = 'Gold 6',
            icon = 'gold6',
            death = 9,
        },

        {
            min = 5000,
            label = 'Platin 1',
            icon = 'platin1',
            death = 10,
        },

        {
            min = 5250,
            label = 'Platin 2',
            icon = 'platin2',
            death = 10,
        },

        {
            min = 5500,
            label = 'Platin 3',
            icon = 'platin3',
            death = 11,
        },

        {
            min = 5750,
            label = 'Platin 4',
            icon = 'platin4',
            death = 11,
        },

        {
            min = 6000,
            label = 'Platin 5',
            icon = 'platin5',
            death = 12,
        },

        {
            min = 6250,
            label = 'Platin 6',
            icon = 'platin6',
            death = 12,
        },

        {
            min = 7000,
            label = 'Diamond 1',
            icon = 'diamond1',
            death = 13,
        },

        {
            min = 7250,
            label = 'Diamond 2',
            icon = 'diamond2',
            death = 13,
        },

        {
            min = 7500,
            label = 'Diamond 3',
            icon = 'diamond3',
            death = 14,
        },

        {
            min = 7750,
            label = 'Diamond 4',
            icon = 'diamond4',
            death = 14,
        },

        {
            min = 8000,
            label = 'Diamond 5',
            icon = 'diamond5',
            death = 15,
        },

        {
            min = 8250,
            label = 'Diamond 6',
            icon = 'diamond6',
            death = 15,
        },

        {
            min = 9000,
            label = 'Master 1',
            icon = 'master1',
            death = 16,
        },

        {
            min = 9500,
            label = 'Master 2',
            icon = 'master2',
            death = 17,
        },

        {
            min = 10000,
            label = 'Master 3',
            icon = 'master3',
            death = 18,
        },

        {
            min = 10500,
            label = 'Master 4',
            icon = 'master4',
            death = 19,
        },

        {
            min = 11000,
            label = 'Master 5',
            icon = 'master5',
            death = 20,
        },

        {
            min = 11500,
            label = 'Master 6',
            icon = 'master6',
            death = 21,
        },

        {
            min = 12500,
            label = 'Grandmaster',
            icon = 'grandmaster',
            death = 25,
        },
    },

    Notify = function(data, s)
        if IsDuplicityVersion() then
            TriggerClientEvent("Notify", s, {
                title = data.title,
                text = data.text,
                type = data.type,
                time = data.time,
            })
        else
            TriggerEvent("Notify", {
                title = data.title,
                text = data.text,
                type = data.type,
                time = data.time,
            })
        end
    end,

    announce = function(data, s)
        if IsDuplicityVersion() then
            TriggerClientEvent("announce", s, {
                title = data.title,
                text = data.text,
                time = data.time,
            })
        else
            TriggerEvent("announce", {
                title = data.title,
                text = data.text,
                time = data.time,
            })
        end
    end,

    getLiga = function(myRank)
        if myRank >= Config.HUD.Ranks[1].min then
            for i, rank in next, Config.HUD.Ranks do
                local higher = Config.HUD.Ranks[i + 1]
                if higher ~= nil then
                    if myRank >= rank.min and myRank < higher.min
                    then
                        rank.next = higher.label
                        rank.needed = higher.min
                        return rank
                    end
                else
                    rank.next = ''
                    rank.needed = 0
                    return rank, i
                end
            end
        else
            return {
                label = 'Bronze 1',
                icon = 'bronze1',
                next = Config.HUD.Ranks[1].label,
                needed = Config.HUD.Ranks[1].min - myRank,
                death = 1,
            }, 0
        end
    end
}

Config.pvp = {
    gungameWin = 250,

    gangwar = {
        RGBtoString = function(t)
            return ('rgb(%s, %s, %s)'):format(t.r, t.g, t.b);
        end,

        Announce = function(source, msg)
            if IsDuplicityVersion() then
                Config.HUD.announce({
                    title = 'Gangwar',
                    text = msg,
                    time = 12000,
                }, source)
            end
        end,

        IsJobInAttack = function(job)
            for zoneName, attack in next, (Attacks) do
                if attack and (attack.attacker.name == job or attack.defender.name == job) then
                    return zoneName;
                end
            end
            return false;
        end,

        GetSide = function(attacker, job)
            return attacker == job and 'attacker' or 'defender';
        end,

        Entry = vec3(193.8536, -997.9973, -99.0001),
        MoneyToAdd = math.random(100000, 250000),
        Points = {
            teamKill = -3,
            kill = 3,
            start = 1,
            win = 0,
        },
        Time = {
            afterAttack = 3,
            gangwar = 20,
            overtime = 5,
            respawn = 5000,
        },
        Color = {
            r = 72, g = 167, b = 255
        },
        Permissions = {
            start = 2,
            players = 0,
            join = {
                ['pl'] = true,
                ['manager'] = true,
            },
            stop = {
                ['pl'] = true,
                ['manager'] = true,
            },
            block = {
                ['pl'] = true,
                ['manager'] = true,
            }
        },
        Blacklist = {
            Weapons = {
                normal = {
                    'WEAPON_MARKSMANRIFLE',
                    'WEAPON_MARKSMANRIFLE_MK2'
                },
                vehicle = {
                    'WEAPON_MICROSMG',
                    'WEAPON_MARKSMANRIFLE',
                    'WEAPON_MARKSMANRIFLE_MK2'
                },
            },
            Jobs = {
                ['unemployed'] = true,
                ['fib'] = false,
            }
        },
        vehicles = {
            { name = 'bf400',   label = 'BF 400' },
            { name = 'drafter', label = 'Drafter' },
            { name = 'vstr',    label = 'VSTR' },
            { name = 'komoda',  label = 'Komoda' },
        },
        Zones = {
            {
                name = 'Mirror Park',
                center = vec3(829.63, -217.74, 72.74),
                radius = vec3(140.0, 140.0, 140.0),
                scale = 140,
                attacker = {
                    spawn = vec3(1084.53, -346.54, 67.24),
                    vehicleSpawn = vec4(1067.77, -346.46, 67.08, 64.14)
                },
                defender = {
                    spawn = vec3(631.8, -35.78, 79.08),
                    vehicleSpawn = vec4(635.24, -81.83, 74.66, 226.83)
                }
            },
            {
                name = 'Skate Park',
                center = vec3(-914.51, -749.83, 19.85),
                radius = vec3(140.0, 140.0, 140.0),
                scale = 140,
                attacker = {
                    spawn = vec3(-833.59, -958.16, 15.48),
                    vehicleSpawn = vec4(-846.9, -953.37, 15.59, 35.52)
                },
                defender = {
                    spawn = vec3(-962.13, -506.59, 36.99),
                    vehicleSpawn = vec4(-940.17, -490.51, 36.72, 212.44)
                }
            },
            {
                name = 'Pipeline',
                center = vec3(-2189.55, -416.08, 13.12),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(-1873.27, -488.11, 25.33),
                    vehicleSpawn = vec4(-1866.2, -477.86, 25.41, 50.88)
                },
                defender = {
                    spawn = vec3(-2489.84, -207.82, 18.13),
                    vehicleSpawn = vec4(-2486.86, -221.14, 17.81, 244.36)
                }
            },
            {
                name = 'Baustelle',
                center = vec3(1007.46, 2408.82, 51.44),
                radius = vec3(180.0, 180.0, 180.0),
                scale = 180,
                attacker = {
                    spawn = vec3(776.99, 2278.73, 49.0),
                    vehicleSpawn = vec4(787.12, 2289.54, 48.72, 343.75)
                },
                defender = {
                    spawn = vec3(1314.17, 2367.02, 74.83),
                    vehicleSpawn = vec4(1303.83, 2368.02, 74.01, 80.91)
                }
            },
            {
                name = 'Theater',
                center = vec3(667.25, 645.24, 129.11),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(446.73, 869.78, 197.92),
                    vehicleSpawn = vec4(454.86, 873.7, 198.11, 266.48)
                },
                defender = {
                    spawn = vec3(1026.84, 501.88, 96.96),
                    vehicleSpawn = vec4(1015.69, 500.75, 97.73, 54.84)
                }
            },
            -- {
            --   name = 'Observatorium',
            --   center = vec3(-412.85, 1170.84, 325.83),
            --   radius = vec3(200.0, 200.0, 200.0),
            --   scale = 200,
            --   attacker = {
            --     spawn = vec3(-658.68, 1319.31, 285.1),
            --     vehicleSpawn = vec4(-655.8, 1335.12, 288.02, 326.96)
            --   },
            --   defender = {
            --     spawn = vec3(-183.47, 1364.25, 296.52),
            --     vehicleSpawn = vec4(-178.29, 1352.73, 298.27, 177.17)
            --   }
            -- },
            {
                name = 'Pier',
                center = vec3(-1681.50, -1046.29, 13.13),
                radius = vec3(250.0, 250.0, 250.0),
                scale = 250,
                attacker = {
                    spawn = vec3(-1398.92, -1277.41, 4.46),
                    vehicleSpawn = vec4(-1401.49, -1266.71, 4.48, 33.82)
                },
                defender = {
                    spawn = vec3(-1455.11, -788.15, 23.89),
                    vehicleSpawn = vec4(-1467.04, -789.64, 23.81, 144.04)
                }
            },
            {
                name = 'Hafen',
                center = vec3(1020.51, -3088.07, 5.90),
                radius = vec3(300.0, 300.0, 300.0),
                scale = 300,
                attacker = {
                    spawn = vec3(733.24, -2824.36, 6.25),
                    vehicleSpawn = vec4(739.21, -2837.86, 6.19, 174.08)
                },
                defender = {
                    spawn = vec3(712.56, -3248.69, 19.21),
                    vehicleSpawn = vec4(720.68, -3260.03, 19.12, 213.28)
                }
            },
            {
                name = 'Pacific Bluffs',
                center = vec3(-2247.5681, 269.4859, 174.6095),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(-2232.92, 582.04, 167.2),
                    vehicleSpawn = vec4(-2245.37, 574.4, 168.63, 120.38)
                },
                defender = {
                    spawn = vec3(-2029.08, 186.93, 112.49),
                    vehicleSpawn = vec4(-2042.28, 193.46, 114.69, 51.99)
                }
            },
            {
                name = 'Elysian Island',
                center = vec3(223.1466, -3114.6755, 5.7903),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(264.36, -2803.21, 6.02),
                    vehicleSpawn = vec4(249.09, -2810.02, 6.02, 154.32)
                },
                defender = {
                    spawn = vec3(229.62, -2759.91, 16.28),
                    vehicleSpawn = vec4(215.65, -2765.08, 15.94, 141.33)
                }
            },
            {
                name = 'Vinewood Hills',
                center = vec3(208.4626, 1168.0820, 227.0049),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(156.56, 1470.07, 239.54),
                    vehicleSpawn = vec4(167.91, 1461.48, 239.71, 224.86)
                },
                defender = {
                    spawn = vec3(298.9, 912.3, 203.85),
                    vehicleSpawn = vec4(311.03, 922.95, 205.17, 356.73)
                }
            },
            {
                name = 'Vespucci',
                center = vec3(-1350.5270, -1434.3119, 4.3240),
                radius = vec3(180.0, 180.0, 180.0),
                scale = 180,
                attacker = {
                    spawn = vec3(-1408.96, -1150.64, 2.79),
                    vehicleSpawn = vec4(-1417.89, -1160.66, 2.46, 171.94)
                },
                defender = {
                    spawn = vec3(-1267.94, -1692.67, 4.29),
                    vehicleSpawn = vec4(-1270.0, -1683.15, 4.47, 32.74)
                }
            },
            {
                name = 'Friedhof',
                center = vec3(-1729.2560, -193.0799, 58.5013),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(-1697.4792, -401.0559, 46.5715),
                    vehicleSpawn = vec4(-1708.3672, -398.0122, 46.2222, 321.6821)
                },
                defender = {
                    spawn = vec3(-1740.4059, 20.2556, 66.8924),
                    vehicleSpawn = vec4(-1729.4784, 19.1371, 66.5224, 224.7259)
                }
            },
            {
                name = 'Imagination',
                center = vec3(-1100.4403, -1051.9709, 2.0856),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(-1155.5997, -851.7313, 14.2620),
                    vehicleSpawn = vec4(-1165.4899, -855.2218, 14.1896, 209.9230)

                },
                defender = {
                    spawn = vec3(-966.6797, -1208.5674, 5.2530),
                    vehicleSpawn = vec4(-955.4167, -1211.0858, 5.2966, 26.8130)

                }
            },
            {
                name = 'Richman',
                center = vec3(-1645.4962, 216.8655, 60.6411),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(-1916.37, 221.97, 84.65),
                    vehicleSpawn = vec4(-1916.21, 193.58, 84.07, 217.41)

                },
                defender = {
                    spawn = vec3(-1322.33, 402.47, 69.45),
                    vehicleSpawn = vec4(-1333.65, 396.43, 67.79, 118.12)

                }
            },
            {
                name = 'Military Base',
                center = vec3(-2066.05, 3139.77, 32.81),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(-1756.81, 3024.9, 32.81),
                    vehicleSpawn = vec4(-1771.62, 3026.83, 32.81, 72.89)

                },
                defender = {
                    spawn = vec3(-2495.22, 3208.29, 32.85),
                    vehicleSpawn = vec4(-2474.41, 3210.53, 32.83, 243.01)

                }
            },
            {
                name = 'Sandy Shores',
                center = vec3(1950.68, 4946.64, 44.49),
                radius = vec3(220.0, 200.0, 200.0),
                scale = 220,
                attacker = {
                    spawn = vec3(2203.36, 4826.76, 44.83),
                    vehicleSpawn = vec4(2202.37, 4841.91, 44.87, 2.23)

                },
                defender = {
                    spawn = vec3(1661.32, 4852.57, 41.88),
                    vehicleSpawn = vec4(1668.03, 4869.83, 42.07, 6.73)

                }
            },
            {
                name = 'Paleto Bay',
                center = vec3(-193.37, 6221.46, 31.48),
                radius = vec3(250.0, 250.0, 250.0),
                scale = 250,
                attacker = {
                    spawn = vec3(-446.7, 5895.73, 32.93),
                    vehicleSpawn = vec4(-443.44, 5909.78, 32.74, 322.01)

                },
                defender = {
                    spawn = vec3(158.37, 6550.49, 31.89),
                    vehicleSpawn = vec4(150.6, 6533.63, 31.75, 132.04)

                }
            },
            {
                name = 'Sandy Shores Flughafen',
                center = vec3(1381.2, 3129.63, 40.82),
                radius = vec3(250.0, 250.0, 250.0),
                scale = 250,
                attacker = {
                    spawn = vec3(1058.47, 3020.72, 41.93),
                    vehicleSpawn = vec4(1069.15, 3021.96, 41.52, 286.31)

                },
                defender = {
                    spawn = vec3(1704.86, 3272.64, 41.15),
                    vehicleSpawn = vec4(1696.69, 3257.34, 40.92, 104.7)

                }
            },
            {
                name = 'Golfplatz',
                center = vec3(-1172.51, 45.01, 52.5),
                radius = vec3(250.0, 250.0, 250.0),
                scale = 250,
                attacker = {
                    spawn = vec3(-935.16, -73.85, 39.3),
                    vehicleSpawn = vec4(-945.18, -74.89, 40.01, 101.82)

                },
                defender = {
                    spawn = vec3(-1386.85, 145.08, 56.37),
                    vehicleSpawn = vec4(-1375.01, 144.26, 56.13, 272.25)

                }
            },
            {
                name = 'Staatsbank',
                center = vec3(235.23, 216.93, 106.29),
                radius = vec3(200.0, 200.0, 200.0),
                scale = 200,
                attacker = {
                    spawn = vec3(32.8753, 281.9276, 109.6093),
                    vehicleSpawn = vec4(26.2747, 255.6820, 109.6128, 247.7379)

                },
                defender = {
                    spawn = vec3(436.7472, 132.2961, 100.2649),
                    vehicleSpawn = vec4(425.0388, 114.0287, 100.5581, 70.9626)

                }
            },
            {
                name = 'Liveinvader',
                center = vec3(-1081.2, -261.6, 37.8),
                radius = vec3(150.0, 150.0, 150.0),
                scale = 150,
                attacker = {
                    spawn = vec3(-929.6648, -204.0475, 38.0102),
                    vehicleSpawn = vec4(-934.5371, -194.9573, 37.8337, 111.5798)

                },
                defender = {
                    spawn = vec3(-1231.2031, -330.1570, 37.3765),
                    vehicleSpawn = vec4(-1234.3124, -320.4471, 37.4636, 295.4007)

                }
            },
            {
                name = 'Raffinerie',
                center = vec3(1539.7, -2093.04, 77.09),
                radius = vec3(280.0, 280.0, 280.0),
                scale = 280,
                attacker = {
                    spawn = vec3(1480.94, -2434.41, 66.17),
                    vehicleSpawn = vec4(1473.32, -2420.45, 66.19, 61.6)
                },
                defender = {
                    spawn = vec3(1693.53, -1746.86, 112.31),
                    vehicleSpawn = vec4(1689.75, -1762.05, 112.2, 190.62)
                }
            },


            {
                name = 'Kiez',
                center = vec3(1156.57, -524.84, 64.74),
                radius = vec3(300.0, 300.0, 300.0),
                scale = 300,
                attacker = {
                    spawn = vec3(912.35, -240.22, 69.32),
                    vehicleSpawn = vec4(914.98, -255.83, 68.91, 232.25)
                },
                defender = {
                    spawn = vec3(1155.7, -921.28, 50.55),
                    vehicleSpawn = vec4(1166.41, -906.25, 51.63, 355.46)
                }
            }
        },
    },

    matches = {
        ["1"] = {
            map = "dach",
            middle = vec3(102.9280, -870.9976, 137.9536),

            positions = {
                [1] = vec4(82.2780, -864.6495, 134.7699, 245.0995),
                [2] = vec4(122.6523, -879.3107, 134.7699, 74.1828)
            }

        },
        ["2"] = {
            map = "beach",
            middle = vec3(-657.0495, -1095.5046, 58.3561),

            positions = {
                [1] = vec4(-651.2300, -1080.4603, 58.3559, 155.7751),
                [2] = vec4(-659.6916, -1109.0453, 58.3562, 342.4716)
            }

        },
        ["3"] = {
            map = "vinewood",
            middle = vec3(-45.0087, 163.9234, 145.1703),

            positions = {
                [1] = vec4(-54.9898, 178.7487, 141.1790, 217.4485),
                [2] = vec4(-35.5968, 151.1365, 141.1790, 39.6665)
            }

        },
        ["4"] = {
            map = "eclipse",
            middle = vec3(-752.0142, 257.8062, 137.6243),

            positions = {
                [1] = vec4(-779.3641, 251.5103, 132.2887, 280.6208),
                [2] = vec4(-726.2107, 264.3082, 132.3138, 101.6967)
            }
        },
    },

    MoneyDrops = {
        isActive    = false,
        win         = math.random(500, 1000),
        currentZone = {},

        zones       = {
            vec3(-2299.4761, 3151.1411, 32.8186),
            vec3(-2314.3928, 3191.9937, 32.8915),
            vec3(-2322.6846, 3227.6211, 32.8274),
            vec3(-2304.1287, 3262.0986, 32.8181),
            vec3(-2286.3635, 3289.5513, 32.8269),
            vec3(-2248.4941, 3316.7434, 32.8220),
            vec3(-2220.8713, 3299.6541, 32.8123),
            vec3(-2197.4834, 3285.7725, 32.6936),
            vec3(-2207.9307, 3266.8694, 32.6656),
            vec3(-2179.3167, 3239.6309, 32.3249),
            vec3(-2150.7441, 3217.2617, 32.8209),
            vec3(-2173.6492, 3188.5386, 32.6654),
            vec3(-2193.9897, 3163.0745, 32.6341),
            vec3(-2233.3655, 3142.1426, 32.8033),
            vec3(-2240.1294, 3180.9644, 32.8078),
            vec3(-439.2420, 1168.0873, 325.9047),
            vec3(-379.2651, 1171.6322, 325.7304),
            vec3(-396.3254, 1234.6985, 325.6411),
            vec(235.9090, -612.6556, 41.7182),
            vec(303.4941, -469.8945, 43.3401),
            vec(218.5316, -566.2890, 43.8718),
            vec(-3.5521, -1786.2980, 28.5053),
            vec(48.2136, -1685.9225, 29.2649),
            vec(6.4329, -1651.7501, 29.2191),
            vec(-59.0506, -1666.0396, 29.2161),
        }
    },

    killzone = {
        entry = vec3(-2255.4224, 3218.8066, 32.8102),

        dimension = {
            entry = 2,
            inZone = 3,
        },

        zones = {
            {
                name = "Groove Tankstelle",

                position = vec3(-66.0453, -1763.6926, 29.1910),
                radius = 50.0,

                spawns = {
                    vec4(-44.6166, -1814.1843, 26.6729, 49.2115),
                    vec4(-10.8747, -1767.7386, 29.0546, 60.2168),
                    vec4(-43.9775, -1711.5240, 29.3423, 149.9075),
                    vec4(-102.0226, -1717.6279, 29.6094, 204.9852),
                    vec4(-124.2247, -1763.5072, 29.7173, 275.2483)
                },
            },
            {
                name = "Paleto Bay",

                position = vec3(-12.8179, 6219.4375, 31.5645),
                radius = 60.0,

                spawns = {
                    vec4(48.7606, 6242.0366, 31.9014, 103.2885),
                    vec4(-45.5575, 6162.8511, 31.4547, 316.2299),
                    vec4(-62.8722, 6179.1802, 30.6636, 323.8577),
                    vec4(-75.1429, 6205.0610, 31.5855, 305.6678)
                },
            },
            {
                name = "Baustelle",

                position = vec3(1051.5402, 2252.1345, 52.3724),
                radius = 60.0,

                spawns = {
                    vec4(990.8347, 2226.0325, 49.2088, 287.0607),
                    vec4(990.0876, 2274.3977, 48.7897, 246.1796),
                    vec4(1108.7749, 2223.0317, 50.1461, 55.6474),
                    vec4(1111.3438, 2272.8877, 49.3539, 116.9315)
                },
            },
            {
                name = "Parkhaus",

                position = vec3(366.9937, -1680.6188, 30.8610),
                radius = 50.0,

                spawns = {
                    vec4(351.9242, -1732.8270, 29.3860, 17.9273),
                    vec4(318.9478, -1707.1298, 29.3479, 294.3417),
                    vec4(417.4991, -1660.4736, 29.2695, 114.8700),
                    vec4(363.0594, -1626.1350, 32.5325, 211.6002)
                },
            }
        }
    },

    ffa = {
        ["Marktplatz"] = {
            max = 12,

            middle = vec3(383.8309, -339.3008, 46.8099),
            size = 100.0,

            spawns = {
                vec3(353.0579, -359.4925, 46.22213),
                vec3(359.9211, -324.8547, 46.68782),
                vec3(372.0424, -308.9507, 46.72132),
                vec3(400.507, -312.1168, 49.88263),
                vec3(431.7586, -326.8474, 47.22244),
                vec3(420.2935, -357.1806, 47.21375),
                vec3(398.003, -373.2784, 46.82435),
                vec3(370.0265, -380.4681, 46.47663),
            }
        },
        ["Prison"] = {
            max = 10,

            middle = vec3(1641.7299, 2619.4443, 46.1811),
            size = 70.0,

            spawns = {
                vec3(1661.8702, 2659.7847, 45.5649),
                vec3(1677.6992, 2628.5049, 45.5649),
                vec3(1645.1754, 2596.5596, 45.5649),
                vec3(1623.0673, 2618.8799, 45.5649),
                vec3(1612.8256, 2602.1392, 45.5649),
                vec3(1583.5216, 2614.1072, 45.5649),
                vec3(1598.6885, 2643.7791, 45.5649),
                vec3(1611.4855, 2659.4561, 45.5649),
                vec3(1629.2227, 2586.4910, 45.5649),
                vec3(1621.6802, 2573.1477, 45.5649),
                vec3(1633.0297, 2559.5354, 45.5649),
            }
        },
        ["Hafen"] = {
            max = 15,

            middle = vec3(-82.9211, -2448.6230, 6.0113),
            size = 150.0,

            spawns = {
                vec3(-143.1674, -2456.1074, 6.0196),
                vec3(-93.9901, -2506.6541, 6.0027),
                vec3(-106.4312, -2467.4128, 6.0203),
                vec3(-39.1758, -2476.6316, 6.0068),
                vec3(-11.7290, -2486.5950, 6.0068),
                vec3(-2.0797, -2448.6941, 6.0068),
                vec3(0.3356, -2496.0720, 6.0068),
                vec3(13.6576, -2453.1765, 6.0068),
                vec3(22.4869, -2464.2937, 6.0068),
                vec3(-10.5871, -2436.4326, 6.0068),
                vec3(-52.2496, -2450.3611, 6.0030),
                vec3(-67.3073, -2437.9719, 7.2358),
                vec3(-76.3281, -2410.5237, 6.0000),
                vec3(-85.4377, -2410.5107, 6.0000),
                vec3(-101.6630, -2410.3230, 6.0000),
                vec3(-80.1176, -2464.2703, 6.0240)
            }
        },
        ["Schleife"] = {
            max = 15,

            middle = vec3(-103.2774, 904.6009, 236.3599),
            size = 160.0,

            spawns = {
                vec3(-94.7433, 880.9702, 236.4471),
                vec3(-102.2676, 902.3014, 236.3895),
                vec3(-44.1827, 901.3073, 231.5084),
                vec3(-104.7333, 823.2883, 235.7250),
                vec3(-83.7811, 842.4122, 235.6309),
                vec3(-64.1924, 874.1179, 235.6218),
                vec3(-56.1846, 866.3214, 232.4220),
                vec3(-45.0599, 829.9057, 235.7226),
                vec3(-130.2345, 877.1876, 233.8588),
                vec3(-167.9890, 860.0359, 232.2335),
                vec3(-184.1361, 900.6857, 233.4648),
                vec3(-161.2925, 929.1936, 235.6559),
                vec3(-167.9548, 970.8956, 236.7219),
                vec3(-192.9758, 986.5292, 231.7335),
                vec3(-187.1902, 1016.9282, 232.1340),
                vec3(-155.0874, 993.8763, 234.9073),
                vec3(-130.8235, 982.0017, 235.8157),
                vec3(-134.0551, 1021.5624, 236.0120),
                vec3(-89.2978, 1011.6658, 235.2285),
                vec3(-52.4193, 974.6852, 232.8674),
                vec3(-87.7366, 942.2640, 233.0284),
            }
        },

        ["LsSuply"] = {
            max = 15,

            middle = vec3(1200.4642, -1330.7284, 35.2244),
            size = 100.0,

            spawns = {
                vec3(1148.3512, -1358.3193, 34.6687),
                vec3(1154.2737, -1331.8851, 34.7040),
                vec3(1213.1866, -1279.9071, 35.2259),
                vec3(1193.2052, -1300.0729, 35.0238),
                vec3(1188.4208, -1391.5509, 35.0752),
                vec3(1169.4176, -1381.5398, 34.7902),
                vec3(1228.99, -1301.79, 35.07),
                vec3(1221.47, -1364.48, 35.16),
                vec3(1215.28, -1365.15, 35.21),
                vec3(1128.47, -1299.99, 34.73),
                vec3(1166.71, -1249.38, 34.58),
                vec3(1175.32, -1275.49, 34.78),
            }
        }
    },

    gungameLevels = {
        [1] = "WEAPON_SNSPISTOL",
        [2] = "WEAPON_SNSPISTOL_MK2",
        [3] = "WEAPON_VINTAGEPISTOL",
        [4] = "WEAPON_COMBATPISTOL",
        [5] = "WEAPON_HEAVYPISTOL",
        [6] = "WEAPON_PISTOL",
        [7] = "WEAPON_PISTOL_MK2",
        [8] = "WEAPON_PISTOL50",
        [9] = "WEAPON_GADGETPISTOL",
    },

    gungame = {
        ["Marktplatz"] = {
            max = 12,

            middle = vec3(383.8309, -339.3008, 46.8099),
            size = 100.0,

            spawns = {
                vec3(353.0579, -359.4925, 46.22213),
                vec3(359.9211, -324.8547, 46.68782),
                vec3(372.0424, -308.9507, 46.72132),
                vec3(400.507, -312.1168, 49.88263),
                vec3(431.7586, -326.8474, 47.22244),
                vec3(420.2935, -357.1806, 47.21375),
                vec3(398.003, -373.2784, 46.82435),
                vec3(370.0265, -380.4681, 46.47663),
            }
        },
        ["Prison"] = {
            max = 10,

            middle = vec3(1641.7299, 2619.4443, 46.1811),
            size = 70.0,

            spawns = {
                vec3(1661.8702, 2659.7847, 45.5649),
                vec3(1677.6992, 2628.5049, 45.5649),
                vec3(1645.1754, 2596.5596, 45.5649),
                vec3(1623.0673, 2618.8799, 45.5649),
                vec3(1612.8256, 2602.1392, 45.5649),
                vec3(1583.5216, 2614.1072, 45.5649),
                vec3(1598.6885, 2643.7791, 45.5649),
                vec3(1611.4855, 2659.4561, 45.5649),
                vec3(1629.2227, 2586.4910, 45.5649),
                vec3(1621.6802, 2573.1477, 45.5649),
                vec3(1633.0297, 2559.5354, 45.5649),
            }
        },
        ["Hafen"] = {
            max = 15,

            middle = vec3(-82.9211, -2448.6230, 6.0113),
            size = 150.0,

            spawns = {
                vec3(-143.1674, -2456.1074, 6.0196),
                vec3(-93.9901, -2506.6541, 6.0027),
                vec3(-106.4312, -2467.4128, 6.0203),
                vec3(-39.1758, -2476.6316, 6.0068),
                vec3(-11.7290, -2486.5950, 6.0068),
                vec3(-2.0797, -2448.6941, 6.0068),
                vec3(0.3356, -2496.0720, 6.0068),
                vec3(13.6576, -2453.1765, 6.0068),
                vec3(22.4869, -2464.2937, 6.0068),
                vec3(-10.5871, -2436.4326, 6.0068),
                vec3(-52.2496, -2450.3611, 6.0030),
                vec3(-67.3073, -2437.9719, 7.2358),
                vec3(-76.3281, -2410.5237, 6.0000),
                vec3(-85.4377, -2410.5107, 6.0000),
                vec3(-101.6630, -2410.3230, 6.0000),
                vec3(-80.1176, -2464.2703, 6.0240)
            }
        },
        ["Schleife"] = {
            max = 15,

            middle = vec3(-103.2774, 904.6009, 236.3599),
            size = 160.0,

            spawns = {
                vec3(-94.7433, 880.9702, 236.4471),
                vec3(-102.2676, 902.3014, 236.3895),
                vec3(-44.1827, 901.3073, 231.5084),
                vec3(-104.7333, 823.2883, 235.7250),
                vec3(-83.7811, 842.4122, 235.6309),
                vec3(-64.1924, 874.1179, 235.6218),
                vec3(-56.1846, 866.3214, 232.4220),
                vec3(-45.0599, 829.9057, 235.7226),
                vec3(-130.2345, 877.1876, 233.8588),
                vec3(-167.9890, 860.0359, 232.2335),
                vec3(-184.1361, 900.6857, 233.4648),
                vec3(-161.2925, 929.1936, 235.6559),
                vec3(-167.9548, 970.8956, 236.7219),
                vec3(-192.9758, 986.5292, 231.7335),
                vec3(-187.1902, 1016.9282, 232.1340),
                vec3(-155.0874, 993.8763, 234.9073),
                vec3(-130.8235, 982.0017, 235.8157),
                vec3(-134.0551, 1021.5624, 236.0120),
                vec3(-89.2978, 1011.6658, 235.2285),
                vec3(-52.4193, 974.6852, 232.8674),
                vec3(-87.7366, 942.2640, 233.0284),
            }
        },

        ["LsSuply"] = {
            max = 15,

            middle = vec3(1200.4642, -1330.7284, 35.2244),
            size = 100.0,

            spawns = {
                vec3(1148.3512, -1358.3193, 34.6687),
                vec3(1154.2737, -1331.8851, 34.7040),
                vec3(1213.1866, -1279.9071, 35.2259),
                vec3(1193.2052, -1300.0729, 35.0238),
                vec3(1188.4208, -1391.5509, 35.0752),
                vec3(1169.4176, -1381.5398, 34.7902),
                vec3(1228.99, -1301.79, 35.07),
                vec3(1221.47, -1364.48, 35.16),
                vec3(1215.28, -1365.15, 35.21),
                vec3(1128.47, -1299.99, 34.73),
                vec3(1166.71, -1249.38, 34.58),
                vec3(1175.32, -1275.49, 34.78),
            }
        }
    },
}

Config.admin = {
    announce = {
        {
            name = "Event Close Warnung",
            label = "Ihr habt noch 2 Minuten Zeit um euch zum Event zu telepotieren!"
        },
        {
            name = "Alle Aufstellen",
            label = "Stellt euch alle in einer reihe auf! Wer redet oder schießt bekommt ein Event Ausschluss!"
        },
        {
            name = "Mate suchen",
            label = "Sucht euch einen Mate und stellt euch auf ihr habt 2 Minuten Zeit!"
        },
        {
            name = "Copy Outfit info",
            label = "Ihr könnt wenn ihr y Gedrückt hällt das Outfit vom Spieler Gegenüber Kopieren"
        },
        {
            name = "Reden oder schießen = EA",
            label = "Wer redet oder schießt bekommt ein Event Ausschluss!"
        }
    },

    weaponstorefund = {
        { name = "WEAPON_PISTOL",        label = "Pistole" },
        { name = "WEAPON_PISTOL_MK2",    label = "Pistole MK2" },
        { name = "WEAPON_PISTOL50",      label = "Pistole .50" },
        { name = "WEAPON_COMBATPISTOL",  label = "Kampfpistole" },
        { name = "WEAPON_SNSPISTOL",     label = "SNS Pistole" },
        { name = "WEAPON_HEAVYPISTOL",   label = "Schwere Pistole" },
        { name = "WEAPON_VINTAGEPISTOL", label = "Vintage Pistole" },
        { name = "WEAPON_BAT",           label = "Baseball Schläger" },
        { name = "WEAPON_FLASHLIGHT",    label = "Taschenlampe" },
        { name = "WEAPON_POOLCUE",       label = "Billardstock" },
        { name = "WEAPON_KNIFE",         label = "Messer" },
        { name = "WEAPON_NIGHTSTICK",    label = "Schlagstock" },
        { name = "WEAPON_GOLFCLUB",      label = "Golf Schläger" },
        { name = "WEAPON_CROWBAR",       label = "Brechstange" },
        { name = "WEAPON_STUNGUN",       label = "Elektroschocker" },
        { name = "WEAPON_FLAREGUN",      label = "Leuchtpistole" },
        { name = "WEAPON_KNUCKLE",       label = "Schlagring" },
        { name = "WEAPON_MACHETE",       label = "Machete" },
        { name = "WEAPON_SWITCHBLADE",   label = "Springmesser" },
        { name = "WEAPON_WRENCH",        label = "Schraubenschlüssel" },
        { name = "WEAPON_BATTLEAXE",     label = "Kampfaxt" },
        { name = "WEAPON_HAMMER",        label = "Hammer" },
        { name = "WEAPON_KATANA",        label = "Katana" },
        { name = "WEAPON_KHAMMER",       label = "Axe Of Kratos" },
        { name = "WEAPON_BBAT",          label = "Crazy Bat" },
        { name = "WEAPON_CANDYAXE",      label = "Candy Pickaxe" },
        { name = "WEAPON_DHAMMER",       label = "Deadric Hammer" },
        { name = "WEAPON_RAINBOWSMASH",  label = "Rainbow Pickaxe" },
        { name = "WEAPON_DIA",           label = "Diamond Pickaxe" },
        { name = "WEAPON_DAXE",          label = "Katana" },
    },

    itemstorefund = {
        { name = "xpboost",    label = "XP Boost" },
        { name = "moneyboost", label = "Money Boost" },
        { name = "token",      label = "Tokens" },
    },

    prefix = {
        ["user"]        = "~w~",
        ["support"]     = "~g~",
        ["mod"]         = "~b~",
        ["admin"]       = "~o~",
        ["sadmin"]      = "~p~",
        ["teamleitung"] = "~u~",
        ["manager"]     = "~r~",
        ["pl"]          = "~r~",
    },

    fastTeleports = {
        [1] = {
            name = "Army Base - Dach",
            coords = vector3(-2130.2666, 3267.3921, 57.5109),
        },

        [2] = {
            name = "MD - Dach",
            coords = vector3(315.4311, -575.4240, 94.4818),
        },

        [3] = {
            name = "Observatorium",
            coords = vector3(-551.2700, 1383.1531, 331.9551),
        },
    },

    perms = {
        ["user"]        = {
            ["vehicle"] = false,
        },
        ["support"]     = {
            ["vehicle"] = false,
        },
        ["mod"]         = {
            ["vehicle"] = false,
        },
        ["admin"]       = {
            ["vehicle"] = false,
        },
        ["sadmin"]      = {
            ["vehicle"] = false,
        },
        ["teamleitung"] = {
            ["vehicle"] = true,
        },
        ["manager"]     = {
            ["vehicle"] = true,
        },
        ["pl"]          = {
            ["vehicle"] = true,
        },
    },

    KeyboardInput = function(entryTitle, textEntry, inputText, maxLength)
        AddTextEntry(entryTitle, textEntry)
        DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
        blockinput = true
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Wait(0)
        end
        if UpdateOnscreenKeyboard() ~= 2 then
            local result = GetOnscreenKeyboardResult()
            Wait(500)
            blockinput = false
            return result
        else
            Wait(500)
            blockinput = false
            return nil
        end
    end
}

exports('getLevel', Config.Battlepass.GetLevel);
exports("CoreNotify", Config.HUD.Notify);
exports("CoreAnnounce", Config.HUD.announce);
exports('getLiga', Config.HUD.getLiga);
