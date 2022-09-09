//
//  PearPKI.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

struct PearPKI: Codable {
    var priv: Data   //privateKey
    var publ: Data   //publicKey
    var pkhh: String //publicKeyHash
    var cert: Data   //certData
    var pinh: Data   //pinhash
    var pins: Data   //pinsalt
    var card: Bool   //inserted
    var pass: Data   //pass
    var salt: Data   //salt
    var auth: Data   //auth
    var iter: Int    //interations
    var time: Double //time added for max attempts
    var maxa: Int    //max attempts allowed
}

struct PearDict: Codable {
    var user: PearData
}

typealias PearData = [String: Data]

func encode(dict: PearDict) -> Data? {
    try? PropertyListEncoder().encode(dict)
}

func decode(dict: Data) -> PearDict? {
    try? PropertyListDecoder().decode(PearDict.self, from: dict)
}

func encode(pear: PearPKI) -> Data? {
    try? PropertyListEncoder().encode(pear)
}

func decode(pear: Data) -> PearPKI? {
    try? PropertyListDecoder().decode(PearPKI.self, from: pear)
}
