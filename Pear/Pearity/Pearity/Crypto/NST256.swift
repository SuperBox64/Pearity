//
//  NST256.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import CryptoKit

class NST256 {
    class func getPrivateKey() -> Data {
        P256.Signing.PrivateKey().rawRepresentation
    }
    
    class func getPrivateKeyNist(privateKeyData: Data) throws -> P256.Signing.PrivateKey {
        try P256.Signing.PrivateKey.init(rawRepresentation: privateKeyData)
    }
    
    class func getPublicKeyData(fromPrivateKey: P256.Signing.PrivateKey) -> Data {
        fromPrivateKey.publicKey.x963Representation
    }
}
