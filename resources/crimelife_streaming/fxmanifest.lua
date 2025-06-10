shared_script '@crimelife_ac/shared_fg-obfuscated.lua'
shared_script '@crimelife_ac/ai_module_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"

client_script 'client.lua'

files {
    "data/handling.meta",
    "data/weaponcomponents/*.meta",
    "data/[WEAPONS]/**",
    "data/[CARS]/**",
    'data/peddamage.xml',

    -- SYNC --
    "sync/WeaponsMk2/*.meta",
    "sync/Weapons/*.meta",

    -- Clothing
    'pedalternatevariations.meta', -- Allg. clothing import

    'mp_m_freemode_01_mp_m_shiro_shop.meta',
    'mp_m_freemode_01_tuzak_shop.meta',
    'mp_m_freemode_01_mp_m_trikot_shop.meta',
    'mp_m_freemode_01_mp_m_tuzakpolo_shop.meta',
    'mp_m_freemode_01_mp_m_pasha_lcl_shop.meta'
}

data_file "HANDLING_FILE" "data/handling.meta"
data_file "HANDLING_FILE" "data/[CARS]/**/handling.meta"
data_file "VEHICLE_METADATA_FILE" "data/[CARS]/**/vehicles.meta"
data_file "CARCOLS_FILE" "data/[CARS]/**/carcols.meta"
data_file "VEHICLE_VARIATION_FILE" "data/[CARS]/**/carvariations.meta"
data_file "VEHICLE_LAYOUTS_FILE" "data/[CARS]/**/vehiclelayouts.meta"
data_file "VEHICLE_SHOP_DLC_FILE" "data/[CARS]/**/shop_vehicle.meta"

data_file "WEAPONCOMPONENTSINFO_FILE" "data/[WEAPONS]/**/weaponcomponents.meta"
data_file "WEAPON_METADATA_FILE" "data/[WEAPONS]/**/weaponarchetypes.meta"
data_file "WEAPON_ANIMATIONS_FILE" "data/[WEAPONS]/**/weaponanimations.meta"
data_file "PED_PERSONALITY_FILE" "data/[WEAPONS]/**/pedpersonality.meta"
data_file "WEAPONINFO_FILE" "data/[WEAPONS]/**/weapons.meta"

data_file 'WEAPONCOMPONENTSINFO_FILE' 'data/weaponcomponents/*.meta'
data_file 'PED_DAMAGE_OVERRIDE_FILE' 'data/peddamage.xml'


-- SYNC --
data_file "WEAPONINFO_FILE_PATCH" "sync/WeaponsMk2/*.meta"
data_file "WEAPONINFO_FILE_PATCH" "sync/Weapons/*.meta"

-- Clothing
data_file 'ALTERNATE_VARIATIONS_FILE' 'pedalternatevariations.meta' -- Allg. Clothing import

data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_m_freemode_01_mp_m_shiro_shop.meta' -- Shiro payed

data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_m_freemode_01_tuzak_shop.meta' -- Frak tuzak free

data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_m_freemode_01_mp_m_tuzakpolo_shop.meta' -- Frak tuzak free

data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_m_freemode_01_mp_m_trikot_shop.meta' -- idk free

data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_m_freemode_01_mp_m_pasha_lcl_shop.meta' -- Pasha x loco payed
data_file 'SHOP_PED_APPAREL_META_FILE' '01_mp_m_pasha_lcl_payed_shop.meta' -- Pasha x loco payed

data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_m_freemode_01_mp_m_colin_zotac_payed_shop.meta' -- Colin x Zotac payed
