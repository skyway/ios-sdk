//
//  RoomMember.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/16.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

/// Roomに入室しているMemberの抽象クラス
@objc open class RoomMember: NSObject, Identifiable {
    /// 入室しているRoomのID
    @objc public let roomId: String
    /// 入室しているRoomの名前
    @objc public let roomName: String?
    /// 入室しているRoomの種別
    @objc public let roomType: RoomType

    /// Memberを識別するためのID
    @objc public var id: String {
        return core.id
    }

    /// Memberの名前
    @objc public var name: String? {
        return core.name
    }

    /// メタデータ
    @objc public var metadata: String? {
        return core.metadata
    }

    /// メンバーサイド
    ///
    /// このクライアントで生成されたメンバーの場合localになります。
    @objc public var side: Side {
        return core.side
    }

    /// ステート
    ///
    /// Leftの場合、このオブジェクトの操作は無効です。
    @objc public var state: MemberState {
        return core.state
    }

    /// Publish中のPublication一覧
    @objc public var publications: [RoomPublication] {
        return room?.publications.filter({ $0.publisher == self }) ?? []
    }

    /// Subscribe中のSubscription一覧
    @objc public var subscriptions: [RoomSubscription] {
        return core.subscriptions.map({ $0.toRoomSubscription(room) })
    }

    weak var _delegate: RoomMemberDelegate?

    let core: Member
    weak var room: Room?
    init(core: Member, room: Room) {
        self.roomId = room.id
        self.roomName = room.name
        self.roomType = (room is P2PRoom) ? .P2P : .SFU
        self.core = core
        self.room = room
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
        core.updateMetadata(metadata) { error in
            completion?(error)
        }
    }

    /// Roomから退出します。
    ///
    /// Memberを指定してRoomの`leave(_:)`をコールした時と同じ効果です。
    @available(iOS 13.0, *)
    @objc public func leave() async throws {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            self.leave { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    /// Roomから退出します。
    ///
    /// Memberを指定してRoomの`leave(_:)`をコールした時と同じ効果です。
    /// - Parameter completion: 完了コールバック
    @objc public func leave(completion: ((Error?) -> Void)?) {
        core.leave { error in
            guard error == nil else {
                completion?(error)
                return
            }
            completion?(nil)
        }
    }

    // MARK: - NSObject
    override open func isEqual(_ object: Any?) -> Bool {
        return (object as? RoomMember)?.id == self.id
    }

    open override var hash: Int {
        var hasher: Hasher = .init()
        id.hash(into: &hasher)
        return hasher.finalize()
    }
}

extension Member {
    func toRoomMember(_ room: Room) -> RoomMember {
        switch self {
        case is LocalPerson:
            if room is P2PRoom {
                return LocalP2PRoomMember.init(core: (self as! LocalPerson), room: room)
            } else if room is SFURoom {
                return LocalSFURoomMember.init(core: (self as! LocalPerson), room: room)
            }
        case is RemotePerson:
            return RemoteRoomMember.init(core: (self as! RemotePerson), room: room)
        default:
            break
        }
        return .init(core: self, room: room)
    }
}
