//
//  GetLongName.swift
//  Pearity
//
//  Created by Pierre Segula on 5/31/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

func getLongName(user: String) -> String? {
    let ids = getSystemUsersAndIdentities()
    var info = [OpenDirectoryUsers]()
    info = ids.filter { $0.shortname == user }
    return info.first?.longname
}
