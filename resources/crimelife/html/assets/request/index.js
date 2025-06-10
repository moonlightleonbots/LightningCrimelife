const Inventory = {
    weapon: "",
    item: "",
}

const Factions = {
    name: "",
}

// INVENTORY WEAPON SHARE
const Inventory_Weapon_Trash = (weapon) => {
    Inventory.weapon = weapon
    $('#Inventory_Weapon_Trash').fadeIn(125)
}

const Inventory_Weapon_Trash_Accept = () => {
    if (Inventory.weapon === "") return

    inventory('trash', Inventory.weapon)

    Inventory.weapon = ""
    $('#Inventory_Weapon_Trash').fadeOut(125)

    setTimeout(() => {
        requestInventory();
    }, 100);
}

const Inventory_Weapon_Trash_Deny = () => {
    Inventory.weapon = ""
    $('#Inventory_Weapon_Trash').fadeOut(125)

    $.post(
        `https://${GetParentResourceName()}/Notify`,
        JSON.stringify({
            title: "Fehler",
            text: `abgebrochen.`,
            time: 2500,
            type: "error",
        })
    );
}

// INVENTORY ITEM SHARE
const Inventory_Item_Share = (item) => {
    Inventory.item = item
    $('#Inventory_Item_Share').fadeIn(125)
}

const Inventory_Item_Share_Accept = () => {
    if (Inventory.item === "") return

    inventory('use-item', Inventory.item)

    Inventory.item = ""
    $('#Inventory_Item_Share').fadeOut(125)

    setTimeout(() => {
        requestInventory();
    }, 100);
}

const Inventory_Item_Share_Deny = () => {
    Inventory.item = ""
    $('#Inventory_Item_Share').fadeOut(125)

    $.post(
        `https://${GetParentResourceName()}/Notify`,
        JSON.stringify({
            title: "Fehler",
            text: `abgebrochen.`,
            time: 2500,
            type: "error",
        })
    );
}

// CLEAR GANGWAR    
const FactionCreator_ClearGangwar = () => {
    $('#FactionCreator_ClearGangwar').fadeIn(125)
}

const FactionCreator_ClearGangwar_Accept = () => {
    clearGW()
    $('#FactionCreator_ClearGangwar').fadeOut(125)
}

const FactionCreator_ClearGangwar_Deny = () => {
    $('#FactionCreator_ClearGangwar').fadeOut(125)

    $.post(
        `https://${GetParentResourceName()}/Notify`,
        JSON.stringify({
            title: "Fehler",
            text: `abgebrochen.`,
            time: 2500,
            type: "error",
        })
    );
}

// CLEAR GANG
const FactionCreator_ClearGang = (name) => {
    Factions.name = name
    $('#FactionCreator_ClearGang').fadeIn(125)
}

const FactionCreator_ClearGang_Accept = () => {
    if (Factions.name === "") return

    kickall(Factions.name)

    Factions.name = ""
    $('#FactionCreator_ClearGang').fadeOut(125)
}

const FactionCreator_ClearGang_Deny = () => {
    Factions.name = ""
    $('#FactionCreator_ClearGang').fadeOut(125)

    $.post(
        `https://${GetParentResourceName()}/Notify`,
        JSON.stringify({
            title: "Fehler",
            text: `abgebrochen.`,
            time: 2500,
            type: "error",
        })
    );
}

// DELETE GANG
const FactionCreator_DeleteGang = (name) => {
    Factions.name = name
    $('#FactionCreator_DeleteGang').fadeIn(125)
}

const FactionCreator_DeleteGang_Accept = () => {
    if (Factions.name === "") return

    deleteFaction(Factions.name)

    Factions.name = ""
    $('#FactionCreator_DeleteGang').fadeOut(125)
}

const FactionCreator_DeleteGang_Deny = () => {
    Factions.name = ""
    $('#FactionCreator_DeleteGang').fadeOut(125)

    $.post(
        `https://${GetParentResourceName()}/Notify`,
        JSON.stringify({
            title: "Fehler",
            text: `abgebrochen.`,
            time: 2500,
            type: "error",
        })
    );
}