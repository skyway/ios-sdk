//
//  LocalSFURoomMember.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2022/12/05.
//  Copyright © 2022 NTT Communications. All rights reserved.
//

import SkyWayCore
import SkyWaySFUBot

/// SFURoomのLocalMember
@objc open class LocalSFURoomMember: LocalRoomMember {
    let bot: SFUBotMember
    override init(core: LocalPerson, room: Room) {
        bot = room.channel.members.first(where: { $0 is SFUBotMember }) as! SFUBotMember
        super.init(core: core, room: room)
    }
        
    /// 入室しているRoomにStreamをPublishします。
    ///
    /// Streamは各種Sourceから作成できます。
    ///
    /// 同じインスタンスのStreamを複数回Publishすることはできません。必要ならば各種Sourceから再度作成してPublishしてください。
    ///
    /// SFURoomではコーデック指定されたPublishはサポートされていませんので、`options.codecCapabilities`が指定されている場合、失敗します。
    ///
    /// また、maxFramerateを複数設定したPublish(サイマルキャスト)は利用できません。
    ///
    /// オプションについては Core SDK のリファレンスもご確認ください。
    ///
    /// - Parameters:
    ///   - stream: PublishするStream
    ///   - options: Publishオプション
    ///   - completion: 完了コールバック
    @objc override public func publish(_ stream: LocalStream, options: RoomPublicationOptions?, completion:((RoomPublication?, Error?)->Void)?) {
        let person = core as! LocalPerson
        person.publish(stream, options: options) { (publication, error) in
            guard let publication = publication else {
                completion?(nil, error)
                return
            }
            let forwardingConfigure: ForwardingConfigure = .init()
            forwardingConfigure.maxSubscribers = options?.maxSubscribers ?? 10
            self.bot.startForwarding(publication, configure: forwardingConfigure) { (forwarding, error) in
                guard let forwarding = forwarding else {
                    completion?(nil, error)
                    return
                }
                completion?(forwarding.relayingPublication.toRoomPublication(self.room), nil)
            }
        }
    }
    
    /// Publishを停止します。
    ///
    /// - Parameters:
    ///   - publicationId: 停止するPublicationのID
    ///   - completion: 完了コールバック
    @objc override public func unpublish(publicationId: String, completion:((Error?)->Void)?){
        // Convert relayed publication id(forwarding id) to origin id
        let person = core as! LocalPerson
        guard let publication = self.room?.channel.publications.first(where: { $0.id == publicationId }),
              let origin = publication.origin else {
            return
        }
        guard let room = (room as? SFURoom) else {
            return
        }
        room.onStreamUnpublished = { publication in
            if publication.id == publicationId {
                completion?(nil)
                room.onStreamUnpublished = nil
            }
        }
        person.unpublish(publicationID: origin.id, completion: nil)

    }
}
