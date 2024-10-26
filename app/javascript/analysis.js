import { extractAudioFeatures } from "./audioFeatures"; // 必要に応じてインポート

export function setupAnalysis() {
  const analyzeButton = document.getElementById("analyzeButton");
  const audioDataInput = document.getElementById("audioDataInput");

  if (analyzeButton && audioDataInput) {
    analyzeButton.addEventListener("click", async () => {
      if (audioDataInput.value) {
        const audioBlob = await fetch(audioDataInput.value).then(res => res.blob());
        const analysisSuccess = await analyzeAudio(audioBlob);
        if (analysisSuccess) {
          window.location.href = "/result";
        }
      } else {
        alert("録音が成功していません。もう一度録音を試みてください。");
      }
    });
  }
}

// 音声データを分析する関数
async function analyzeAudio(audioBlob) {
  try {
    const arrayBuffer = await audioBlob.arrayBuffer();
    const audioBuffer = await new AudioContext().decodeAudioData(arrayBuffer);

    const { pitch, energy, tone } = await extractAudioFeatures(audioBuffer);

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

    sessionStorage.setItem("voiceType", voiceType);

    return true;
  } catch (error) {
    console.error("音声分析中にエラーが発生しました:", error);
    alert("音声の分析に失敗しました。もう一度録音を試みてください。");
    return false;
  }
}
