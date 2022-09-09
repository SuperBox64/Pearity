//
//  getUID.swift
//  Pearity
//
//  Created by Pierre Segula on 7/2/22.
//  Copyright © 2022 admin. All rights reserved.
//

import Foundation

func getUID(user: String) -> Int? {
    let ids = getSystemUsersAndIdentities()
    var info = [OpenDirectoryUsers]()
    info = ids.filter { $0.shortname == user }
    return info.first?.uid
}
