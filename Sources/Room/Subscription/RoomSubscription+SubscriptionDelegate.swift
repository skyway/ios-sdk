//
//  RoomSubscription+SubscriptionDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

extension RoomSubscription: SubscriptionDelegate {
    public func subscriptionCanceled(_ subscription: Subscription) {
        delegate?.subscriptionCancaled?(subscription.toRoomSubscription(room))
    }

    public func subscription(
        _ subscription: Subscription,
        connectionStateDidChange connectionState: ConnectionState
    ) {
        delegate?.subscription?(self, connectionStateDidChange: connectionState)
    }
}
