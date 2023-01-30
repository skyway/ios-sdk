//
//  RoomMemberDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/18.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import Foundation

/// RoomMemberイベントデリゲート
@objc public protocol RoomMemberDelegate: AnyObject{
    /// RoomMemberがRoomから退出した後にコールされます。
    /// - Parameter member: Member
    @objc optional func memberDidLeave(_ member: RoomMember)

    /// Memberのメタデータが更新された後にコールされます。
    /// - Parameters:
    ///   - member: Member
    ///   - metatada: 更新後のMetada
    @objc optional func member(_ member: RoomMember, didUpdateMetadata metadata: String)

    /// RoomMemberがPublishしているStreamの数が変化した後にコールされます。
    /// - Parameter member: Member
    @objc optional func memberPublicationListDidChange(_ member: RoomMember)

    /// RoomMemberがSubscribeしているStreamの数が変化した後にコールされます。
    /// - Parameter member: Member
    @objc optional func memberSubscriptionListDidChange(_ member: RoomMember)
}
