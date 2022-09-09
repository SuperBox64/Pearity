//
//  main.swift
//  Pearity
//
//  Created by Pierre Segula on 6/5/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import Cocoa

private func config() {
    if isLoginWindowActive() {
        //removeTokenConfig()
        addTokenConfig()
    }
}

private func session() -> Bool {
    CGSessionCopyCurrentDictionary() != nil
}

private func mainApp() {
    let delegate = AppDelegate()
    NSApplication.shared.delegate = delegate
}

@discardableResult
func main() -> Int32 {
    NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}

private func launch() {
    var go = true
    while go {
        if session() {
            mainApp()
            main()
            go.toggle()
            break
        }
    }
}

launch()
