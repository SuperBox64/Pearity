//
//  UnPearCard.swift
//  Pearity
//
//  Created by Pierre Segula on 6/19/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

func unPearCard() {
    
    guard
        let id = getCurrentID(user: NSUserName(), shortName: true),
        var pearPki = readSmartCard(currentUser: id)
    else {
        return
    }
    
    let bind = "/System/Library/Frameworks/CryptoTokenKit.framework/ctkbind.app/Contents/MacOS/ctkbind"
    
    // Unpair Card
    runCommandReturnStr(binary: bind, arguments: ["-r","-u", "\(NSUserName())", "-h", "\(pearPki.pkhh)"])
    
    // Remove Card (Quiet, No lockscreen)
    pearPki.card = false
    SmartCard.smartCardMenuBar(pearPki: pearPki, lockScreen: false)
    writeSmartCard(pearPki: pearPki, currentUser: id)
}

