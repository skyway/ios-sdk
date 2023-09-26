//
//  LocalRoomMember.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/17.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

/// Publishオプション
@objc open class RoomPublicationOptions: PublicationOptions {
    /// Subscribeできる最大人数
    ///
    /// SFURoomのみ有効のオプションで、デフォルトは10人です。
    ///
    /// 最大値は99です。詳しくはこちらをご覧ください。
    ///
    /// https://skyway.ntt.com/ja/docs/user-guide/sfu/
    public var maxSubscribers: Int32?
}

/// このSDKで生成されたRoomMemberの抽象クラス
@objc open class LocalRoomMember: RoomMember {
    init(core: LocalPerson, room: Room) {
        super.init(core: core, room: room)
    }

    /// イベントデリゲート
    @objc public var delegate: LocalRoomMemberDelegate? {
        get {
            _delegate as? LocalRoomMemberDelegate
        }
        set(value) {
            (core as! LocalPerson).delegate = self
            _delegate = value
        }
    }

    /// 入室しているRoomにStreamをPublishします。
    ///
    /// Streamは各種Sourceから作成できます。
    ///
    /// 同じインスタンスのStreamを複数回Publishすることはできません。必要ならば各種Sourceから再度作成してPublishしてください。
    ///
    /// 詳しいオプションの設定例については Core SDK の[PublicationOptions](/core/Classes/SKWPublicationOptions.html)、開発者ドキュメントの[大規模会議アプリを実装する上での注意点](https://skyway.ntt.com/ja/docs/user-guide/tips/large-scale/)をご覧ください。
    ///
    /// - Parameters:
    ///   - stream: PublishするStream
    ///   - options: Publishオプション
    /// - Returns: RoomPublication
    @available(iOS 13.0, *)
    @objc public func publish(_ stream: LocalStream, options: RoomPublicationOptions?) async throws
        -> RoomPublication
    {
        try await withCheckedThrowingContinuation { continuation in
            self.publish(stream, options: options) { publication, error in
                if let publication = publication {
                    continuation.resume(returning: publication)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }

    /// 入室しているRoomにStreamをPublishします。
    ///
    /// Streamは各種Sourceから作成できます。
    ///
    /// 同じインスタンスのStreamを複数回Publishすることはできません。必要ならば各種Sourceから再度作成してPublishしてください。
    ///
    /// 詳しいオプションの設定例については Core SDK の[PublicationOptions](/core/Classes/SKWPublicationOptions.html)、開発者ドキュメントの[大規模会議アプリを実装する上での注意点](https://skyway.ntt.com/ja/docs/user-guide/tips/large-scale/)をご覧ください。
    ///
    /// - Parameters:
    ///   - stream: PublishするStream
    ///   - options: Publishオプション
    ///   - completion: 完了コールバック
    @objc public func publish(
        _ stream: LocalStream,
        options: RoomPublicationOptions?,
        completion: ((RoomPublication?, Error?) -> Void)?
    ) {
        let person = core as! LocalPerson
        person.publish(stream, options: options) { (publication, error) in
            guard let publication = publication else {
                completion?(nil, error)
                return
            }
            completion?(publication.toRoomPublication(self.room), nil)
        }
    }

    /// Publishを停止します。
    ///
    /// - Parameter publicationId: 停止するPublicationのID
    @available(iOS 13.0, *)
    @objc public func unpublish(publicationId: String) async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            self.unpublish(publicationId: publicationId) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Publishを停止します。
    ///
    /// - Parameters:
    ///   - publicationId: 停止するPublicationのID
    ///   - completion: 完了コールバック
    @objc public func unpublish(publicationId: String, completion: ((Error?) -> Void)?) {
        let person = core as! LocalPerson
        person.unpublish(publicationID: publicationId) { error in
            guard error == nil else {
                completion?(error)
                return
            }
            completion?(nil)
        }
    }

    /// PublicationをSubscribeします。
    ///
    /// オプションについては Core SDK のリファレンスもご確認ください。
    ///
    /// - Parameters:
    ///   - publicationId: SubscribeするPublicationのID
    ///   - options: Subscribeオプション
    /// - Returns: Subscription
    @available(iOS 13.0, *)
    @objc public func subscribe(publicationId: String, options: SubscriptionOptions?) async throws
        -> RoomSubscription
    {
        try await withCheckedThrowingContinuation { continuation in
            self.subscribe(publicationId: publicationId, options: options) { subscription, error in
                if let subscription = subscription {
                    continuation.resume(returning: subscription)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }

    /// PublicationをSubscribeします。
    ///
    /// オプションについては Core SDK のリファレンスもご確認ください。
    ///
    /// - Parameters:
    ///   - publicationId: SubscribeするPublicationのID
    ///   - options: Subscribeオプション
    ///   - completion: 完了コールバック
    @objc public func subscribe(
        publicationId: String,
        options: SubscriptionOptions?,
        completion: ((RoomSubscription?, Error?) -> Void)?
    ) {
        let person = core as! LocalPerson
        person.subscribePublication(publicationID: publicationId, options: options) {
            (subscription, error) in
            guard let subscription = subscription else {
                completion?(nil, error)
                return
            }
            completion?(subscription.toRoomSubscription(self.room), nil)
        }
    }

    /// Subscribeを中止します。
    ///
    /// - Parameter subscriptionId: 停止するSubscriptionのID
    @available(iOS 13.0, *)
    @objc public func unsubscribe(subscriptionId: String) async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            self.unsubscribe(subscriptionId: subscriptionId) { error in
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
    /// - Parameter subscriptionId: 停止するSubscriptionのID
    ///   - completion: 完了コールバック
    @objc public func unsubscribe(subscriptionId: String, completion: ((Error?) -> Void)?) {
        let person = core as! LocalPerson
        person.unsubscribe(subscriptionID: subscriptionId) { error in
            guard error == nil else {
                completion?(error)
                return
            }
            completion?(nil)
        }
    }
}
