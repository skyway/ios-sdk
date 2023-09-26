//
//  RoomPublication.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/16.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

/// Room SDKにおけるPublication
///
/// Core SDKのPublicationのラッパークラス
///
/// PublicationはLocalMemberがPublishした時に取得でき、Roomに参加している他クライアント(RemoteMember)がSubscribeされると通信を行います。
///
/// Roomなどから他の人のPublicationも取得することはできますが、その場合Streamは含まれません。
@objc open class RoomPublication: NSObject, Identifiable {
    /// Publicationを識別するためのID
    @objc public var id: String {
        return core.id
    }

    /// このPublicationを生成したMember
    @objc public var publisher: RoomMember? {
        let _core = core.origin ?? core
        guard let room = room else {
            Logger.error(message: "Room is missing.")
            return nil
        }
        return _core.publisher?.toRoomMember(room)
    }

    /// このPublicationに紐づくSubscription一覧
    @objc public var subscriptions: [RoomSubscription] {
        return core.subscriptions.map({ $0.toRoomSubscription(room) })
    }

    /// PublishしているStreamのコンテントタイプ
    @objc public var contentType: ContentType {
        return core.contentType
    }

    /// メタデータ
    @objc public var metadata: String? {
        let _core = core.origin ?? core
        return _core.metadata
    }

    /// コーデック指定
    @objc public var codecCapabilities: [Codec] {
        // TODO: Use `core.origin` after codec capabilities are copied to relayed publication in libskyway because JS-SDK do that.
        let _core = core.origin ?? core
        return _core.codecCapabilities
    }

    /// エンコーディング設定
    ///
    /// 詳しい設定例については開発者ドキュメントの[大規模会議アプリを実装する上での注意点](https://skyway.ntt.com/ja/docs/user-guide/tips/large-scale/)をご覧ください。
    @objc public var encodings: [Encoding] {
        let _core = core.origin ?? core
        return _core.encodings
    }

    /// ステート
    ///
    /// Canceledの場合、このオブジェクトの操作は無効です。
    @objc public var state: PublicationState {
        // TODO: Use `core.state` after libskyway supports remote publication enable/disable.
        let _core = core.origin ?? core
        return _core.state
    }

    /// このPublicationに紐づくStream
    ///
    /// LocalRoomMemberがPublishした時に得られるPublicationのみセットされます。
    @objc public var stream: LocalStream? {
        let _core = core.origin ?? core
        return _core.stream
    }

    /// イベントデリゲート
    @objc public var delegate: RoomPublicationDelegate? {
        get {
            return _delegate
        }
        set(value) {
            core.delegate = self
            core.origin?.delegate = self
            _delegate = value
        }
    }

    weak var _delegate: RoomPublicationDelegate?
    private let core: Publication
    weak var room: Room?
    init(core: Publication, room: Room?) {
        self.core = core
        self.room = room
        super.init()
    }

    /// メタデータを更新します。
    ///
    /// - Parameter metadata: 更新するメタデータ
    @available(iOS 13.0, *)
    @objc public func updateMetadata(_ metadata: String) async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            self.updateMetadata(metadata) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// メタデータを更新します。
    ///
    /// - Parameters:
    ///   - metadata: 更新するメタデータ
    ///   - completion: 完了コールバック
    @objc public func updateMetadata(_ metadata: String, completion: ((Error?) -> Void)?) {
        let _core = core.origin ?? core
        _core.updateMetadata(metadata, completion: completion)
    }

    /// Publishを中止します。
    @available(iOS 13.0, *)
    @objc public func cancel() async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            self.cancel { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Publishを中止します。
    /// - Parameter completion: 完了コールバック
    @objc public func cancel(completion: ((Error?) -> Void)?) {
        let _core = core.origin ?? core
        _core.cancel(completion: completion)
    }

    /// Publicationを有効状態にします。
    ///
    /// このAPIはLocalPublicationのみ機能します。
    ///
    /// 既に有効状態の場合は何もしません。
    @available(iOS 13.0, *)
    @objc public func enable() async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            self.enable { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Publicationを有効状態にします。
    ///
    /// このAPIはLocalPublicationのみ機能します。
    ///
    /// 既に有効状態の場合は何もしません。
    /// - Parameter completion: 完了コールバック
    @objc public func enable(completion: ((Error?) -> Void)?) {
        let _core = core.origin ?? core
        _core.enable(completion: completion)
    }

    /// Publicationを無効状態にします。
    ///
    /// 既に無効状態の場合は何もしません。
    @available(iOS 13.0, *)
    @objc public func disable() async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            self.disable { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Publicationを無効状態にします。
    ///
    /// 既に無効状態の場合は何もしません。
    /// - Parameter completion: 完了コールバック
    @objc public func disable(completion: ((Error?) -> Void)?) {
        let _core = core.origin ?? core
        _core.disable(completion: completion)
    }

    /// [Experimental API]
    ///
    /// 試験的なAPIです。今後インターフェースや仕様が変更される可能性があります。
    ///
    /// 通信中の統計情報を取得します。
    ///
    /// 併せて公式サイトの通信状態の統計的分析もご確認ください。
    /// https://skyway.ntt.com/ja/docs/user-guide/tips/getstats/
    /// - Parameter memberId: 通信相手のMemberID
    @objc public func getStats(memberId: String) -> WebRTCStats? {
        if core.origin == nil {
            // Should be P2PRoom
            return core.getStats(withMemberId: memberId)
        } else {
            // Shoud be SFURoom
            assert(core.publisher?.type == .bot)
            guard let botId = core.publisher?.id else {
                Logger.error(message: "Publisher is missing.")
                return nil
            }
            return core.origin?.getStats(withMemberId: botId)
        }
    }

    /// エンコーディング設定を更新します。
    ///
    /// 更新はLocalRoomMemberのPublishしたPublicationのみ有効で、ContentTypeがAudioまたはVideoの時のみ更新ができます。
    ///
    /// Publish時に設定したエンコーディングの数と一致している必要があります。
    ///
    /// IDの変更は行えません。
    /// - Parameter encodings: エンコーディング設定
    @objc public func update(_ encodings: [Encoding]) {
        let _core = core.origin ?? core
        _core.updateEncodings(encodings)
    }

    /// 送信するストリームを切り替えます。
    ///
    /// このAPIはLocalRoomMemberがPublishしたPublication(Streamがnilではない)のみ操作可能で、切り替え前と同じContentTypeである必要があります。
    ///
    /// DataStreamを入れ替えることはできません。
    /// - Parameter stream: ストリーム
    @objc public func replace(_ stream: LocalStream) {
        let _core = core.origin ?? core
        _core.replaceStream(stream)
    }

    // MARK: - NSObject
    override open func isEqual(_ object: Any?) -> Bool {
        return (object as? RoomPublication)?.id == self.id
    }

    open override var hash: Int {
        var hasher: Hasher = .init()
        id.hash(into: &hasher)
        return hasher.finalize()
    }
}

extension Publication {
    func toRoomPublication(_ room: Room?) -> RoomPublication {
        return .init(core: self, room: room)
    }
}
