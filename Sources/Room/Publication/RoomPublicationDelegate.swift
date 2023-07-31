//
//  RoomPublicationDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import Foundation

/// RoomPublicationイベントデリゲート
@objc public protocol RoomPublicationDelegate: AnyObject{
    /// PublicationがUnpublishされた後にコールされるイベント
    ///
    /// - Parameter publication: RoomPublication
    @objc optional func publicationUnpublished(_ publication: RoomPublication)
    
    /// PublicationがRoomMemberにSubscribeされた後にコールされるイベント
    ///
    /// - Parameter publication: RoomPublication
    @objc optional func publicationSubscribed(_ publication: RoomPublication)
    
    /// PublicationがRoomMemberにUnsubscribeされた後にコールされるイベント
    ///
    /// - Parameter publication: RoomPublication
    @objc optional func publicationUnsubscribed(_ publication: RoomPublication)
    
    /// Publicationに紐づくSubscriptionの数が変化した後にコールされるイベント
    ///
    /// - Parameter publication: RoomPublication
    @objc optional func publicationSubscriptionListDidChange(_ publication: RoomPublication)

    /// PublicationのMetadataが更新された後にコールされるイベント
    ///
    /// - Parameters:
    ///   - publication: RoomPublication
    ///   - metadata: 更新後のMetadata
    @objc optional func publication(_ publication: RoomPublication, didUpdateMetadata metadata: String)
    
    /// Publicationが有効状態に変化した後にコールされるイベント
    ///
    /// - Parameter publication: RoomPublication
    @objc optional func publicationEnabled(_ publication: RoomPublication)

    /// Publicationが無効状態に変化した後にコールされるイベント
    ///
    /// - Parameter publication: RoomPublication
    @objc optional func publicationDisabled(_ publication: RoomPublication)
    
    /// Publicationの状態(Enabled, Disabled, Canceled)が変化した後にコールされるイベント
    ///
    /// - Parameter publication: RoomPublication
    @objc optional func publicationStateDidChange(_ publication: RoomPublication)
    
    /// Publicationの接続状態が変化した後にコールされるイベント
    /// - Parameters:
    ///   - publication: RoomPublication
    ///   - connectionState: 接続状態
    @objc optional func publication(_ publication: RoomPublication, connectionStateDidChange connectionState: ConnectionState)
}
