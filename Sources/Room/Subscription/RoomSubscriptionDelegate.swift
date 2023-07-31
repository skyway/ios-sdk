//
//  RoomSubscriptionDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import Foundation

/// RoomSubscriptionイベントデリゲート
@objc public protocol RoomSubscriptionDelegate: AnyObject{
    
    /// RoomSubscriptionがUnsubscribeされCanceled状態に変化した後にコールされます。
    ///
    /// - Parameter subscription: RoomSubscription
    @objc optional func subscriptionCancaled(_ subscription: RoomSubscription)
    
    /// RoomSubscriptionの接続状態が変化した後にコールされるイベント
    ///
    /// - Parameters:
    ///   - subscription: RoomSubscription
    ///   - connectionState: 接続状態
    @objc optional func subscription(_ subscription: RoomSubscription, connectionStateDidChange connectionState: ConnectionState)
}
