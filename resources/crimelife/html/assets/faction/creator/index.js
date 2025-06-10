$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'faction:creator:open': {
                $('.creator-list').empty()
                $('.creator').fadeIn(125)

                for ([key, value] of Object.entries(i.factions)) {
                    $('.creator-list').append(`
                        <div class="creator-faction-item">
                            <span>${value.label}</span>
                            <span>${value.name}</span>
                            <button onclick="FactionCreator_ClearGang('${value.name}')">ALLE KICKEN</button>
                            <button onclick="FactionCreator_DeleteGang('${value.name}')">LÖSCHEN</button>
                        </div>
                    `)
                }
                break;
            }

            case 'InputCoords': {
                if (i.type = "vec3") {
                    $('#' + i.input).val(i.coords)
                } else if (i.type == "vec4") {
                    $('#' + i.input).val(i.coords)
                }
                break;
            }
        }
    });
});

function createFaction() {
    var name = $('#jobcreator-name').val();
    var label = $('#jobcreator-label').val();

    // Coords
    var respawn = $('#jobcreator-respawn').val();
    var spawnpoint = $('#jobcreator-spawnpoint').val();

    // Color
    var blip = $('#jobcreator-color-blip').val();
    var hexColor = $('#jobcreator-color').val();

    function hexToRgb(hex) {
        var bigint = parseInt(hex.slice(1), 16);
        var r = (bigint >> 16) & 255;
        var g = (bigint >> 8) & 255;
        var b = bigint & 255;
        return { r, g, b };
    }

    var { r, g, b } = hexToRgb(hexColor);

    if (name.length < 3 || label.length < 3) {
        $.post(
            `https://${GetParentResourceName()}/Notify`,
            JSON.stringify({
                title: "Fehler",
                text: `Name und Label müssen mindestens 3 Zeichen lang sein.`,
                time: 2500,
                type: "error",
            })
        );
        return;
    }

    if (respawn.length < 3 || spawnpoint.length < 3) {
        $.post(
            `https://${GetParentResourceName()}/Notify`,
            JSON.stringify({
                title: "Fehler",
                text: `Respawn und der Spawner müssen mindestens 3 Zeichen lang sein.`,
                time: 2500,
                type: "error",
            })
        );
        return;
    }

    function parsevec3(input) {
        const [x, y, z] = input.split(',').map(Number);
        return { x, y, z };
    }

    function parsevec4(input) {
        const [x, y, z, heading] = input.split(',').map(Number);
        return { x, y, z, heading };
    }

    $.post(`https://${GetParentResourceName()}/faction:create`, JSON.stringify({
        name: name,
        label: label,
        respawn: parsevec3(respawn),
        spawnpoint: parsevec4(spawnpoint),
        blipcolor: blip,
        color: {
            r: r,
            g: g,
            b: b,
        }
    }));

    setTimeout(() => {
        $('#jobcreator-name').val("");
        $('#jobcreator-label').val("");
        $('#jobcreator-respawn').val("");
        $('#jobcreator-garage').val("");
        $('#jobcreator-spawnpoint').val("");
        $('#jobcreator-color').val("#000000");
        $('#jobcreator-color-blip').val("");
    }, 500);
}

function setCurrentCoords(type, input) {
    $.post(`https://${GetParentResourceName()}/getCurrentCoords`, JSON.stringify({ type, input }))
}

function deleteFaction(name) {
    $.post(`https://${GetParentResourceName()}/faction:delete`, JSON.stringify(name));
}

function kickall(name) {
    $.post(`https://${GetParentResourceName()}/faction:kickall`, JSON.stringify(name));
}

function clearGW() {
    $.post(`https://${GetParentResourceName()}/faction:clearGW`);
}