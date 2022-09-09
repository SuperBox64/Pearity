//
//  PearCard.swift
//  Pearity
//
//  Created by Pierre Segula on 6/4/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

@discardableResult
private func eof(_ ret: FileHandle) -> String? {
    String(bytes: ret.readDataToEndOfFile(), encoding: .utf8)
}

func pearCard() {
    guard
        let id = getCurrentID(user: NSUserName(), shortName: true)
    else {
        return
    }
    
    guard
        var pearPki = readSmartCard(currentUser: id)
    else {
        return
    }
    
    let bind = "/System/Library/Frameworks/CryptoTokenKit.framework/ctkbind.app/Contents/MacOS/ctkbind"
    
    // Insert Card
    pearPki.card = true
    SmartCard.smartCardMenuBar(pearPki: pearPki)
    
    runCommandReturnStr(binary: bind, arguments: ["-r","-u", "\(NSUserName())", "-h", "\(pearPki.pkhh)"])
    
    message = """
    Hi \(NSFullUserName()),
    Pearity wants to pair your smartcard.
    """
    
    Auth.executeWithPrivileges("\(bind) -p -u \(NSUserName()) -h \(pearPki.pkhh)")
   
    writeSmartCard(pearPki: pearPki, currentUser: id)
    //eof(ret)
}
