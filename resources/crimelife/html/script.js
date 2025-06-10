inSpawn = false
inEventRules = false
firstCam = false
canExit = false

function playClick() {
    sound = new Audio('././sounds/click.mp3');
    sound.play();
    sound.volume = 0.2;
}

function playClick2() {
    sound = new Audio('././sounds/click.mp3');
    sound.play();
    sound.volume = 0.06;
}

function closeAll() {

    if (inCaseWinningPage) {
        $.post(`https://${GetParentResourceName()}/Notify`, JSON.stringify({
            title: "Fehler",
            text: "Du Musst dein Case Gewinn Claimen",
            type: "error",
            time: 5000
        }))
    } else {
        if (inSpawn) {
            $.post(`https://${GetParentResourceName()}/spawn`);
            inSpawn = false
            closeAll()
        } else {
            if (!inEventRules && !firstCam && !canExit) {
                haveChoseAction = false

                playClick()
                $('.skin').fadeOut(125)
                $('.garage').fadeOut(125);
                $('.factionmenu').fadeOut(125);
                $('.invite').fadeOut(125)
                $('.gangwarScoreboard').fadeOut(125);
                $('.funk').fadeOut(125);
                $('.creator').fadeOut(125)
                $('.chat').val('');
                $('.chat').fadeOut(125);
                $('.emoterad').fadeOut(125);
                $('.match__container').fadeOut(125);
                $('.report__user__container').fadeOut(125)
                $('.report__admin').fadeOut(125)
                $('.faction-list').fadeOut(250)
                $('.main__container').fadeOut(125);

                $.post(`https://${GetParentResourceName()}/close`);
            }
        }
    }
}

const texts = ["HERZLICH WILKOMMEN AUF DEM SERVER.", "DRÜCKEN SIE ENTER UM FORTZUFAHREN."];
const animationSpan = document.querySelector('.animationText');
let currentTextIndex = 0;
let charIndex = 0;

function typeText() {
    if (charIndex < texts[currentTextIndex].length) {
        animationSpan.textContent += texts[currentTextIndex].charAt(charIndex);
        charIndex++;
        setTimeout(typeText, 110)
        playClick2()
    } else {
        setTimeout(nextText, 3000);
    }
}

function nextText() {
    if (currentTextIndex < texts.length - 1) {
        currentTextIndex++;
        charIndex = 0;
        animationSpan.textContent = "";
        typeText();
    }
}


$(document).ready(function () {
    window.addEventListener('message', function (event) {
        const i = event.data;

        switch (i.a) {
            case 'firstJoin': {
                $('.animationText').fadeIn(125);
                typeText();

                setTimeout(() => {
                    firstCam = true;
                }, 12000);
                break;
            }

            case 'noExit': {
                canExit = true
                break;
            }
        }
    });
});


