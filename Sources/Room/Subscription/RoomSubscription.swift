//
//  RoomSubscription.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/16.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

/// Room SDK におけるSubscription
///
/// Core SDK のSubscriptionのラッパークラス
///
/// SubscriptionはLocalMemberがSubscribeした時に取得でき、Subscriptionに含まれるStreamを利用して映像を描画したりします。
///
/// Roomなどから他の人のSubscriptionも取得することはできますが、その場合Streamは含まれません。
@objc open class RoomSubscription: NSObject, Identifiable {
    /// Subscriptionを識別するID
    @objc public var id: String {
        return core.id
    }
    /// このSubscriptionに紐づくStreamのContentType
    @objc public var contentType: ContentType {
        return core.contentType
    }
    /// SubscribeしているPublication
    @objc public var publication: RoomPublication? {
        return room?.publications.first(where: { $0.id == core.publication?.id })
    }
    /// SubscribeしているRoomMember
    @objc public var subscriber: RoomMember? {
        return room?.members.first(where: { $0.id == core.subscriber?.id })
    }
    /// ステート
    ///
    /// Canceledの場合、このオブジェクトの操作は無効です。
    @objc public var state: SubscriptionState {
        return core.state
    }
    /// このSubscriptionに紐づくStream
    ///
    /// LocalRoomMemberがSubscribeし、成功した時の返り値または完了コールバックで得られるSubscriptionにおいては値がSetされていることが保証されています。
    ///
    /// その他、イベントによってSubscriptionを取得した場合、まだ値がSetされていない可能性があります。
    @objc public var stream: RemoteStream? {
        return core.stream
    }

    /// 優先エンコーディング設定
    @objc public var preferredEncodingId: String? {
        return core.preferredEncodingId
    }

    /// イベントデリゲート
    @objc public var delegate: RoomSubscriptionDelegate? {
        get {
            return _delegate
        }
        set(value) {
            core.delegate = self
            _delegate = value
        }
    }

    weak var _delegate: RoomSubscriptionDelegate?

    private let core: Subscription
    weak var room: Room?

    init(core: Subscription, room: Room?) {
        self.core = core
        self.room = room
    }

    /// Simulcastで利用するPreferredEncodingIDを変更します。
    ///
    /// この設定はSFURoomのみ有効です。
    ///
    /// LocalRoomMemberがSubscribeした時のSubscriptionで、ContentTypeがAudioまたはVideoの時のみ変更ができます。
    /// - Parameter encodingId: 変更するEncoding ID
    @objc public func changePreferredEncoding(encodingId: String) {
        core.changePreferredEncoding(withEncodingId: encodingId)
    }

    /// Subscribeを中止します。
    /// - Warning: SkyWayRoom v2.0.7で非推奨となりました。
    @available(iOS, introduced: 13.0, deprecated, message: "SkyWayRoom v2.0.7で非推奨となりました。")
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

    /// Subscribeを中止します。
    ///
    /// - Parameter completion: 完了コールバック
    /// - Warning: SkyWayRoom v2.0.7で非推奨となりました。
    @available(*, deprecated, message: "SkyWayRoom v2.0.7で非推奨となりました。")
    @objc public func cancel(completion: ((Error?) -> Void)?) {
        core.cancel(completion: completion)
    }

    /// - Warning: SkyWayRoom v2.0.0で非推奨となりました。
    @available(*, deprecated, message: "SkyWayRoom v2.0.0で非推奨となりました。")
    @objc public func getStats() -> WebRTCStats? {
        return core.getStats()
    }

    // MARK: - NSObject
    override open func isEqual(_ object: Any?) -> Bool {
        return (object as? RoomSubscription)?.id == self.id
    }

    open override var hash: Int {
        var hasher: Hasher = .init()
        id.hash(into: &hasher)
        return hasher.finalize()
    }
}

extension Subscription {
    func toRoomSubscription(_ room: Room?) -> RoomSubscription {
        return .init(core: self, room: room)
    }
}
