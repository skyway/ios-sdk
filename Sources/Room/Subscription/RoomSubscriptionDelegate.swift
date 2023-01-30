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
}
