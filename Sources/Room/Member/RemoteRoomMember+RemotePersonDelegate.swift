//
//  RemoteRoomMember+RemotePersonelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

extension RemoteRoomMember: RemotePersonDelegate {
    public func memberDidLeave(_ member: Member) {
        self.delegate?.memberDidLeave?(self)
    }
    
    public func member(_ member: Member, didUpdateMetadata metatada: String) {
        self.delegate?.member?(self, didUpdateMetadata: metatada)
    }
    
    public func memberPublicationListDidChanged(_ member: Member) {
        self.delegate?.memberPublicationListDidChange?(self)
    }
    
    public func memberSubscriptionListDidChanged(_ member: Member) {
        self.delegate?.memberSubscriptionListDidChange?(self)
    }
    
    public func remotePerson(_ remotePerson: RemotePerson, didSubscribePublicationOf subscription: Subscription) {
        self.delegate?.remoteRoomMember?(self, didSubscribePublicationOf: subscription.toRoomSubscription(room))
    }
    
    public func remotePerson(_ remotePerson: RemotePerson, didUnsubscribePublicationOf subscription: Subscription) {
        self.delegate?.remoteRoomMember?(self, didUnsubscribePublicationOf: subscription.toRoomSubscription(room))
    }
}

