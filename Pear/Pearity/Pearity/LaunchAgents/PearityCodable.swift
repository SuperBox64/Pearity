//
//  PearityCodable.swift
//  Pearity
//
//  Created by Pierre Segula on 6/20/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

struct PearityPlist: Codable {
    var Label:                  String          // "com.pearsecurity.Pearity"
    var Program:                String          // "Applications/Pearity.app/Contents/MacOS/Pearity"
    var ProgramArguments:       [String]        // ["/Applications/Pearity.app/Contents/MacOS/Pearity"]
    var LimitLoadToSessionType: String          // "LoginWindow" (global), "Aqua" (local)
    var RunAtLoad:              Bool            // true
    var LaunchOnlyOnce:         Bool            // true
    var KeepAlive:              [String:Bool]   // false
}
