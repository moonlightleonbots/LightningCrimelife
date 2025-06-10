$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data

        switch (i.a) {
            case 'funk:toggle': {
                const settings = i.settings;

                $('.funk').fadeIn(125);
                $('.funk-join-header').empty();
                $('.funk-status').removeClass('deactive')
                $('.funk-status').removeClass('active')

                if (settings.toggle) {
                    $('.funk-status').addClass('active')
                } else {
                    $('.funk-status').addClass('deactive')
                }

                const funkHeader = $(
                    `<div>
                        <i class="fa-solid fa-radio"></i>
                        <span>KANAL:</span>
                        <span>${settings.number}</span>
                        <button class="${settings.toggle ? 'isin' : ''}" id="funkToggleButton"></button>
                        <input type="number" placeholder="Frequenz Eingeben" id="funkInput">
                    </div>`
                );

                $('.funk-join-header').append(funkHeader);

                $('#funkToggleButton').on('click', function () {
                    if (settings.toggle) {
                        funk_leave();
                    } else {
                        funk_join();
                    }
                });

                if (settings.sound) {
                    const funk_sound_check = document.getElementById("funk_sound_check");
                    funk_sound_check.checked = true;
                } else {
                    const funk_sound_check = document.getElementById("funk_sound_check");
                    funk_sound_check.checked = false;
                }

                const funk_animation_check = document.getElementById("funk-animation-item");
                const funk_animation_check2 = document.getElementById("funk-animation-item2");
                const funk_animation_check3 = document.getElementById("funk-animation-item3");
                const animation = settings.animation

                if (animation.animdict == "random@arrests" && animation.anim == "generic_radio_enter") {
                    funk_animation_check2.checked = false;
                    funk_animation_check3.checked = false;

                    funk_animation_check.checked = true;
                }

                if (animation.animdict == "anim@cop_mic_pose_002" && animation.anim == "chest_mic") {
                    funk_animation_check.checked = false;
                    funk_animation_check3.checked = false;

                    funk_animation_check2.checked = true;
                }

                if (animation.animdict == "cellphone@" && animation.anim == "cellphone_call_listen_base") {
                    funk_animation_check.checked = false;
                    funk_animation_check2.checked = false;

                    funk_animation_check3.checked = true;
                }
                break;
            }
        }
    });
});

function funk_leave() {
    playClick()
    $.post(`https://${GetParentResourceName()}/funk`, JSON.stringify({
        type: "leave",
    }))
}

function funk_join() {
    var input = $('#funkInput').val();

    if (input.length < 1) {
        $.post(`https://${GetParentResourceName()}/Notify`, JSON.stringify({
            title: "FEHLER",
            text: "Bitte gebe eine Frequenz ein.",
            type: "error",
            time: 5000
        }))
        return
    }

    $.post(`https://${GetParentResourceName()}/funk`, JSON.stringify({
        type: "join",
        input: input
    }))
}

function ChangeFunkSound(item, animdict, anim) {
    var funk_animation_check = document.getElementById("funk-animation-item");
    var funk_animation_check2 = document.getElementById("funk-animation-item2");
    var funk_animation_check3 = document.getElementById("funk-animation-item3");

    if (item == "funk-animation-item") {
        funk_animation_check2.checked = false;
        funk_animation_check3.checked = false;
    }

    if (item == "funk-animation-item2") {
        funk_animation_check.checked = false;
        funk_animation_check3.checked = false;
    }

    if (item == "funk-animation-item3") {
        funk_animation_check.checked = false;
        funk_animation_check2.checked = false;
    }

    playClick();

    if (event.target.checked) {
        $.post(`https://${GetParentResourceName()}/changeFunkAnimation`, JSON.stringify({
            animdict: animdict,
            anim: anim,
        }));
    } else {
        $.post(`https://${GetParentResourceName()}/changeFunkAnimation`, JSON.stringify({
            animdict: animdict,
            anim: anim,
        }));
    }
}

function FunkSoundToggle() {
    playClick();

    if (event.target.checked) {
        $.post(`https://${GetParentResourceName()}/FunkSoundToggle`, JSON.stringify(true));
    } else {
        $.post(`https://${GetParentResourceName()}/FunkSoundToggle`, JSON.stringify(false));
    }
    
}