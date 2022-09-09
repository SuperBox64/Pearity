//
//  KeyPear.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import CryptoTokenKit
import CryptoKit
import CommonCrypto

let bundleId: String = Bundle.main.bundleIdentifier ?? "com.pearsecurity.Pearity"

func setDefaults() -> PearPKI? {
    let min = 32
    let max = 16384
    let priv = NST256.getPrivateKey()

    guard
        let user = getUser(),
        let nist = try? NST256.getPrivateKeyNist(privateKeyData: priv),
        let auth = getCurrentID(user: user, shortName: true)?.replacingOccurrences(of: "-", with: "").data(using: .utf8),
        let pinh = "123456".data(using: .utf8),
        let mach = machineID().replacingOccurrences(of: "-", with: "").data(using: .utf8),
        let pass = getPearAuth
    else {
        return nil
    }
   
    let publ = NST256.getPublicKeyData(fromPrivateKey: nist)
    let pkhh = publ.hash.pearHexa

    let cert = getCert(privateKey: nist)
    let salt = AES256.getSalt(min)
    let iter = Int.random(in: min...max)
    let card = true
    
    let pins = AES256.getSalt(min)
    let rndd = AES256.getSalt(min)

    let time = Double(60)
    let maxa = 3
    
    guard
        let prie = try? AES256.encrypt(data: priv, pass: pass, salt: salt, auth: auth, iter: iter),
        let pine = try? AES256.encrypt(data: rndd, pass: mach, salt: pins, auth: pinh + auth, iter: iter)
    else {
        return nil
    }
 
    let pearPki = PearPKI(
        priv: prie,
        publ: publ,
        pkhh: pkhh,
        cert: cert,
        pinh: pine,
        pins: pins,
        card: card,
        pass: pass,
        salt: salt,
        auth: auth,
        iter: iter,
        time: time,
        maxa: maxa
    )
    
    return pearPki
}
