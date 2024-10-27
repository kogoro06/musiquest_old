function checkAnswer(selectedAnswer) {
    // Railsから送られたデータとして、正解の曲名を取得
    var correctAnswer = document.getElementById('correct-answer').value;
  
    if (selectedAnswer === correctAnswer) {
      alert("正解です！");
    } else {
      alert("残念、不正解です。正解は " + correctAnswer + " でした。");
    }
  }
  