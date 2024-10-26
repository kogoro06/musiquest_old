// songSelection.js

export function setupSongSelection() {
    const songSelect = document.getElementById("songSelect");
    const lyricsDisplay = document.getElementById("lyricsDisplay");
    const startRecordingButton = document.getElementById("startRecordingButton");
  
    if (songSelect && startRecordingButton && lyricsDisplay) {
      const songLyrics = {
        "Twinkle, Twinkle, Little Star": `
          きらきらひかる<br>
          おそらのほしよ<br>
          まばたきしては<br>
          みんなをみてる<br>
        `,
        "Happy Birthday": `
          ハッピーバースデー トゥー ユー<br>
          ハッピーバースデー トゥー ユー<br>
          ハッピーバースデー ディア [名前]<br>
          ハッピーバースデー トゥー ユー<br>
        `,
        "Row, Row, Row Your Boat": `
          こげよマイケル こげよボートを<br>
          ゆかいに たのしく いのち は たのし<br>
        `,
        "Jingle Bells": `
          ジングルベルジングルベル<br>
          すずが なる<br>
          きょうは たのしい<br>
          クリスマス<br>
        `
      };
  
      songSelect.addEventListener("change", () => {
        const selectedSong = songSelect.value;
        if (selectedSong && songLyrics[selectedSong]) {
          lyricsDisplay.innerHTML = songLyrics[selectedSong];
          startRecordingButton.disabled = false;
        } else {
          lyricsDisplay.innerHTML = "曲を選択すると、歌詞が表示されます。";
          startRecordingButton.disabled = true;
        }
      });
    }
  }
  