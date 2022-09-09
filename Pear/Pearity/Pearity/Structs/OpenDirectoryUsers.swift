//
//  OpenDirectoryUsers.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

struct OpenDirectoryUsers {
    var identities: [String]
    var securetoken: Bool
    var shortname: String
    var longname: String
    var uuid: String
    var uid: Int
    var image: Data
}
