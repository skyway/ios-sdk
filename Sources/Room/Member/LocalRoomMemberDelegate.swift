//
//  LocalRoomMemberDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import Foundation

/// LocalRoomMemberイベントデリゲート
@objc public protocol LocalRoomMemberDelegate: RoomMemberDelegate {
    ///  LocalRoomMemberがStreamをPublishした後にコールされます。
    ///
    /// - Parameters:
    ///   - member: Member
    ///   - publication: StreamをPublishした時のPublication
    @objc optional func localRoomMember(
        _ member: LocalRoomMember,
        didPublishStreamOf publication: RoomPublication
    )

    /// LocalRoomMemberがStreamをUnpublishした後にコールされます。
    ///
    /// - Parameters:
    ///   - member: Member
    ///   - publication: StreamをUnpublishした時のPublication
    @objc optional func localRoomMember(
        _ member: LocalRoomMember,
        didUnpublishStreamOf publication: RoomPublication
    )

    /// LocalRoomMemberがPublicationをSubscribeした後にコールされます。
    ///
    /// - Parameters:
    ///   - member: Member
    ///   - subscription: Subscribeした時のSubscription まだstreamがsetされていない可能性があります。
    @objc optional func localRoomMember(
        _ member: LocalRoomMember,
        didSubscribePublicationOf subscription: RoomSubscription
    )

    /// LocalRoomMemberがPublicationをUnsubscribeした後にコールされます。
    ///
    /// - Parameters:
    ///   - member: Member
    ///   - subscription: Unsubscribeした時のSubscription
    @objc optional func localRoomMember(
        _ member: LocalRoomMember,
        didUnsubscribePublicationOf subscription: RoomSubscription
    )
}
