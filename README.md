---

## MusiQuest - ジャンル別イントロクイズ & プレイリスト提案アプリ

---

### サービス概要

「MusiQuest」は、Spotify APIを利用して、ユーザーがジャンル別のイントロクイズを楽しめる音楽体験アプリです。ユーザーは好きなジャンル（J-Pop、K-Pop、アニソン、ロック、ポップなど）を選び、Spotifyの豊富な音楽データベースからジャンルごとにランダムに出題されるクイズに挑戦できます。クイズで正解した楽曲は「正解プレイリスト」に自動保存され、後から再生や振り返りが可能です。

---

### このサービスへの思い・作りたい理由

ただ聴くだけでなく、ジャンルごとのクイズに挑戦することで、音楽の知識を深めたり、幅広いジャンルに触れて欲しいという思いからこのアプリを制作しました。Spotify APIを活用し、ユーザーがその時の気分や興味に合わせてクイズに挑戦できる設計にすることで、音楽の楽しさや発見の場を提供したいと考えています。

---

### ユーザー層について

- **音楽好きな人**: 幅広いジャンルから新しい楽曲やアーティストを発見したい音楽ファン。
- **クイズ好きな人**: 音楽クイズで知識を試し、他のユーザーと競い合いたいクイズ愛好者。
- **友人や家族との時間を楽しみたい人**: 音楽クイズで家族や友人と一緒に盛り上がりたい方。

---

### サービスの利用イメージ

1. **ジャンル選択とクイズ**: ユーザーがジャンルを選択すると、Spotify APIから該当ジャンルの楽曲がランダムに出題され、イントロを聴きながら楽曲名やアーティスト名を当てるクイズに挑戦。
2. **正解プレイリスト**: クイズで正解した楽曲は「正解プレイリスト」に自動保存され、クイズ後に振り返って楽しめます。
3. **ランキング・シェア機能**: ユーザーの正解数やスコアが記録され、デイリー・ウィークリーランキングに反映されます。スコアをSNSでシェアして友人と楽しむこともできます。

---

### ユーザーの獲得について

- **SNSシェア機能**: クイズ結果や正解プレイリストをシェアしやすくすることで、アプリの認知度を高めます。「#harmonAI」「#音楽クイズ」などのハッシュタグで音楽好きなユーザーにリーチ。
- **Spotifyとの連携**: Spotify APIで取得した楽曲やプレイリスト情報を活用して、ユーザーが新しい音楽を発見しやすい設計にします。音楽クイズを通じて新しい楽曲に触れる体験を提供し、リピーターの獲得を目指します。

---

## 機能候補

### MVPリリース時に作りたい機能

1. **ジャンル別イントロクイズ機能**: Spotify APIから取得したデータを基に、ユーザーが選んだジャンルの楽曲をイントロクイズとして出題。ユーザーは曲名やアーティスト名を当てます。
2. **正解プレイリストの自動生成**: クイズで正解した楽曲を「正解プレイリスト」に自動的に追加し、クイズ終了後にまとめて再生可能にします。
3. **ランキング機能**: ユーザーのスコアをデイリー・ウィークリーで集計し、他のユーザーと競い合えるランキングを表示します。

---

### 本リリースまでに作りたい機能

1. **プレイリストのジャンル別カスタマイズ**: ユーザーの興味に合わせたジャンルごとのイントロクイズを提供し、特定ジャンルの知識を深められるようにします。
2. **履歴機能**: 過去のクイズ記録や正解した曲のリストを保存し、振り返りを楽しめます。
3. **SNSシェア機能**: クイズ結果や正解プレイリストをSNSにシェアできるようにします。
4. **オンライン対戦 & レーティング機能**: 他ユーザーとリアルタイムで対戦でき、対戦結果に基づくレーティング機能を提供。対戦でのスコアによってレーティングが変動し、競争性が高まります。
5. **年代別アーティスト推薦機能**: ユーザーのクイズ回答履歴やリスニング履歴を基に、特定の年代やジャンルのアーティストを推薦。同じジャンルでも異なる年代の楽曲を発見する体験を提供します。

---

## 機能の実装方針

### 1. ジャンル別イントロクイズ機能 (MVP)

- **実装方法**:
  - APIエンドポイントを用いて、ユーザーが選択したジャンルに基づきSpotify APIから楽曲データをランダムに取得。
  - `Hotwire`を使い、イントロ再生や回答入力を非同期で管理し、Turboでのリアルタイム更新を実現。Stimulusで再生や正解判定を操作するインタラクティブなUIを提供。

### 2. 正解プレイリストの自動生成 (本リリース)

- **実装方法**:
  - クイズ正解時にデータベースに正解曲データを追加し、ユーザーごとの「正解プレイリスト」として保存。
  - `Turbo Frames`を活用し、正解時にプレイリストが自動で更新されるようにします。

### 3. ランキング機能 (本リリース)

- **実装方法**:
  - スコアを集計し、デイリー・ウィークリーランキングを`Active Record`で管理。
  - `Hotwire`でランキングページが動的に更新され、最新スコアを確認できるようにします。

### 4. オンライン対戦 & レーティング機能 (本リリース)

- **実装方法**:
  - `Action Cable`でリアルタイム通信を実装し、ユーザー同士のオンライン対戦を可能にします。対戦の進行や結果がリアルタイムで更新されるようにします。
  - ELOレーティングシステムを参考に、対戦結果によるレーティングの増減を計算し、ランキングに反映します。

### 5. 年代別アーティスト推薦機能 (本リリース)

- **実装方法**:
  - ユーザーの回答履歴や好みを保存し、Spotify APIから年代別アーティストを取得して推薦リストを生成します。
  - `Stimulus`でUIを動的に更新し、ユーザーが年代やジャンルを選択すると、新しいアーティストの推薦が表示されます。

---

## APIと使用する技術の説明

### 1. Spotify API

- **役割**: ジャンル別や年代別の楽曲を取得し、イントロクイズやプレイリスト作成、年代別アーティスト推薦に利用。

### 2. Hotwire（Turbo & Stimulus）

- **役割**: Turboで非同期のリアルタイム更新を行い、StimulusでインタラクティブなUI操作を提供。ページ遷移なしでスムーズなクイズ体験を提供します。

### 3. Action Cable

- **役割**: リアルタイム通信を活用し、オンライン対戦やリアルタイムでのスコア共有を実現。

### 4. Ruby on Rails 

- **役割**: バックエンドでAPIリクエスト処理、スコア集計、正解プレイリスト・レーティングデータの管理を行います。非同期通信機能や`Active Record`によるデータ管理を担当します。

---

`Hotwire`や`Action Cable`の非同期・リアルタイム通信によって、インタラクティブな音楽クイズ体験を提供します。Spotify API連携により幅広い音楽データを活用し、楽しい音楽体験をサポ