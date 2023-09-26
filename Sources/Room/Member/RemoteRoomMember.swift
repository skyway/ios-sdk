//
//  RemoteRoomMember.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/17.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

/// 他のSDKで生成されたRoomMember
@objc open class RemoteRoomMember: RoomMember {
    init(core: RemotePerson, room: Room) {
        super.init(core: core, room: room)
    }

    /// イベントデリゲート
    @objc public var delegate: RemoteRoomMemberDelegate? {
        get {
            _delegate as? RemoteRoomMemberDelegate
        }
        set(value) {
            (core as! RemotePerson).delegate = self
            _delegate = value
        }
    }

    /// PublicationをSubscribeさせます。
    ///
    /// - Parameters:
    ///   - publicationId: SubscribeするPublicationのID
    /// - Returns: Subscription
    @available(iOS 13.0, *)
    @objc public func subscribe(publicationId: String) async throws -> RoomSubscription {
        try await withCheckedThrowingContinuation { continuation in
            self.subscribe(publicationId: publicationId) { subscription, error in
                if let subscription = subscription {
                    continuation.resume(returning: subscription)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }

    /// PublicationをSubscribeさせます。
    ///
    /// - Parameters:
    ///   - publicationId: SubscribeするPublicationのID
    ///   - completion: 完了コールバック
    @objc public func subscribe(
        publicationId: String,
        completion: ((RoomSubscription?, Error?) -> Void)?
    ) {
        let person = core as! RemotePerson
        person.subscribePublication(publicationID: publicationId) { (subscription, error) in
            guard let subscription = subscription else {
                completion?(nil, error)
                return
            }
            completion?(subscription.toRoomSubscription(self.room), nil)
        }
    }

    /// Subscribeを中止させます。
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

    /// Subscribeを中止させます。
    ///
    /// - Parameter subscriptionId: 停止するSubscriptionのID
    ///   - completion: 完了コールバック
    @objc public func unsubscribe(subscriptionId: String, completion: ((Error?) -> Void)?) {
        let person = core as! RemotePerson
        person.unsubscribe(subscriptionID: subscriptionId) { error in
            guard error == nil else {
                completion?(error)
                return
            }
            completion?(nil)
        }
    }
}
