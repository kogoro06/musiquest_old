async function sendToAzureAPI(audioBlob) {
    const formData = new FormData();
    formData.append('file', audioBlob);
  
    try {
      const response = await fetch('https://japaneast.api.cognitive.microsoft.com/speaker/recognition/v1.0/identify', {
        method: 'POST',
        headers: {
          'Ocp-Apim-Subscription-Key': 'cfdec723d49b4200bed282cebd1f3ee9',  // Azureから取得したAPIキーを設定
          'Content-Type': 'application/octet-stream'   // バイナリデータ送信時に必要
        },
        body: audioBlob
      });
  
      if (!response.ok) {
        throw new Error(`Azure API request failed: ${response.statusText}`);
      }
  
      const result = await response.json();
      console.log("Azure API response:", result);
  
      // 解析結果の処理
      handleAzureResponse(result);
    } catch (error) {
      console.error("Error sending data to Azure API:", error);
    }
  }
  
  function handleAzureResponse(response) {
    // APIから返ってきた結果を処理する関数
    // 例えば、声質に応じた結果を表示したり、診断結果を表示したりする処理を実装
    console.log("Speaker Recognition Result:", response);
  }