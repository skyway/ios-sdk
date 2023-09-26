//
//  Room+ChanngelDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/11/17.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

extension Room: ChannelDelegate {
    public func channelDidClose(_ channel: Channel) {
        // TODO: Dispose
        delegate?.roomDidClose?(self)
    }

    public func channel(_ channel: Channel, didUpdateMetadata metadata: String) {
        delegate?.room?(self, didUpdateMetadata: metadata)
    }

    public func channelMemberListDidChange(_ channel: Channel) {
        delegate?.roomMemberListDidChange?(self)
    }

    public func channel(_ channel: Channel, memberDidJoin member: Member) {
        delegate?.room?(self, memberDidJoin: member.toRoomMember(self))
    }

    public func channel(_ channel: Channel, memberDidLeave member: Member) {
        delegate?.room?(self, memberDidLeave: member.toRoomMember(self))
    }

    public func channel(_ channel: Channel, member: Member, metadataDidUpdate metadata: String) {
        delegate?.room?(self, member: member.toRoomMember(self), metadataDidUpdate: metadata)
    }

    public func channelPublicationListDidChange(_ channel: Channel) {
        delegate?.roomPublicationListDidChange?(self)
    }

    public func channel(_ channel: Channel, didPublishStreamOf publication: Publication) {
        delegate?.room?(self, didPublishStreamOf: publication.toRoomPublication(self))
    }

    public func channel(_ channel: Channel, didUnpublishStreamOf publication: Publication) {
        delegate?.room?(self, didUnpublishStreamOf: publication.toRoomPublication(self))
    }

    public func channel(_ channel: Channel, publicationDidChangeToEnabled publication: Publication)
    {
        delegate?.room?(self, publicationDidChangeToEnabled: publication.toRoomPublication(self))
    }

    public func channel(_ channel: Channel, publicationDidChangeToDisabled publication: Publication)
    {
        delegate?.room?(self, publicationDidChangeToDisabled: publication.toRoomPublication(self))
    }

    public func channel(
        _ channel: Channel,
        publication: Publication,
        metadataDidUpdate metadata: String
    ) {
        delegate?.room?(
            self,
            publication: publication.toRoomPublication(self),
            metadataDidUpdate: metadata
        )
    }

    public func channelSubscriptionListDidChange(_ channel: Channel) {
        delegate?.roomSubscriptionListDidChange?(self)
    }

    public func channel(_ channel: Channel, didSubscribePublicationOf subscription: Subscription) {
        delegate?.room?(self, didSubscribePublicationOf: subscription.toRoomSubscription(self))
    }

    public func channel(_ channel: Channel, didUnsubscribePublicationOf subscription: Subscription)
    {
        delegate?.room?(self, didUnsubscribePublicationOf: subscription.toRoomSubscription(self))
    }
}
