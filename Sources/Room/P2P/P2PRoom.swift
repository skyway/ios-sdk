//
//  P2PRoom.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/16.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

/// P2P通信を行うRoom
///
/// Room抽象クラスもご確認ください。
@objc open class P2PRoom: Room {
    /// Roomを作成します。
    ///
    /// `options`でRoomの名前を指定して作成できますが、同じ名前のRoomは作成することができません。
    ///
    /// - Parameter options: 初期化オプション
    /// - Returns: Room
    @available(iOS 13.0, *)
    @objc public static func create(with options: InitOptions?) async throws -> P2PRoom {
        try await withCheckedThrowingContinuation { continuation in
            Self.create(with: options) { room, error in
                if let room = room {
                    continuation.resume(returning: room)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }

    /// Roomを作成します。
    ///
    /// `options`でRoomの名前を指定して作成できますが、同じ名前のRoomは作成することができません。
    ///
    /// - Parameters:
    ///   - options: 初期化オプション
    ///   - completion: 完了コールバック
    @objc public static func create(
        with options: InitOptions?,
        completion: ((P2PRoom?, Error?) -> Void)?
    ) {
        Channel.create(with: options?.toCore()) { (channel, error) in
            guard let channel = channel else {
                completion?(nil, error)
                return
            }
            let room: P2PRoom = .init(channel: channel)
            completion?(room, nil)
        }
    }

    /// Roomクエリを元にRoomを検索します。
    ///
    /// クエリはRoomのIDまたはNameを入力します。両方とも入力される場合はIDが優先されます。
    ///
    /// - Parameter query: 検索クエリ
    /// - Returns: Room
    @available(iOS 13.0, *)
    @objc public static func find(by query: Query) async throws -> P2PRoom {
        try await withCheckedThrowingContinuation { continuation in
            Self.find(by: query) { room, error in
                if let room = room {
                    continuation.resume(returning: room)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }

    /// Roomクエリを元にRoomを検索します。
    ///
    /// クエリはRoomのIDまたはNameを入力します。両方とも入力される場合はIDが優先されます。
    ///
    /// - Parameters:
    ///   - query: 検索クエリ
    ///   - completion: 完了コールバック
    @objc public static func find(by query: Query, completion: ((P2PRoom?, Error?) -> Void)?) {
        Channel.find(with: query.toCore()) { (channel, error) in
            guard let channel = channel else {
                completion?(nil, error)
                return
            }
            let room: P2PRoom = .init(channel: channel)
            completion?(room, nil)
        }
    }

    /// Roomを名前から検索し、存在しない場合は作成します。
    ///
    /// - Parameter options: 検索・初期化オプション
    /// - Returns: Room
    @available(iOS 13.0, *)
    @objc public static func findOrCreate(with options: InitOptions) async throws -> P2PRoom {
        try await withCheckedThrowingContinuation { continuation in
            Self.findOrCreate(options: options) { room, error in
                if let room = room {
                    continuation.resume(returning: room)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }

    /// Roomを名前から検索し、存在しない場合は作成します。
    ///
    /// - Parameters:
    ///   - options: 検索・初期化オプション
    ///   - completion: 完了コールバック
    @objc public static func findOrCreate(
        options: InitOptions,
        completion: ((P2PRoom?, Error?) -> Void)?
    ) {
        Channel.findOrCreate(with: options.toCore()) { (channel, error) in
            guard let channel = channel else {
                completion?(nil, error)
                return
            }
            let room: P2PRoom = .init(channel: channel)
            completion?(room, nil)
        }
    }

    /// RoomにLocalRoomMemberを作成し、入室させます。
    ///
    /// 1RoomインスタンスにJoinできるLocalRoomMemberは1人だけです。
    /// - Parameter options: Member初期化オプション
    /// - Returns: Member
    @available(iOS 13.0, *)
    @objc public override func join(with options: Room.MemberInitOptions?) async throws
        -> LocalP2PRoomMember
    {
        return try await super.join(with: options) as! LocalP2PRoomMember
    }

    /// RoomにLocalRoomMemberを作成し、入室させます。
    ///
    /// 1RoomインスタンスにJoinできるLocalRoomMemberは1人だけです。
    /// - Parameters:
    ///   - options: Member初期化オプション
    ///   - completion: 完了コールバック
    @objc public override func join(
        with options: MemberInitOptions?,
        completion: ((LocalP2PRoomMember?, Error?) -> Void)?
    ) {
        super.join(with: options) { member, error in
            if error != nil {
                completion?(nil, error)
                return
            }
            completion?(member as? LocalP2PRoomMember, nil)
        }
    }

    override init(channel: Channel) {
        super.init(channel: channel)
        channel.delegate = self
    }
}
