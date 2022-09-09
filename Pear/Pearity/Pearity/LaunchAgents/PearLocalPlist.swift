//
//  PearLocalPlist.swift
//  Pearity
//
//  Created by Pierre Segula on 7/3/22.
//  Copyright © 2022 admin. All rights reserved.
//

import Foundation

class OpenAtLogin {
    static let users = "Users"
    static let libLaunchAgents = "Library/LaunchAgents"
    static let localFolder = "/\(users)/\(NSUserName())/\(libLaunchAgents)"

    class func writeLocalPlist() {

        let localPlist = PearityPlist(
            Label: "com.pearsecurity.Pearity",
            Program: "/Applications/Pearity.app/Contents/MacOS/Pearity",
            ProgramArguments: ["/Applications/Pearity.app/Contents/MacOS/Pearity"],
            LimitLoadToSessionType: "Aqua",
            RunAtLoad: true,
            LaunchOnlyOnce: true,
            KeepAlive: ["SuccessfulExit" : false]
        )
        
        guard
            let data = try? PropertyListEncoder().encode(localPlist),
            let file = URL(string: "file://\(localFolder)/com.pearsecurity.Pearity.plist")
        else {
            return
        }
        
        do  {
            try data.write(to: file)
        } catch {
            print(error)
        }

        runCommandReturnStr(binary: "/bin/chmod", arguments: ["755", "\(localFolder)/com.pearsecurity.Pearity.plist"])
    }

    class func removeLocalPlist() {
        runCommandReturnStr(binary: "/bin/rm", arguments: ["\(localFolder)/com.pearsecurity.Pearity.plist"])
    }

    class func checkIfLocalPlistExists() -> Bool {
        guard
            let file = URL(string: "file:///\(localFolder)/com.pearsecurity.Pearity.plist")
        else {
            return false
        }
        
        guard
            let _ = try? Data(contentsOf: file)
        else { return false }
        
        return true
    }

}
