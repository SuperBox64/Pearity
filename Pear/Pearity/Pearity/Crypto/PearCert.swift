//
//  pearCert.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import CryptoKit
import CryptoTokenKit

func pearCert(privateKeyNist: P256.Signing.PrivateKey?) -> (pearPrivateKey: Data, pearCert: Data) {
    let privateKey: P256.Signing.PrivateKey! =
    privateKeyNist == nil ? P256.Signing.PrivateKey() : privateKeyNist

    let pearPublicKey: Data = privateKey.publicKey.x963Representation
    let pearPrivateKey: Data = privateKey.rawRepresentation
    let pearCert = pearCertificate(pearPrivateKey: pearPrivateKey, pearPublicKey: pearPublicKey, secure: false)
    return (pearPrivateKey, pearCert)
}
