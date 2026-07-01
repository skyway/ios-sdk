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

以下のコマンドでプロジェクトを生成してください。

```
$ cd ios-sdk/Examples
$ xcodegen    # project.yml から SkyWayExample.xcodeproj を生成
```

生成された `SkyWayExample.xcodeproj` を開くと、Xcode が自動的に Swift Package Manager の依存関係を解決し、Room SDK を取得します。

[SkyWayCredentials.swift](https://github.com/skyway/ios-sdk/blob/main/Examples/Sources/Common/SkyWayCredentials.swift) にて、`appId` と `secretKey` を記入してください。

実行したいアプリケーションの target を選択して、実機で RUN してください。