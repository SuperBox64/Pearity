//
//  read.swift
//  pearitycli
//
//  Created by Pierre Segula on 6/5/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

func readFromFile() -> Data? {
    
    let sharedFolder = "/Users/Shared"

    guard
        let pear = (pearity + machineID()).pearHexb?.pear256.pearHexa.lowercased(),
        let file = URL(string: "file://\(sharedFolder)/.\(pear)")
    else {
        return nil
    }
    
    guard
        let data = try? Data(contentsOf: file)
    else { return nil }
    
    return decryptedData(info: data)
}

func readSmartCard(currentUser: String) -> PearPKI? {
    guard
       let dictData = readFromFile()
    else {
        return nil
    }

    guard let pearDict = decode(dict: dictData) else { return nil }
    guard let pearData = pearDict.user[currentUser] else { return nil }
    guard let pearPki = decode(pear: pearData) else { return nil }
     
    return pearPki
}

func decryptedData(info: Data) -> Data? {
    let iter = 32
    let doub = 2
    let mult = 4
    
    let pass = machineID().pearHexb ?? Data()
    let auth = info.prefix(iter) // Left third
    let salt = info.suffix(iter) // Right third
    let leng = info.count

    let data = info.prefix(leng - iter).suffix(leng - iter * doub) // Middle/Guts/Body
    return try? AES256.decrypt(data: data, pass: pass, salt: salt, auth: auth, iter: iter * mult)
}
