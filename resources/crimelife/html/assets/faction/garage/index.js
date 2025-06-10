$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'openGarage': {
                $('.garage').fadeIn(125);

                $('.garageContainer').empty()

                for ([index, value] of Object.entries(i.vehicles)) {
                    $('.garageContainer').append(`
                            <div class="garageItem">
                                <div class="parkOut" onclick="parkOut('${value.name}')">
                                    <span>AUSPARKEN</span>
                                </div>
                                <div class="garageIMG">
                                    <img class="garageBGIMG" src="img/background/vehicleItem.png">
                                    <img class="garageVehicleIMG" src="img/background/vehicle.png">
                                    <span class="garageVehicleName">${value.label}</span>
                                </div>
                            </div>
                        `)
                }
                break;
            }
        }
    });
});

function parkOut(name) {
    $.post(`https://${GetParentResourceName()}/parkOut`, JSON.stringify(name))
    closeAll()
}