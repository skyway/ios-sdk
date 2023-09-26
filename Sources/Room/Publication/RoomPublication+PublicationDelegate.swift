//
//  RoomPublication+PublicationDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

extension RoomPublication: PublicationDelegate {
    public func publicationUnpublished(_ publication: Publication) {
        if shouldNotNotifyEventOnSFURoom(publication) {
            Logger.debug(
                message:
                    "In the case of `SFURoom`, the event of origin publication is not notified."
            )
            return
        }
        delegate?.publicationUnpublished?(self)
    }

    public func publicationSubscribed(_ publication: Publication) {
        delegate?.publicationSubscribed?(self)
    }

    public func publication(_ publication: Publication, subscribed subscription: Subscription) {
        let roomSubscription: RoomSubscription = subscription.toRoomSubscription(room)
        delegate?.publication?(self, subscribed: roomSubscription)
    }

    public func publicationUnsubscribed(_ publication: Publication) {
        delegate?.publicationUnsubscribed?(self)
    }

    public func publication(_ publication: Publication, unsubscribed subscription: Subscription) {
        let roomSubscription: RoomSubscription = subscription.toRoomSubscription(room)
        delegate?.publication?(self, unsubscribed: roomSubscription)
    }

    public func publicationSubscriptionListDidChange(_ publication: Publication) {
        delegate?.publicationSubscriptionListDidChange?(self)
    }

    public func publication(_ publication: Publication, didUpdateMetadata metadata: String) {
        delegate?.publication?(self, didUpdateMetadata: metadata)
    }

    public func publicationEnabled(_ publication: Publication) {
        if shouldNotNotifyEventOnSFURoom(publication) {
            Logger.debug(
                message:
                    "In the case of `SFURoom`, the event of origin publication is not notified."
            )
            return
        }
        delegate?.publicationEnabled?(self)
    }

    public func publicationDisabled(_ publication: Publication) {
        if shouldNotNotifyEventOnSFURoom(publication) {
            Logger.debug(
                message:
                    "In the case of `SFURoom`, the event of origin publication is not notified."
            )
            return
        }
        delegate?.publicationDisabled?(self)
    }

    public func publicationStateDidChange(_ publication: Publication) {
        if shouldNotNotifyEventOnSFURoom(publication) {
            Logger.debug(
                message:
                    "In the case of `SFURoom`, the event of origin publication is not notified."
            )
            return
        }
        delegate?.publicationStateDidChange?(self)
    }

    public func publication(
        _ publication: Publication,
        connectionStateDidChange connectionState: ConnectionState
    ) {
        delegate?.publication?(self, connectionStateDidChange: connectionState)
    }

    // RoomPublication subscribes both of origin and relayed publications on SFURoom.
    // Some same events are emitted simultaneously so filter one of them using this function.
    private func shouldNotNotifyEventOnSFURoom(_ publication: Publication) -> Bool {
        return room is SFURoom && (publication.origin == nil)
    }
}
