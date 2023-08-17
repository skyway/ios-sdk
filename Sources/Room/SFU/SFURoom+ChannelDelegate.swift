//
//  SFURoom+ChannelDelegate.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore

extension SFURoom {
    override public func channelMemberListDidChange(_ channel: Channel) {
        // roomMemberListDidchange will be called on `memberDidJoin` and `memberDidLeave`
        return
    }
    override public func channel(_ channel: Channel, memberDidJoin member: Member) {
        guard member.type != .bot else {
            return
        }
        super.channel(channel, memberDidJoin: member)
        delegate?.roomMemberListDidChange?(self)
    }
    override public func channel(_ channel: Channel, memberDidLeave member: Member) {
        guard member.type != .bot else {
            return
        }
        super.channel(channel, memberDidLeave: member)
    }
    
    override public func channel(_ channel: Channel, member: Member, metadataDidUpdate metadata: String) {
        guard member.type != .bot else {
            return
        }
        super.channel(channel, member: member, metadataDidUpdate: metadata)
    }
    
    override public func channelPublicationListDidChange(_ channel: Channel) {
        //  roomPublicationListDidChange will be called on `didPublishStreamOf` and `didUnpublishStreamOf`
        return
    }
    
    override public func channel(_ channel: Channel, didPublishStreamOf publication: Publication) {
        guard publication.origin != nil else {
            return
        }
        // It should be relayed publication
        super.channel(channel, didPublishStreamOf: publication)
        delegate?.roomPublicationListDidChange?(self)
    }
    
    override public func channel(_ channel: Channel, didUnpublishStreamOf publication: Publication) {
        guard publication.origin != nil else {
            return
        }
        // It should be relayed publication
        self.onStreamUnpublished.forEach { (key: String, value: ((Publication) -> Void)) in
            value(publication)
        }
        super.channel(channel, didUnpublishStreamOf: publication)
        delegate?.roomPublicationListDidChange?(self)
    }
    
    override public func channel(_ channel: Channel, publicationDidChangeToEnabled publication: Publication) {
        guard publication.origin != nil else {
            return
        }
        // It should be relayed publication
        super.channel(channel, publicationDidChangeToEnabled: publication)
    }
    
    override public func channel(_ channel: Channel, publicationDidChangeToDisabled publication: Publication) {
        guard publication.origin != nil else {
            return
        }
        // It should be relayed publication
        super.channel(channel, publicationDidChangeToDisabled: publication)
    }
    
    override public func channel(_ channel: Channel, publication: Publication, metadataDidUpdate metadata: String) {
        guard let relayedPublication = channel.publications.first(where: { pub in
            // Evaluate the id of relayed publication
            return pub.origin?.id == publication.id
        }) else {
            return
        }
        super.channel(channel, publication: relayedPublication, metadataDidUpdate: metadata)
    }
    
    override public func channelSubscriptionListDidChange(_ channel: Channel) {
        //  roomSubscriptionListDidChange will be called on `didSubscribePublicationOf` and `didUnsubscribePublicationOf`
        return
    }
    
    override public func channel(_ channel: Channel, didSubscribePublicationOf subscription: Subscription) {
        guard subscription.subscriber?.type != .bot else {
            return
        }
        super.channel(channel, didSubscribePublicationOf: subscription)
        delegate?.roomSubscriptionListDidChange?(self)
    }
    
    override public func channel(_ channel: Channel, didUnsubscribePublicationOf subscription: Subscription) {
        guard subscription.subscriber?.type != .bot else {
            return
        }
        super.channel(channel, didUnsubscribePublicationOf: subscription)
        delegate?.roomSubscriptionListDidChange?(self)
    }
    // TODO: Impl enable/disable delegate functions
}
