# SkyWay Examples

以下のサンプルアプリを公開しています。

- Room ライブラリの P2PRoom を使った映像・音声・データの PubSub（P2PRoom）
- Room ライブラリの SFURoom を使った映像・音声の PubSub（SFURoom）
- Room ライブラリを使った Web 会議のサンプル（AutoSubscribingRoom）
- Room ライブラリの DefaultRoom を使った映像・音声の PubSub（DefaultRoom）
- Room ライブラリの VideoProcessor を使った背景ぼかし・バーチャル背景の配信（VideoProcessorExample）

それぞれプロジェクトの targets で管理しています。

実行環境は iPhone 実機のみです。Simulator には対応していません。

## 利用方法

`xcodegen` を使って `project.yml` から `SkyWayExample.xcodeproj` を生成する必要があります。`xcodegen` がインストールされていない場合は、以下のコマンドでインストールしてください。

```
$ brew install xcodegen
```

CocoaPods にて SDK をインストールします。

```
$ cd ios-sdk/Examples
$ xcodegen    # project.yml から SkyWayExample.xcodeproj を生成
$ pod install # CocoaPods の依存をインストールし、SkyWayExample.xcworkspace を生成
```

生成された `SkyWayExample.xcworkspace` を開き、`SkyWayViewModel` の `setup` 関数内の `token` 変数を生成した JWT に変更してください。

https://github.com/skyway/ios-sdk/blob/5668bf1946da57c8ce10ca31e247976ad070557e/Examples/Sources/Common/SkyWayViewModel.swift#L30-L32

JWT の生成はクイックスタートを参考にしてください。

https://skyway.ntt.com/ja/docs/user-guide/ios-sdk/quickstart/#31

実行したいアプリケーションの target を選択して、実機で RUN してください。