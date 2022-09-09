//
//  LoginWindow.swift
//  Pearity
//
//  Created by Pierre Segula on 7/3/22.
//  Copyright © 2022 admin. All rights reserved.
//

import Foundation

class LoginWindow {
    static let libLaunchAgents = "Library/LaunchAgents"
    static let globalFolder = "/\(libLaunchAgents)"
    static let label = "com.pearsecurity.Pearity"
    class func writeGlobalPlist() {

        let localPlist = PearityPlist(
            Label: "\(label)",
            Program: "/Applications/Pearity.app/Contents/MacOS/Pearity",
            ProgramArguments: ["/Applications/Pearity.app/Contents/MacOS/Pearity"],
            LimitLoadToSessionType: "LoginWindow",
            RunAtLoad: true,
            LaunchOnlyOnce: true,
            KeepAlive: ["SuccessfulExit" : false]
        )
        
        guard
            let data = try? PropertyListEncoder().encode(localPlist),
            let file = URL(string: "file://\(globalFolder)/\(label).plist")
        else {
            return
        }
        
        do  {
            try data.write(to: file)
        } catch {
            print(error)
        }

        runCommandReturnStr(binary: "/usr/bin/killall", arguments: ["-9","ctkd","ctkahp"])
        runCommandReturnStr(binary: "/bin/chmod", arguments: ["755", "\(globalFolder)/\(label).plist"])
        runCommandReturnStr(binary: "/usr/bin/defaults", arguments: ["write", "/Library/Preferences/com.apple.loginwindow", "PowerOffDisabled", "1"])
        runCommandReturnStr(binary: "/usr/bin/defaults", arguments: ["write", "/Library/Preferences/com.apple.loginwindow", "DisableFDEAutoLogin", "1"])
        runCommandReturnStr(binary: "/usr/sbin/diskutil", arguments: ["apfs", "updatepreboot", "/"])
    }

    class func removeGlobalPlist() {
        runCommandReturnStr(binary: "/usr/bin/killall", arguments: ["-9","ctkd","ctkahp"])
        runCommandReturnStr(binary: "/bin/rm", arguments: ["\(globalFolder)/\(label).plist"])
        runCommandReturnStr(binary: "/usr/bin/defaults", arguments: ["write", "/Library/Preferences/com.apple.loginwindow", "PowerOffDisabled", "0"])
        runCommandReturnStr(binary: "/usr/bin/defaults", arguments: ["write", "/Library/Preferences/com.apple.loginwindow", "DisableFDEAutoLogin", "0"])
        runCommandReturnStr(binary: "/usr/sbin/diskutil", arguments: ["apfs", "updatepreboot", "/"])
    }

    class func checkIfGlobalPlistExists() -> Bool {
        guard
            let file = URL(string: "file:///\(globalFolder)/\(label).plist")
        else {
            return false
        }
        
        guard
            let _ = try? Data(contentsOf: file)
        else { return false }
        
        return true
    }
}
