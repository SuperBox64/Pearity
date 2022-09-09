//
//  StatusBar.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import AppKit
import SwiftUI
import CryptoTokenKit
import FileProvider

let smartCardMenuItem = NSMenuItem()
let openAtLoginMenuItem = NSMenuItem()
let openAtLoginWindow = NSMenuItem()

class StatusBar {
    private var statusItem: NSStatusItem
    private var mainMenu = NSMenu()
    private var popover = NSPopover()
        
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength:20)
        createMenu()
    }

    //MARK: Show PIN Menu
    @objc func showPopover(_ sender: Any?) {
        let pearityReason = "authenticate your user in order to update or change the SmartCard PIN. Upon success, Pearity will open the PIN widget"
        let scmesgReason  = "Pearity is trying to \(pearityReason)"
        let showPopover   = pearBioPrompt(reason: pearityReason, scmesg: scmesgReason)
        
        if showPopover, let statusBarButton = statusItem.button, !popover.isShown {
                let pinView = PinView.init(popover: popover)
                let menuBounds = CGRect(x: 0, y: 1, width: 1, height: 10)
                popover.contentSize = NSSize(width: 5, height: 1)
                popover.contentViewController = NSHostingController(rootView: pinView)
                popover.behavior = .applicationDefined
                popover.animates = true
                popover.setValue(true, forKeyPath: "shouldHideAnchor")
                popover.show(relativeTo: menuBounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
            }
        }
    
    //MARK: Hide PIN Menu
//    @objc func hidePopover(_ sender: Any?) {
//            popover.performClose(sender)
//    }
    
    @objc public func openUrl(_ sender: Any?) {
        if let url = URL(string: "https://www.google.com") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc public func smartCardAction(_ sender: Any?) {
        let id = getCurrentID(user: NSUserName(), shortName: true) ?? NSUserName()
        guard var pearPki = readSmartCard(currentUser: id) else { return }
      
        smartCardMenuItem.state = smartCardMenuItem.state == .off ? .on : .off
        pearPki.card = smartCardMenuItem.state == .on

        SmartCard.smartCardMenuBar(pearPki: pearPki)
        writeSmartCard(pearPki: pearPki, currentUser: id)
    }
    
    @objc public func pairSmartCard(_ sender: Any?) {
        smartCardMenuItem.state = .on

        DispatchQueue.main.async {
            pearCard()
        }
    }

    @objc public func unPairSmartCard(_ sender: Any?) {
        smartCardMenuItem.state = .off
        DispatchQueue.main.async {
            unPearCard()
        }
    }
        
    @objc public func openAtLogin(_ sender: Any?) {
        openAtLoginMenuItem.state = openAtLoginMenuItem.state == .on ? .off : .on
        openAtLoginMenuItem.state == .on ? OpenAtLogin.writeLocalPlist() : OpenAtLogin.removeLocalPlist()
    }

    @objc public func loginWindow(_ sender: Any?) {
        openAtLoginWindow.state = openAtLoginWindow.state == .on ? .off : .on
        openAtLoginWindow.state == .on ? loginWindowOn() : loginWindowOff()
        
        
    }
    
    func loginWindowOn() {
        guard let pear = getBundlePath(resource: "pear") else { return }
        
        message = "Pearity wants to install the login window widget."
        
        do {
            try _ = Auth.executeWithPrivileges("\(pear) -i").get()
        } catch {
            return
        }
           
        openAtLoginWindow.state = .on
    }
    
    func loginWindowOff() {
        guard let pear = getBundlePath(resource: "pear") else { return }
        
        message = "Pearity wants to remove the login window widget."
        
        do {
            try _ = Auth.executeWithPrivileges("\(pear) -r").get()
        } catch {
            print(error)
            return

        }
       
        openAtLoginWindow.state = .off
    }
    
    @objc public func quitAction(_ sender: Any?) {
        quitApp(self)
    }
    
    private func createMenu() {
        statusItem.button?.title = "🍐" //"e"
        //statusItem.button?.font = NSFont(name: "e", size:20)
        let pearity = NSMenuItem()
        pearity.title = "About Pearity"
        pearity.target = self
        pearity.action = #selector(openUrl(_:))
        pearity.keyEquivalent = "a"
        pearity.offStateImage = NSImage(
            systemSymbolName: "info.circle",
            accessibilityDescription: "About Pearity"
        )
        
        pearity.indentationLevel = 1
        let quitMenuItem = NSMenuItem()
        
        smartCardMenuItem.onStateImage = NSImage(
            systemSymbolName: "checkmark",
            accessibilityDescription: "smartcard on"
        )
        
        smartCardMenuItem.offStateImage = NSImage(
            systemSymbolName: "",
            accessibilityDescription: "smartcard off"
        )
        
        smartCardMenuItem.title = "Smart Card"
        smartCardMenuItem.target = self
        smartCardMenuItem.action = #selector(smartCardAction(_:))
        smartCardMenuItem.keyEquivalent = "s"
        smartCardMenuItem.indentationLevel = 1
        
        let pinMenu = NSMenuItem()
        pinMenu.offStateImage = NSImage(
            systemSymbolName: "number",
            accessibilityDescription: ""
        )
        pinMenu.title = "PIN"
        pinMenu.action = #selector(showPopover(_:))
        pinMenu.target = self
        pinMenu.indentationLevel = 1
        pinMenu.keyEquivalent = "P"
        
        quitMenuItem.offStateImage = NSImage(
            systemSymbolName: "xmark",
            accessibilityDescription: ""
        )
        
        quitMenuItem.target = self
        quitMenuItem.action = #selector(quitAction(_:))
        quitMenuItem.title = "Quit"
        quitMenuItem.keyEquivalent = "q"
        quitMenuItem.indentationLevel = 1
        
        let pairMenu = NSMenuItem()
        pairMenu.offStateImage = NSImage(
            systemSymbolName: "simcard.2.fill",
            accessibilityDescription: ""
        )
        pairMenu.title = "Pair Smart Card"
        pairMenu.action = #selector(pairSmartCard(_:))
        pairMenu.target = self
        pairMenu.indentationLevel = 1
        pairMenu.keyEquivalent = "p"
        
        let unPairMenu = NSMenuItem()
        unPairMenu.offStateImage = NSImage(
            systemSymbolName: "simcard.2",
            accessibilityDescription: "p"
        )
        
        unPairMenu.title = "Unpair Smart Card"
        unPairMenu.action = #selector(unPairSmartCard(_:))
        unPairMenu.target = self
        unPairMenu.indentationLevel = 1
        unPairMenu.keyEquivalent = "u"
        
   
        openAtLoginMenuItem.title = "Open at Login"
        openAtLoginMenuItem.action = #selector(openAtLogin(_:))
        openAtLoginMenuItem.target = self
        openAtLoginMenuItem.indentationLevel = 1
        openAtLoginMenuItem.keyEquivalent = "o"
        
        openAtLoginMenuItem.onStateImage = NSImage(
            systemSymbolName: "checkmark",
            accessibilityDescription: "open at login on"
        )
        
        openAtLoginMenuItem.offStateImage = NSImage(
            systemSymbolName: "",
            accessibilityDescription: "open at login off"
        )
    
        openAtLoginMenuItem.state = OpenAtLogin.checkIfLocalPlistExists() ? .on : .off
        
        openAtLoginWindow.title = "Login Window"
        openAtLoginWindow.action = #selector(loginWindow(_:))
        openAtLoginWindow.target = self
        openAtLoginWindow.indentationLevel = 1
        openAtLoginWindow.keyEquivalent = "l"
        
        openAtLoginWindow.onStateImage = NSImage(
            systemSymbolName: "checkmark",
            accessibilityDescription: "open at login on"
        )
        
        openAtLoginWindow.offStateImage = NSImage(
            systemSymbolName: "",
            accessibilityDescription: "open at login off"
        )
    
        openAtLoginWindow.state = LoginWindow.checkIfGlobalPlistExists() ? .on : .off
        
        mainMenu.addItem(pearity)
        mainMenu.addItem(.separator())
        mainMenu.addItem(smartCardMenuItem)
        mainMenu.addItem(pinMenu)
        mainMenu.addItem(.separator())
        mainMenu.addItem(pairMenu)
        mainMenu.addItem(unPairMenu)
        mainMenu.addItem(.separator())
        mainMenu.addItem(openAtLoginMenuItem)
        mainMenu.addItem(openAtLoginWindow)
        mainMenu.addItem(.separator())

        mainMenu.addItem(quitMenuItem)
        statusItem.menu = mainMenu
    }
}
