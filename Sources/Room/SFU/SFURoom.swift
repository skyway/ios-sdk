//
//  SFURoom.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/01.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore
import SkyWaySFUBot

/// SFUサーバを介して通信を行うRoom
@objc open class SFURoom: Room {
    /// LocalMemberのUnpublish操作において、RelayedPublicationのUnpublish完了まで待つための内部コールバック
    var onStreamUnpublished: [String: ((Publication) -> Void)] = [:]

    /// Roomを作成します。
    /// - Parameters:
    ///   - options: `options`でRoomの名前を指定して作成できますが、同じ名前のRoomは作成することができません。
    ///   - sfuOptions: 内部向けオプションのため、設定は不要です。
    /// - Returns: Room
    @available(iOS 13.0, *)
    @objc public static func create(
        with options: InitOptions?,
        sfuOptions: SFUBotPluginOptions? = nil
    ) async throws -> SFURoom {
        try await withCheckedThrowingContinuation { continuation in
            Self.create(with: options, sfuOptions: sfuOptions) { room, error in
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
    ///   - sfuOptions: 内部向けオプションのため、設定は不要です。
    ///   - completion: 完了コールバック
    @objc public static func create(
        with options: InitOptions?,
        sfuOptions: SFUBotPluginOptions? = nil,
        completion: ((SFURoom?, Error?) -> Void)?
    ) {
        let plugin = Self.findOrRegisterPlugin(sfuOptions: sfuOptions)
        Channel.create(with: options?.toCore()) { (channel, error) in
            guard let channel = channel else {
                completion?(nil, error)
                return
            }
            plugin.createBot(on: channel) { (bot, error) in
                guard let _ = bot else {
                    completion?(nil, error)
                    return
                }
                let room: SFURoom = .init(channel: channel)
                completion?(room, nil)
            }
        }
    }

    /// Roomクエリを元にRoomを検索します。
    ///
    /// クエリはRoomのIDまたはNameを入力します。両方とも入力される場合はIDが優先されます。
    ///
    /// - Parameters:
    ///    - query: 検索クエリ
    ///    - sfuOptions: 内部向けオプションのため、設定は不要です。
    /// - Returns: Room
    @available(iOS 13.0, *)
    @objc public static func find(by query: Query, sfuOption: SFUBotPluginOptions? = nil)
        async throws
        -> SFURoom
    {
        try await withCheckedThrowingContinuation { continuation in
            Self.find(by: query, sfuOptions: sfuOption) { room, error in
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
    ///   - sfuOptions: 内部向けオプションのため、設定は不要です。
    ///   - completion: 完了コールバック
    @objc public static func find(
        by query: Query,
        sfuOptions: SFUBotPluginOptions? = nil,
        completion: ((SFURoom?, Error?) -> Void)?
    ) {
        let _ = Self.findOrRegisterPlugin(sfuOptions: sfuOptions)
        Channel.find(with: query.toCore()) { (channel, error) in
            guard let channel = channel else {
                completion?(nil, error)
                return
            }

            let room: SFURoom = .init(channel: channel)
            completion?(room, nil)
        }
    }

    /// Roomを名前から検索し、存在しない場合は作成します。
    ///
    /// - Parameters:
    ///    - options: 検索・初期化オプション
    ///    - sfuOptions: 内部向けオプションのため、設定は不要です。
    /// - Returns: Room
    @available(iOS 13.0, *)
    @objc public static func findOrCreate(
        with options: InitOptions,
        sfuOptions: SFUBotPluginOptions? = nil
    ) async throws -> SFURoom {
        try await withCheckedThrowingContinuation { continuation in
            Self.findOrCreate(with: options, sfuOptions: sfuOptions) { room, error in
                if let room = room {
                    continuation.resume(returning: room)
                } else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }

    /// Roomを名前から検索し、存在しない場合は作成します。
    /// - Parameters:
    ///   - options: 検索・初期化オプション
    ///   - sfuOptions: 内部向けオプションのため、設定は不要です。
    ///   - completion: 完了コールバック
    @objc public static func findOrCreate(
        with options: InitOptions,
        sfuOptions: SFUBotPluginOptions? = nil,
        completion: ((SFURoom?, Error?) -> Void)?
    ) {
        let plugin = Self.findOrRegisterPlugin(sfuOptions: sfuOptions)
        Channel.findOrCreate(with: options.toCore()) { (channel, error) in
            guard let channel = channel else {
                completion?(nil, error)
                return
            }
            let room: SFURoom = .init(channel: channel)
            if !channel.bots.isEmpty {
                completion?(room, nil)
                return
            }
            plugin.createBot(on: channel) { (bot, error) in
                guard let _ = bot else {
                    completion?(nil, error)
                    return
                }
                completion?(room, nil)
            }
        }
    }

    ///  RoomにLocalRoomMemberを作成し、入室させます。
    ///
    ///  1RoomインスタンスにJoinできるLocalRoomMemberは1人だけです。
    /// - Parameter options: Member初期化オプション
    /// - Returns: Member
    @available(iOS 13.0, *)
    @objc override public func join(with options: Room.MemberInitOptions?) async throws
        -> LocalSFURoomMember
    {
        return try await super.join(with: options) as! LocalSFURoomMember
    }

    /// RoomにLocalRoomMemberを作成し、入室させます。
    ///
    /// 1RoomインスタンスにJoinできるLocalRoomMemberは1人だけです。
    /// - Parameters:
    ///   - options: Member初期化オプション
    ///   - completion: 完了コールバック
    @objc override public func join(
        with options: Room.MemberInitOptions?,
        completion: ((LocalSFURoomMember?, Error?) -> Void)?
    ) {
        super.join(with: options) { member, error in
            if error != nil {
                completion?(nil, error)
                return
            }
            completion?(member as? LocalSFURoomMember, nil)
        }
    }

    override init(channel: Channel) {
        super.init(channel: channel)
        channel.delegate = self
    }

    /// 入室しているメンバーの一覧
    override public var members: [RoomMember] {
        return channel.members
            .filter({ $0.type != .bot })
            .map({ $0.toRoomMember(self) })
    }

    /// このRoomでPublishされているStreamのPublication一覧
    override public var publications: [RoomPublication] {
        // Return only relayed pulications
        return channel.publications
            .filter({ $0.origin != nil })
            .map({ $0.toRoomPublication(self) })
    }

    /// このRoomでSubscribeされているSubscription一覧
    override public var subscriptions: [RoomSubscription] {
        // Return only person's subscriptions
        return channel.subscriptions
            .filter({ $0.subscriber?.type != .bot })
            .map({ $0.toRoomSubscription(self) })
    }

    private static func findOrRegisterPlugin(sfuOptions: SFUBotPluginOptions?) -> SFUBotPlugin {
        if let plugin = Context.plugins.first(where: { $0.subtype == "sfu" }) as? SFUBotPlugin {
            return plugin
        }
        let plugin: SFUBotPlugin = .init(options: sfuOptions)
        Context.registerPlugin(plugin)
        return plugin
    }
}
