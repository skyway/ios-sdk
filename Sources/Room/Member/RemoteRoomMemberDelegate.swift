//
//  RemoteRoomMemberDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import Foundation

/// RemoteRoomMemberイベントデリゲート
@objc public protocol RemoteRoomMemberDelegate: RoomMemberDelegate {
    /// RemoteRoomMemberがPublicationをSubscribeした時にコールされます。
    ///
    /// - Parameters:
    ///   - member: Member
    ///   - subscription: Subscribeした時のSubscription
    @objc optional func remoteRoomMember(
        _ member: RemoteRoomMember,
        didSubscribePublicationOf subscription: RoomSubscription
    )

    /// RemoteRoomMemberがPublicationをUnsubscribeした時にコールされます。
    ///
    /// - Parameters:
    ///   - member: Member
    ///   - subscription: Unsubscribeした時のSubscription
    @objc optional func remoteRoomMember(
        _ member: RemoteRoomMember,
        didUnsubscribePublicationOf subscription: RoomSubscription
    )
}
