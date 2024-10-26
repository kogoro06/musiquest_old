import { extractAudioFeatures } from "../audioFeatures"; // ディレクトリに応じて修正

document.addEventListener("turbo:load", init);
document.addEventListener("DOMContentLoaded", init);

function init() {
  // DOM要素を取得
  const songSelect = document.getElementById("songSelect");
  const lyricsDisplay = document.getElementById("lyricsDisplay");
  const startRecordingButton = document.getElementById("startRecordingButton");
  const stopRecordingButton = document.getElementById("stopRecordingButton");
  const submitRecordingButton = document.getElementById("submitRecordingButton");
  const audioPlayback = document.getElementById("audioPlayback");
  const audioDataInput = document.getElementById("audioDataInput");
  const analyzeButton = document.getElementById("analyzeButton"); // 診断開始ボタン

  let mediaRecorder;
  let audioChunks = [];

  // 各要素が存在するか確認してからイベントリスナーを追加
  if (songSelect) {
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

    songSelect.addEventListener("change", function() {
      const selectedSong = songSelect.value;
      if (selectedSong && songLyrics[selectedSong]) {
        lyricsDisplay.innerHTML = songLyrics[selectedSong];
        startRecordingButton.disabled = false; // 録音開始ボタンを有効にする
      } else {
        lyricsDisplay.innerHTML = "曲を選択すると、歌詞が表示されます。";
        startRecordingButton.disabled = true; // 曲が選択されていない場合は無効化
      }
    });
  }

  if (startRecordingButton && stopRecordingButton && audioPlayback && audioDataInput) {
    // マイクにアクセスして録音を開始
    startRecordingButton.addEventListener("click", async () => {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        mediaRecorder = new MediaRecorder(stream);
        audioChunks = [];

        mediaRecorder.ondataavailable = (event) => {
          audioChunks.push(event.data);
        };

        mediaRecorder.onstop = async () => {
          const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });
          const audioUrl = URL.createObjectURL(audioBlob);
          audioPlayback.src = audioUrl;

          // BlobをBase64に変換してフォームにセット
          const reader = new FileReader();
          reader.readAsDataURL(audioBlob);
          reader.onloadend = async () => {
            audioDataInput.value = reader.result; // Base64形式の音声データをhiddenフィールドにセット
            submitRecordingButton.disabled = false; // 送信ボタンを有効化
            
            // 録音が成功した場合、診断開始ボタンを有効化
            analyzeButton.disabled = false; // 診断開始ボタンを有効化
          };
        };

        mediaRecorder.start();
        startRecordingButton.disabled = true; // 録音中は録音開始ボタンを無効化
        stopRecordingButton.disabled = false; // 録音停止ボタンを有効化
      } catch (error) {
        console.error("マイクへのアクセスに失敗しました:", error);
        alert("音声の録音に失敗しました。もう一度録音を試みてください。"); // アラートを表示
      }
    });

    // 録音を停止
    stopRecordingButton.addEventListener("click", () => {
      mediaRecorder.stop();
      startRecordingButton.disabled = false; // 録音停止後は録音開始ボタンを有効化
      stopRecordingButton.disabled = true; // 録音停止ボタンを無効化
    });
  } else {
    console.error("録音機能に必要な要素が見つかりませんでした");
  }

  // 診断開始ボタンを押したときの処理
  analyzeButton.addEventListener("click", async () => {
    if (audioDataInput.value) {
      const audioBlob = await fetch(audioDataInput.value).then(res => res.blob());

      const analysisSuccess = await analyzeAudio(audioBlob);
      if (analysisSuccess) {
        window.location.href = "/audio_confirmation"; // 診断結果ページに遷移
      }
    } else {
      alert("録音が成功していません。もう一度録音を試みてください。");
    }
  });
}

// 音声データを分析する関数
async function analyzeAudio(audioBlob) {
    try {
        const arrayBuffer = await audioBlob.arrayBuffer();
        const audioBuffer = await new AudioContext().decodeAudioData(arrayBuffer);

        // extractAudioFeatures を呼び出し
        const { pitch, energy, tone } = await extractAudioFeatures(audioBuffer);

        console.log("Extracted features:", { pitch, energy, tone });

        // ここで結果に基づく診断処理を追加
        let voiceType;
        if (pitch > 0.8 && energy > 0.5 && tone === "明るい") {
            voiceType = "高音エネルギータイプ";
        } else if (pitch < 0.3 && energy > 0.5 && tone === "暗い") {
            voiceType = "低音エネルギータイプ";
        } else if (pitch > 0.8 && energy < 0.5) {
            voiceType = "高音ソフトタイプ";
        } else {
            voiceType = "中音バランスタイプ";
        }

        console.log("診断結果:", voiceType);
  
        // 結果をsessionStorageに保存し、次のページで利用
        sessionStorage.setItem("voiceType", voiceType);
  
        return true;
    } catch (error) {
        console.error("音声分析中にエラーが発生しました:", error);
        alert("音声の分析に失敗しました。もう一度録音を試みてください。");
        return false;
    }
}

// Chart.jsで結果を表示する関数
function displayChart(data) {
    console.log("Data passed to chart:", data);
    const ctx = document.getElementById('myChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Result 1', 'Result 2', 'Result 3'], // ラベルは適切に設定
            datasets: [{
                label: 'Analysis Result',
                data: data, // 取得したデータを使用
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}
