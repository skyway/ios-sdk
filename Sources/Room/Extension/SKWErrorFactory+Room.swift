//
//  SKWErrorFactory+Room.swift
//  SkyWayRoom
//
//  Created by Naoto Takahashi on 2023/08/10.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

import SkyWayCore

enum RoomErrorCode: Int {
    case localSfuRoomMemberUnublishError = 500
}

extension SKWErrorFactory {
    static func localSfuRoomMemberUnublishError() -> Error {
        let bundle: Bundle = .init(for: Room.self)
        return NSError(domain: bundle.bundleIdentifier!, code: RoomErrorCode.localSfuRoomMemberUnublishError.rawValue)
    }
}
