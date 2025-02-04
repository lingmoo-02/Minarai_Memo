# ■サービス概要

「見習いメモ（仮）」は、1つの分野を極めた職人になるために、まだ見習いの職人が学んだ技術をメモできるサービスです。
写真や文章をアップロードすることで、学んだ知識や技術をいつでも気軽に記録、閲覧することができます。

# ■ このサービスへの思い・作りたい理由

世の中には様々な分野で活躍する職人さんがたくさんいます。
例えば建築に携わる大工や庭師、文化的な分野で活躍する陶芸家、織物職人。
飲食に携わるパティシエや寿司職人など、ほかにもたくさんの分野でたくさんの職人さんがいます。
私自身も現在リノベーション大工として働いています。
私が大工の見習いとして働き始めた頃、先輩によく言われた言葉は「見て覚えなさい」でした。
なぜそう言うかというと、説明するのが面倒だからではなく、現場での作業は口で説明することが難しい技術を使っていることが多いからです。
しかし先輩の技術を本当にただ見て覚えられるほど職人の世界は甘くありません。
ならば少しでもその「見て覚える」を再現性のあるものにすればもっと効率的に一人前の職人になれると考えこのサービスを作りたいと考えました。

# ■ ユーザー層について

メインのユーザー層は、様々な分野の職人をめざす見習いの職人さんです。
私が大工になりたてで見習いの時、先輩大工の作業を後ろで見て写真を撮りながら手書きのメモを取っていました。
ノートに取った方が頭に入りやすいという理由もありましたが、当時は現在ほどネットのサービスやアプリが発展していたわけではなかったからです。
休憩の合間に取ったメモと写真を見返して勉強していましたが、それらを簡単にまとめてパッと見れるツールのようなものがあったらいいなと考えていました。
当時の自分の悩みを解決すると同時に、少子高齢化で減少してしまっている職人という仕事をやってみたいと思う人が増えてほしいという理由で「見習いの職人」をユーザーに決めました。

# ■サービスの利用イメージ

- 仕事現場で写真を撮影してアップロードできる
- メモを書ける
- 上記2点がどこでもできる
以上の3点を実現するためにはスマホ1台で完結する利用方法をイメージしています。
これにより、見習い職人の技術向上を助長するとともに、教育時間の短縮を図ることで業務の生産性向上を実現します。

# ■ ユーザーの獲得について

職場の入社間もない新人大工に利用してもらうことを考えています。
また、RUNTEQ内の受講生に使ってもらうこともできるので、XやSNSなどでの宣伝を考えています。
例えば釣りが趣味の人がいたとします。釣りエサの取り付け方について教えたい時、文章と写真をメモとして投稿し、教えたい人にURLを送れば簡単に説明することができます。
元々は言葉では説明しづらい手作業を写真と文章で説明することができるサービスなのでこのような使い方もできます。

# ■ サービスの差別化ポイント・推しポイント

このサービスの一番の特徴は、メインのユーザー層を職人の見習いにしたところです。
職人さんの技術は書籍でも知ることができます。
ですが、その時その作業についての詳細で専門的で実用性が高い技術はやはりその道のプロに教えてもらうのが一番です。
このサービスを使えば、見習いの職人さんにかける教育時間を短縮できるとともに、見習いの職人さんがとても簡単に技術を継承することができます。

# ■ 機能候補

### MVPリリース時
- ユーザー登録機能
- リスト作成機能
- 画像アップロード機能
- タグ付け機能

### 本リリース時
- メモ検索機能
- X（URL）シェア機能
- 利用規約・プライバシーポリシー

### 現在検討している追加機能やサービス案
- 先輩・師匠による添削（赤ペン）機能
見習いのアカウントやメモに任意のアカウントを関連付けることでそのアカウントが添削することができる機能
- 見習いランク機能
メモ、写真、添削してもらった数などサービスの利用実績に応じてランクアップ機能。モチベーションとサービスのエンゲージメントをアップさせる
- 職人カテゴリーの設定
ゴールの見える化でモチベーションとサービスのエンゲージメントをアップさせる
- 所要時間設定機能
仕事において大切なスピードを鍛えるための機能
- 完成度自己評価機能
100点満点中何点かを自己評価し、常にいい仕事をするための指標にすることができる

# ■ 機能の実装方針予定

- ログイン機能（device）
- ページネーション機能（kaminari）
- メモ絞り込み機能（Form Object）
- Xシェア機能（gem meta-tags,mini_magick）
- 利用規約・プライバシーポリシー（gem 'high_voltage'）

# 画面遷移図

https://www.figma.com/design/flCQSvzWpWuUacI3W6tIHO/MinaraiMemo?node-id=0-1&p=f&t=YpIP3TaoC9aX6Yhr-0

# ER図

https://gyazo.com/9de4b18cadc4601d3ea0312785b27657
