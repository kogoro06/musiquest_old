// 音声の特徴を抽出する関数
export async function extractAudioFeatures(audioBuffer) {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    const source = audioContext.createBufferSource();
    source.buffer = audioBuffer;
  
    // ピッチ推定のためのAnalyserNode
    const analyser = audioContext.createAnalyser();
    analyser.fftSize = 2048;
    source.connect(analyser);
    source.start();
  
    const bufferLength = analyser.frequencyBinCount;
    const dataArray = new Float32Array(bufferLength);
    analyser.getFloatFrequencyData(dataArray);
  
    const pitch = calculatePitch(dataArray);
    const energy = calculateEnergy(dataArray);
    const tone = estimateTone(dataArray);
  
    return { pitch, energy, tone };
  }
  
  // ピッチの計算
  function calculatePitch(dataArray) {
    // ピッチ推定ロジックをここに記述
  }
  
  // エネルギーの計算
  function calculateEnergy(dataArray) {
    let energySum = 0;
    dataArray.forEach(value => {
      energySum += value * value;
    });
    return Math.sqrt(energySum / dataArray.length);
  }
  
  // トーンの推定
  function estimateTone(dataArray) {
    const highFrequencyEnergy = dataArray.slice(dataArray.length / 2).reduce((a, b) => a + b, 0);
    const lowFrequencyEnergy = dataArray.slice(0, dataArray.length / 2).reduce((a, b) => a + b, 0);
    return highFrequencyEnergy > lowFrequencyEnergy ? "明るい" : "暗い";
  }
  