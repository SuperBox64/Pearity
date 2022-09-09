//
//  PearListener.swift
//  PearListener
//
//  Created by Pierre Segula on 6/11/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import Cocoa

let window = NSWindow()

class PearListener {
    let DistroNotification = DistributedNotificationCenter.default()
    let MainNotification = NotificationCenter.default
    let pearNotificationName = Notification.Name("pearNotificationName")
    let userDefaultsName = Notification.Name("NSUserDefaultsDidChangeNotification")
    let screenSizeDidChange = Notification.Name("NSApplicationDidChangeScreenParametersNotification")
    var counter = 0

    private func hideWindow() {
        window.alphaValue = 0
        window.hidesOnDeactivate = true
        NSApp.deactivate()
        endListening()
    }
    
    func startListening() {
        DistroNotification.addObserver(forName: pearNotificationName, object: nil, queue: .main) { [self] _ in
            hideWindow()
        }
    }
    
    func userDefaultsDidChange() {
        MainNotification.addObserver(forName: userDefaultsName, object: nil, queue: .main) { [self] _ in
            counter += 1

            if counter >= 6 {
                hideWindow()
            }
        }
    }
    
//    func listenToAll() {
//        MainNotification.addObserver(forName: nil, object: nil, queue: nil) { notification in
//            NSLog("***NS: \(notification.name)\(String(describing: notification.userInfo)) ***:NS")
//        }
//
//        DistroNotification.addObserver(forName: nil, object: nil, queue: nil) { notification in
//            NSLog("***DS: \(notification.name)\(String(describing: notification.userInfo)) ***:DS")
//        }
//    }

    func updateWindow() {
        let windowSize = window.frame.size
        var divider = Float(5.5)
        
        if let frameSize = NSScreen.main?.frame.size {
            if frameSize.height < 720 {
                divider = 6.5
            }
            window.setFrameOrigin(CGPoint(x: (frameSize.width - windowSize.width) / 2, y: (frameSize.height - windowSize.height) / CGFloat(divider)))
        }
    }
    
    func screenSizeChanged() {
        MainNotification.addObserver(forName: screenSizeDidChange, object: NSApplication.shared, queue: .main) { message in
            self.updateWindow()
        }
    }
        
    func broadcast(message: String) {
        DistroNotification.postNotificationName(pearNotificationName, object: message, userInfo: nil, deliverImmediately: true)
    }
    
    func endListening() {
        DistroNotification.removeObserver(self, name: pearNotificationName, object: nil)
    }
}
