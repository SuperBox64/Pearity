//
//  PearSignCert.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

private func pearSign(certificate: Data?, signature: Data?) -> PearContainer? {
    
    guard
        let cert = PearContainer.pear(),
        let sign = PearContainer.pear(),
        let tbs  = PearObject().pear(dat: certificate),
        let alg  = PearObject().pear(oid: pear_sda),
        var pad  = pear_zer.pearHexb,
        let signature = signature
    else {
        return nil
    }
    
    
    cert.pearSign(pear_seq)
    sign.pearSign(pear_seq)

    cert.add(tbs)
    cert.add(sign)
    sign.add(alg)
    pad.append(signature)
    
    guard
        let sig = PearObject().pear(bit: pad)
    else {
        return cert
    }
    
    cert.add(sig)
    return cert
}

func pearSignCert(certificate: Data?, signature: Data?) -> PearContainer? {
    pearSign(certificate: certificate, signature: signature)
}
