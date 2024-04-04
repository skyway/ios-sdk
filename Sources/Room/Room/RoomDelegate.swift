//
//  RoomDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/17.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import Foundation

/// Roomイベントデリゲート
@objc public protocol RoomDelegate: AnyObject {
    /// このRoomが閉じられた後にコールされるイベント
    ///
    /// - Parameter room: Room
    @objc optional func roomDidClose(_ room: Room)

    /// このRoomのMetadataが更新された後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - metadata: Metadata
    @objc optional func room(_ room: Room, didUpdateMetadata metadata: String)

    /// このRoomに参加しているMemberの数が変化した後に発生するイベント
    ///
    /// `room(_:memberDidJoin:)`または`room(_:memberDidLeave:)`がコールされた後にコールされます。
    ///
    /// - Parameter room: Room
    @objc optional func roomMemberListDidChange(_ room: Room)

    /// RoomにMemberが参加した後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - member: 参加したMember
    @objc optional func room(_ room: Room, memberDidJoin member: RoomMember)

    /// RoomからMemberが退出した後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - member: 退出したMember
    @objc optional func room(_ room: Room, memberDidLeave member: RoomMember)

    /// MemberのMetadataが更新された後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - member: 対象のMember
    ///   - metadata: 更新後のMetadata
    @objc optional func room(_ room: Room, member: RoomMember, metadataDidUpdate metadata: String)

    /// このRoomのPublicationの数が変化した後に発生するイベント
    ///
    /// `room(_:didPublishStreamOfPublication:)`または`room(_:didUnpublishStreamOfPublication:)`がコールされた後にコールされます。
    /// - Parameter room: Room
    @objc optional func roomPublicationListDidChange(_ room: Room)

    /// StreamがPublishされた後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - publication: 対象のPublication
    @objc optional func room(_ room: Room, didPublishStreamOf publication: RoomPublication)

    /// StreamがUnpublishされた後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - publication: 対象のPublication
    @objc optional func room(_ room: Room, didUnpublishStreamOf publication: RoomPublication)

    /// このRoomのPublicationが`Enabled`状態に変更された後に発生するイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - publication:対象のPublication
    @objc optional func room(
        _ room: Room,
        publicationDidChangeToEnabled publication: RoomPublication
    )

    /// このRoomのPublicationが`Disabled`状態に変更された後に発生するイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - publication: 対象のPublication
    @objc optional func room(
        _ room: Room,
        publicationDidChangeToDisabled publication: RoomPublication
    )

    /// PublicationのMetadataが更新された後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - publication: 対象のPublication
    ///   - metadata: 更新後のMetadata
    @objc optional func room(
        _ room: Room,
        publication: RoomPublication,
        metadataDidUpdate metadata: String
    )

    /// PublicationがSubscribeまたはUnsubscribeされた後に発生するイベント
    /// `room(_:didSubscribePublicationOf:)`または`room(_:UnsubscribePublicationOf:)`がコールされた後にコールされます。
    /// - Parameter room: Room
    @objc optional func roomSubscriptionListDidChange(_ room: Room)

    /// PublicationがSubscribeされた後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - subscription: 対象のSubscription LocalRoomMemberによるSubscribeである場合、まだstreamがsetされていない可能性があります。
    @objc optional func room(_ room: Room, didSubscribePublicationOf subscription: RoomSubscription)

    /// PublicationがUnsubscribeされた後にコールされるイベント
    ///
    /// - Parameters:
    ///   - room: Room
    ///   - subscription: 対象のSubscription
    @objc optional func room(
        _ room: Room,
        didUnsubscribePublicationOf subscription: RoomSubscription
    )
}
