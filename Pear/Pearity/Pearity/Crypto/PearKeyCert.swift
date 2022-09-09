//
//  pearPubKeyCert.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

func pearPubKeyCert(pearCert: Data) -> (pearPublicKey: Data, pearCert: SecCertificate)? {
    
    guard
        let pearCert: SecCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, pearCert as CFData),
        let publicKey = SecCertificateCopyKey(pearCert),
        let pearPublicKey = SecKeyCopyExternalRepresentation(publicKey, nil) as? Data
    else {
        return nil
    }
    
    return (pearPublicKey: pearPublicKey, pearCert: pearCert)
}
