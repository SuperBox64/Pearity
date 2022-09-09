//
//  PearCertificate.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import Cocoa
import CryptoKit
import CryptoTokenKit
import LocalAuthentication
import LocalAuthenticationEmbeddedUI

func pearCertificate(pearPrivateKey: Data, pearPublicKey: Data, secure: Bool) -> Data {
    
    let createdCert = pearCreateCert(issuedTo: "Pear Security International", issuedBy: "Pear Security International", pearPublicKey: pearPublicKey)
    let certificate = pearEncode(createdCert)
    let sha1Hash = certificate?.pear256 ?? Data()
    
    let signature: Data!
    if secure {
        let context = LAContext()
        context.localizedReason = "Pearity"
        let pk = try? SecureEnclave.P256.Signing.PrivateKey.init(dataRepresentation: pearPrivateKey, authenticationContext: context)
        let dt = try? pk?.signature(for: sha1Hash)
        signature = dt?.rawRepresentation
    } else {
        let pk = try? P256.Signing.PrivateKey.init(rawRepresentation: pearPrivateKey)
        let dt = try? pk?.signature(for: sha1Hash)
        signature = dt?.rawRepresentation
    }
      
    guard
        let tbs = pearSignCert(certificate: certificate, signature: signature),
        let signedCert = pearEncode(tbs)
    else {
        return Data()
    }
    
    return(signedCert)
}

func getCert(privateKey: P256.Signing.PrivateKey) -> Data {
    let pearPublicKey: Data = privateKey.publicKey.x963Representation
    let pearPrivateKey: Data = privateKey.rawRepresentation
    return pearCertificate(pearPrivateKey: pearPrivateKey, pearPublicKey: pearPublicKey, secure: false)
}
