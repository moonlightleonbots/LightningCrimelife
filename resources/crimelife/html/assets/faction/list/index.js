$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var i = event.data;

        switch (i.a) {
            case 'factionlist-append': {
                const factions = i.data;
                $('.faction-list').fadeIn(250);
                $('.faction-list-append').empty();

                factions.sort((a, b) => b.online - a.online);
                for (const [kex, value] of Object.entries(factions)) {
                    const bwpButton = value.bwp ? `<button class="bwp-button">BEWERBUNGSPHASE</button>` : '';
                    const canClick = value.bwp ? `onclick="joinBWP()"` : ``;
                    const iconColor = value.canattack ? '#35FF6E' : '#ff3535';

                    setTimeout(() => {
                        $('.faction-list-append').append(`
                            <div class="faction-list-item" ${canClick}>
                                <i class="fa-solid fa-skull" style="color: ${iconColor};"></i>
                                <span class="faction-name">${value.label}</span>
                                <span class="faction-members">${value.online} <span style="color: rgba(255, 255, 255, 0.5);">/${value.offline} Online</span></span>
                                ${bwpButton}
                            </div>
                        `);
                    }, 800);
                }

                break;
            }
        }
    });
});

const joinBWP = () => {
    $.post(`https://${GetParentResourceName()}/joinBWP`, JSON.stringify());
    closeAll()
}  