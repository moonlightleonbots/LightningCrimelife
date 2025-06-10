let currentAudio = null;
let currentAudioIndex = 0;

loadAudios();

window.addEventListener("message", (event) => {
  if (event.data.eventName === "loadProgress") {
    const percentage = Math.round(event.data.loadFraction * 100) + "%";
    document.getElementById("percentageLoad").innerText = percentage;
    document.getElementById("percentageImg").style.width = percentage;
  }
});

function updateText() {
  const audio = Config.Audios[currentAudioIndex];
  if (!audio) return console.error("No audio found in Config.Audios");

  document.getElementById("name").innerText = audio.name;
  document.getElementById("author").innerText = audio.author;
  document.getElementById("music_image").src = audio.image;
}

function loadAudios() {
  // load first item from Config.Audios
  const audio = Config.Audios[currentAudioIndex];
  if (!audio) return console.error("No audio found in Config.Audios");

  currentAudio = new Audio(audio.audio);
  currentAudio.loop = true;
  currentAudio.volume = 0.1;

  updateText();

  // make box_play, box_skip, box_skip clickable
  document.getElementById("box_play").addEventListener("click", () => {
    playAudio();
  });

  document.getElementById("box_skip_forward").addEventListener("click", () => {
    skipAudio(true);
  });

  document.getElementById("box_skip_backward").addEventListener("click", () => {
    skipAudio(false);
  });

  // make volume-range useable
  const volumeSlider = document.getElementById("volume-range");

  volumeSlider.addEventListener("input", (event) => {
    if (!currentAudio) return console.error("No audio found");

    currentAudio.volume = event.target.value / 100;
  });

  currentAudio.addEventListener("canplaythrough", (event) => {
    currentAudio.play();
  });
}

function playAudio() {
  if (!currentAudio) return console.error("No audio found");

  if (currentAudio.paused) {
    currentAudio.play();
  } else {
    currentAudio.pause();
  }
}

function skipAudio(forward) {
  if (!currentAudio) return console.error("No audio found");

  // use currentAudioIndex
  if (forward) {
    currentAudioIndex++;
  } else {
    currentAudioIndex--;
  }

  if (currentAudioIndex >= Config.Audios.length) {
    currentAudioIndex = 0;
  } else if (currentAudioIndex < 0) {
    currentAudioIndex = Config.Audios.length - 1;
  }

  currentAudio.pause();
  currentAudio = new Audio(Config.Audios[currentAudioIndex].audio);
  currentAudio.loop = true;
  currentAudio.volume = document.getElementById("volume-range").value / 100;
  currentAudio.play();

  updateText();
}

function stopAudio() {
  if (!currentAudio) return console.error("No audio found");
  currentAudio.pause();
}