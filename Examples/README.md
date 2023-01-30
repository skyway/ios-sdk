# SkyWay Examples

サンプルアプリを公開しています。

- Room ライブラリの P2PRoom による 映像・音声・データの PubSub(P2PRoom)
- Room ライブラリの SFURoom による 映像・音声の PubSub(SFURoom)
- Room ライブラリ による Web 会議のサンプル(AutoSubscribingRoom)

それぞれProjectのtargetsで管理しています。

実行環境はiPhone実機のみでSimulatorは対応していません。

## 利用方法

CocoaPodsにてSDKをインストールします。

```
$ cd ios-sdk/Examples
$ pod install
```

生成された`SkyWayExample.xcworkspace`を開き、SkyWayViewModelの`setup`関数内のtoken変数を生成したJWTに変更してください。

https://github.com/skyway/ios-sdk/blob/5668bf1946da57c8ce10ca31e247976ad070557e/Examples/Sources/Common/SkyWayViewModel.swift#L30-L32

JWTの生成はクイックスタートを参考に利用してください

https://skyway.ntt.com/ja/docs/user-guide/ios-sdk/quickstart/#31

実行したいアプリケーションのtargetを選択して実機でRUNしてください。