//
//  PearID.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

func getCurrentID(user: String, shortName: Bool) -> String? {
    
    let ids = getSystemUsersAndIdentities()
    var info = [OpenDirectoryUsers]()
    
    if shortName {
        info = ids.filter { $0.shortname == user }
    } else {
        info = ids.filter { $0.longname == user }
    }
    
    if let string = info.first?.uuid {
        return string
    }
    
    return nil
}
