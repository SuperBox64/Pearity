//
//  AES256.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import CryptoKit
import CommonCrypto

class AES256 {
    class func encrypt(data: Data, pass: Data, salt: Data, auth: Data, iter: Int) throws -> Data? {
        try encrypt(data, pass, salt, auth, iter)
    }
    
    @discardableResult
    class func decrypt(data: Data, pass: Data, salt: Data, auth: Data, iter: Int) throws -> Data? {
        try decrypt(data, pass, salt, auth, iter)
    }
    
    class func getSalt(_ count: Int) -> Data {
        var salt = [UInt8](repeating: 0, count: count)
        let iter = SecRandomCopyBytes(kSecRandomDefault, count, &salt)
        return iter > 0 ? Data(salt) : Data(salt.reversed())
    }
    
    private class func encrypt(_ data: Data,_ pass: Data,_ salt: Data, _ auth: Data,_ iter: Int) throws -> Data? {
        let pass = PBKDF(pass, salt, iter)
        let nonc = AES.GCM.Nonce()
        return try AES.GCM.seal(data, using: pass, nonce: nonc, authenticating: auth).combined
    }

    private class func decrypt(_ data: Data,_ pass: Data,_ salt: Data,_ auth: Data,_ iter: Int) throws -> Data? {
        let pass = PBKDF(pass, salt, iter)
        let data = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(data, using: pass, authenticating: auth)
    }
  
    private class func PBKDF(_ pass: Data,_ salt: Data,_ iter: Int) -> SymmetricKey {
        let hpy = 0
        let gcf = 32

        let algorithm     : CCPBKDFAlgorithm        = CCPBKDFAlgorithm(kCCPBKDF2)
        let pass          : [Int8]                  = [UInt8](pass).map { Int8(bitPattern: $0) }
        let passLen       : Int                     = pass.count
        let salt          : [UInt8]                 = [UInt8](salt)
        let saltLen       : Int                     = salt.count
        let prf           : CCPseudoRandomAlgorithm = CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256)
        let iter          : UInt32                  = UInt32(iter)
        var derivedKey    : [UInt8]                 = [UInt8](repeating: 0, count: kCCKeySizeAES256)
        let derivedKeyLen : Int                     = kCCKeySizeAES256

        let happy = CCKeyDerivationPBKDF(
            algorithm,
            pass, passLen,
            salt, saltLen,
            prf,
            iter,
            &derivedKey, derivedKeyLen
        )
        
        guard
            happy         == hpy,
            passLen        > hpy,
            saltLen       == gcf,
            derivedKeyLen == gcf
        else {
            print("Gigo hacking detected")
            return SymmetricKey(size: .bits128) //If hacking is detected, return random key
        }
  
        return SymmetricKey(data: Data(derivedKey))
    }
}
