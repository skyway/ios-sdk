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
        delegate?.publicationUnpublished?(self)
    }
    
    public func publicationSubscribed(_ publication: Publication) {
        delegate?.publicationSubscribed?(self)
    }
    
    public func publicationUnsubscribed(_ publication: Publication) {
        delegate?.publicationUnsubscribed?(self)
    }
    
    public func publicationSubscriptionListDidChange(_ publication: Publication) {
        delegate?.publicationSubscriptionListDidChange?(self)
    }
    
    public func publication(_ publication: Publication, didUpdateMetadata metadata: String) {
        delegate?.publication?(self, didUpdateMetadata: metadata)
    }
    
    public func publicationEnabled(_ publication: Publication) {
        delegate?.publicationEnabled?(self)
    }
    
    public func publicationDisabled(_ publication: Publication) {
        delegate?.publicationDisabled?(self)
    }
    
    public func publicationStateDidChange(_ publication: Publication) {
        delegate?.publicationStateDidChange?(self)
    }
    
    
}
