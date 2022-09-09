//
//  write.swift
//  pearitycli
//
//  Created by Pierre Segula on 6/5/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation


func writeToFile(fileName: String, data: Data) {
    let sharedFolder = "/Users/Shared"
    
    guard
        let pear = (pearity + machineID()).pearHexb?.pear256.pearHexa.lowercased(),
        let file = URL(string: "file://\(sharedFolder)/.\(pear)"),
        let encryptedData = encryptData(data: data)
    else {
        return
    }
    
    try? encryptedData.write(to: file)

    runCommandReturnStr(binary: "/bin/chmod", arguments: ["777", "\(sharedFolder)/.\(pear)"])
}


func writeSmartCard(pearPki: PearPKI, currentUser: String) {
    let encodedData = encode(pear: pearPki)
    let dictData = readFromFile() ?? Data()
    
    if var pearDict = decode(dict: dictData) {
        pearDict.user[currentUser] = encodedData
        guard let pearDictData = encode(dict: pearDict) else { return }
        writeToFile(fileName: currentUser, data: pearDictData)
    } else  {
        let dict = PearDict(user: [currentUser:encodedData!])
        guard let pearDictData = encode(dict: dict) else { return }
        writeToFile(fileName: currentUser, data: pearDictData)
    }
}

func encryptData(data: Data) -> Data? {
    let iter = 32
    let mult = 4
    let pass = machineID().pearHexb ?? Data()
    let salt = AES256.getSalt(iter)
    
    guard
        let auth = getPearAuth,
        let encryptedData = try? AES256.encrypt(data: data, pass: pass, salt: salt, auth: auth, iter: iter * mult)
    else {
       return nil
    }
    
    return auth + encryptedData + salt
}

public extension UUID {
    var data: Data {
        withUnsafeBytes(of: self.uuid, { Data($0) })
    }
}
