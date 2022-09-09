//
//  AppDelegate.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Cocoa
import AppKit
import SwiftUI
import CryptoTokenKit
import CryptoKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBar?
    let root = "root"
    let errorMsg = "Running as root is forbidden"
    let useOverlay = false // use true to test overlay in user environment
    
    func unlockScreenNotification() {
        DistributedNotificationCenter.default().addObserver(forName: NSNotification.Name(rawValue: "com.apple.shieldWindowLowered"), object: nil, queue: .main) { unidentifiedFlying in
            
            let uid = getUID(user: NSUserName())
            let ufo = unidentifiedFlying.object as? String

            //MARK: If the user matches reinsert the card
            if let uid = uid, let ufo = ufo, uid == Int(ufo) {
                let id = getCurrentID(user: NSUserName(), shortName: true) ?? NSUserName()
                guard var pearPki = readSmartCard(currentUser: id) else { return }
                
                pearPki.card = true
                smartCardMenuItem.state = .on

                SmartCard.smartCardMenuBar(pearPki: pearPki)
                writeSmartCard(pearPki: pearPki, currentUser: id)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if isLoginWindowActive() || useOverlay {
            PearListener().startListening()
            PearListener().screenSizeChanged()
            window.backgroundColor = NSColor.clear
            window.styleMask = [.unifiedTitleAndToolbar, .fullSizeContentView]
            window.backingType = .buffered
            window.title = ""
            window.canBecomeVisibleWithoutLogin = true
            window.hidesOnDeactivate = false
            window.isMovable = false
            window.hasShadow = false
            window.isOpaque = true
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = false
            window.level = .mainMenu
            NSApp.presentationOptions = [.hideDock, .hideMenuBar]
            window.contentViewController = NSHostingController(rootView: PearView())
            PearListener().updateWindow()
            window.makeKeyAndOrderFront(true)
            NSApp.deactivate()
        } else if NSUserName() != root {
            
            // Refresh Card
            runCommandReturnStr(binary: "/usr/bin/killall", arguments: ["ctkd"])

            let id = getCurrentID(user: NSUserName(), shortName: true) ?? NSUserName()

            if let pearPki = readSmartCard(currentUser: id) {
                syncSmartCard(pearPki, pearPki.card)
            } else if let pearPki = setDefaults() {
                syncSmartCard(pearPki, pearPki.card)
                writeSmartCard(pearPki: pearPki, currentUser: id)
            }
            statusBar = StatusBar()
        } else {
            let alert = NSAlert()
            alert.messageText = pearity
            alert.informativeText = errorMsg
            let window = NSWindow()
            window.level = .popUpMenu
            window.center()
            window.alphaValue = 0
            alert.beginSheetModal(for: window) { (response) in
                exit(0)
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {

        if isLoginWindowActive() {
            addTokenConfig()
        }
        
        window.alphaValue = 0
        window.viewsNeedDisplay = true
        window.hidesOnDeactivate = true
        NSApp.deactivate()
    }
}

func quitApp(_ sender: Any) {
    
    if isLoginWindowActive() {
        addTokenConfig()
    }
    
    NSApp.terminate(sender)
}

