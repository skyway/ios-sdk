//
//  Room.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/16.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore


/// ルームの状態
@objc public enum RoomState: Int{
    /// オープン状態
    ///
    /// アクティブでRoomおよび、Roomで管理しているリソースが有効です
    case opened
    /// クローズ状態
    ///
    /// 非アクティブでRoomおよびRoomで管理しているリソースが無効です
    ///
    /// この状態の時、Roomオブジェクトは利用できません
    case closed
    static func Create(core: ChannelState) -> RoomState {
        switch(core) {
        case .Opened:
            return Self.opened
        case .Closed:
            return Self.closed
        default:
            return Self.closed
        }
    }
}

/// Room抽象クラス
///
/// RoomとはCore SDKのChannelのラッパークラスです。
///
/// Room SDKをご利用いただく場合はChannelというドメインは隠蔽されているので、ChannelではなくRoomを扱います。
///
/// RoomにはP2PRoomとSFURoomが存在し、ユースケースに応じて選択してください。
///
/// RoomにはMemberが入退出できます。Room作成時点のように、Memberのいない状態のRoomも存在できます。
///
/// 詳しくは公式ホームページのドキュメントをご確認ください。
@objc open class Room: NSObject, Identifiable {
    /// Room初期化オプション
    @objc public class InitOptions: NSObject {
        /// Roomの名前
        ///
        /// 名前はユニークである必要があります。
        public var name: String?
        /// メタデータ
        public var metadata: String?
        func toCore() -> ChannelInit {
            let core: ChannelInit = .init()
            core.name = name
            core.metadata = metadata
            return core
        }
    }
    /// Room検索クエリ
    @objc public class Query: NSObject {
        /// RoomのID
        public var id: String?
        /// Roomの名前
        public var name: String?
        func toCore() -> ChannelQuery {
            let core: ChannelQuery = .init()
            core.id = id
            core.name = name
            return core
        }
    }
    
    /// RoomMember初期化オプション
    @objc public class MemberInitOptions: NSObject {
        /// Memberの名前
        public var name: String?
        /// メタデータ
        public var metadata: String?
        /// MemberのKeepAliveの更新間隔時間(秒)
        ///
        /// デフォルトは30秒です。
        ///
        /// MemberがそのRoomに存在するかどうかはSkyWayサーバで管理しています。
        ///
        /// Memberの退出はMemberの`leave()`または、権限があればRoomの`leave(_:)`でも退出させることができますが、退出処理を行わずアプリケーションがクラッシュした時、SkyWayを終了した時などは情報に不整合が発生し、RemoteMemberから見るとまだRoomに存在するように見えます。
        ///
        /// このオプションではSkyWayサーバとのkeepalive時間を設定することでその不整合が起こる時間を設定できます。
        ///
        /// 短すぎる設定では、頻繁にサーバに対してリクエストをすることになるのでパフォーマンスが低下する恐れがあります。
        public var keepaliveIntervalSec: Int32 = 0
        func toCore() -> MemberInit {
            let core: MemberInit = .init()
            core.name = name
            core.metadata = metadata
            core.keepaliveIntervalSec = keepaliveIntervalSec
            return core
        }
    }
    
    /// Roomを識別するID
    @objc public var id: String {
        get {
            return channel.id
        }
    }
    
    /// Roomの名前
    @objc public var name: String? {
        get {
            return channel.name
        }
    }
    
    /// メタデータ
    @objc public var metadata: String? {
        get {
            return channel.metadata
        }
    }
    
    
    /// ステート
    ///
    /// closedの場合、このオブジェクトの操作は無効です。
    @objc public var state: RoomState {
        get {
            return RoomState.Create(core: channel.state)
        }
    }
    
    
    /// 入室しているメンバーの一覧
    @objc public var members: [RoomMember] {
        get {
            return channel.members.map({ $0.toRoomMember(self) })
        }
    }
    
    
    /// このRoomでPublishされているStreamのPublication一覧
    @objc public var publications: [RoomPublication] {
        get {
            return channel.publications.map({ $0.toRoomPublication(self) })
        }
    }
    
    
    /// このRoomでSubscribeされているSubscription一覧
    @objc public var subscriptions: [RoomSubscription] {
        get {
            return channel.subscriptions.map({ $0.toRoomSubscription(self) })
        }
    }
    
    /// イベントデリゲート
    @objc public weak var delegate: RoomDelegate?
    
    let channel: Channel
    init(channel: Channel) {
        self.channel = channel
        super.init()
        self.channel.delegate = self
    }
    
    /// RoomにLocalRoomMemberを作成し、入室させます。
    ///
    /// 1RoomインスタンスにJoinできるLocalRoomMemberは1人だけです。
    /// - Parameter options: Member初期化オプション
    /// - Returns: LocalRoomMember
    @available(iOS 13.0, *)
    @objc public func join(with options: MemberInitOptions?) async throws -> LocalRoomMember {
        try await withCheckedThrowingContinuation { continuation in
            self.join(with: options) { member, error in
                if let member = member {
                    continuation.resume(returning: member)
                }else {
                    continuation.resume(throwing: error!)
                }
            }
        }
    }
    
    /// RoomにLocalRoomMemberを作成し、入室させます。
    ///
    /// 1RoomインスタンスにJoinできるLocalRoomMemberは1人だけです。
    /// - Parameters:
    ///   - options: Member初期化オプション
    ///   - completion: 完了コールバック
    @objc public func join(with options: MemberInitOptions?, completion:((LocalRoomMember?, Error?) -> Void)?) {
        let _options: MemberInitOptions = options ?? .init()
        if _options.name == nil {
            _options.name = UUID().uuidString.lowercased()
        }
        channel.join(with: _options.toCore()) { (person, error) in
            guard let person = person else {
                completion?(nil, error)
                return
            }
            let roomMember = person.toRoomMember(self)
            completion?((roomMember as? LocalRoomMember), nil)
        }
    }
    
    /// RoomからMemberを退出させます。
    ///
    /// 権限があればLocalRoomMemberだけでなく、RemoteRoomMemberも退出させることができます。
    ///
    /// - Parameter member: 退出するMember
    @available(iOS 13.0, *)
    @objc public func leave(_ member: RoomMember) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.leave(member, completion: { error in
                if let error = error {
                    continuation.resume(throwing: error)
                }else {
                    continuation.resume()
                }
            })
        }
    }
    
    /// RoomからMemberを退出させます。
    ///
    /// 権限があればLocalRoomMemberだけでなく、RemoteRoomMemberも退出させることができます。
    ///
    /// - Parameter member: 退出するMember
    /// - Parameter completion: 完了コールバック
    @objc public func leave(_ member: RoomMember, completion: ((Error?)->Void)?) {
        channel.leaveMember(member.core, completion: completion)
    }
    
    
    
    /// Roomを閉じます。
    ///
    /// `dispose()`とは異なり、Roomを閉じると参加しているMemberは全て退出し、Roomは破棄されます。
    ///
    /// 入室している全てのMemberがPublishとSubscribeをしている場合は中止してから退出します。
    ///
    /// Close後のRoomインスタンスおよび、そのRoomで生成されたインスタンス(Publication etc.)は利用できません。
    ///
    /// インスタンスにアクセスした場合、クラッシュする可能性があります。
    @available(iOS 13.0, *)
    @objc public func close() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.close(completion: { error in
                if let error = error {
                    continuation.resume(throwing: error)
                }else {
                    continuation.resume()
                }
            })
        }
    }
    
    /// Roomを閉じます。
    ///
    /// `dispose()`とは異なり、Roomを閉じると参加しているMemberは全て退出し、サーバ上におけるRoomは破棄されます。
    ///
    /// 入室している全てのMemberがPublishとSubscribeをしている場合は中止してから退出します。
    ///
    /// Close後のRoomインスタンスおよび、そのRoomで生成されたインスタンス(Publication etc.)は利用できません。
    ///
    /// インスタンスにアクセスした場合、クラッシュする可能性があります。
    /// - Parameter completion: 完了コールバック
    @objc public func close(completion: ((Error?)->Void)?) {
        channel.close(completion: completion)
    }
    
    /// Roomを閉じずにRoomインスタンスを無効にし、リソースを解放します。
    ///
    /// `close()`とは異なり、Roomは破棄しないため入室しているMemberには影響しません。
    ///
    /// Dispose完了後にSDKで生成されたリソースにアクセスしないでください。クラッシュする可能性があります。
    @available(iOS 13.0, *)
    @objc public func dispose() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.dispose(completion: { error in
                if let error = error {
                    continuation.resume(throwing: error)
                }else {
                    continuation.resume()
                }
            })
        }
    }
    
    /// Roomを閉じずにRoomインスタンスを無効にし、リソースを解放します。
    ///
    /// `close()`とは異なり、Roomは破棄しないため入室しているMemberには影響しません。
    ///
    /// Dispose完了後にSDKで生成されたリソースにアクセスしないでください。クラッシュする可能性があります。
    @objc public func dispose(completion: ((Error?)->Void)?) {
        channel.dispose(completion: completion)
    }
    
    
    // MARK: - NSObject
    override open func isEqual(_ object: Any?) -> Bool {
        return (object as? Room)?.id == self.id
    }
    
    open override var hash: Int {
        var hasher: Hasher = .init()
        id.hash(into: &hasher)
        return hasher.finalize()
    }
}



