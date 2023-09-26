//
//  LocalRoomMember+LocalPersonDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

extension LocalRoomMember: LocalPersonDelegate {
    public func memberDidLeave(_ member: Member) {
        delegate?.memberDidLeave?(self)
    }

    public func member(_ member: Member, didUpdateMetadata metatada: String) {
        delegate?.member?(self, didUpdateMetadata: metatada)
    }

    public func memberPublicationListDidChange(_ member: Member) {
        delegate?.memberPublicationListDidChange?(self)
    }

    public func memberSubscriptionListDidChange(_ member: Member) {
        delegate?.memberSubscriptionListDidChange?(self)
    }

    public func localPerson(_ localPerson: LocalPerson, didPublishStreamOf publication: Publication)
    {
        delegate?.localRoomMember?(self, didPublishStreamOf: publication.toRoomPublication(room))
    }

    public func localPerson(
        _ localPerson: LocalPerson,
        didUnpublishStreamOf publication: Publication
    ) {
        delegate?.localRoomMember?(self, didUnpublishStreamOf: publication.toRoomPublication(room))
    }

    public func localPerson(
        _ localPerson: LocalPerson,
        didSubscribePublicationOf subscription: Subscription
    ) {
        delegate?.localRoomMember?(
            self,
            didSubscribePublicationOf: subscription.toRoomSubscription(room)
        )
    }

    public func localPerson(
        _ localPerson: LocalPerson,
        didUnsubscribePublicationOf subscription: Subscription
    ) {
        delegate?.localRoomMember?(
            self,
            didUnsubscribePublicationOf: subscription.toRoomSubscription(room)
        )
    }

}
