//
//  PearCreateCert.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

private func create(_ issuedTo: String,_ issuedBy: String,_ pearPublicKey: Data?) -> PearContainer? {

    var v3 = pear_002

    guard
        let tbs = PearContainer.pear(),
        let ver = PearContainer.pear(),
        let alg = PearContainer.pear(),
        let isr = PearContainer.pear(),
        let dna = PearContainer.pear(),
        let vrn = PearObject().pear(int: Data(bytes: &v3, count: pear_001)),
        let msn = PearObject().pear(int: getPearAuth),
        let oid = PearObject().pear(oid: pear_sda)
    else {
        return nil
    }
    
    tbs.create(pear_seq)
    ver.create(pear_ctx)
    alg.create(pear_seq)
    isr.create(pear_seq)
    dna.create(pear_set)

    ver.add(vrn)
    tbs.add(ver)
    tbs.add(msn)
    alg.add(oid)
    tbs.add(alg)
    tbs.add(isr)
    isr.add(dna)
    
    //MARK: - CN issued By
    guard
        let dcn = PearContainer.pear(),
        let obj = PearObject().pear(oid: pear_cmn),
        let iby = PearObject().pear(utf: issuedBy)
    else {
        return nil
    }
    
    dcn.create(pear_seq)
    
    dna.add(dcn)
    dcn.add(obj)
    dcn.add(iby)
    
    //MARK: - Validity
    guard
        let vld = PearContainer.pear(),
        let ion = PearObject().pear(dte: Date()),
        let eon = PearObject().pear(dte: Date(timeIntervalSinceNow: 3600 * 24 * 365.25 * 1000 - 3600 * 24 * 8))
    else {
        return nil
    }
    
    vld.create(pear_seq)
    
    tbs.add(vld)
    vld.add(ion)
    vld.add(eon)
    
    //MARK: - Subject
    guard
        let sub = PearContainer.pear(),
        let arb = PearContainer.pear(),
        let sdn = PearContainer.pear(),
        let elm = PearObject().pear(oid: pear_cmn),
        let dni = PearObject().pear(utf: issuedTo)
    else {
        return nil
    }
    
    sub.create(pear_seq)
    arb.create(pear_set)
    sdn.create(pear_seq)

    tbs.add(sub)
    sub.add(arb)
    arb.add(sdn)
    sdn.add(elm)
    sdn.add(dni)

    //MARK: - OID EL.CURVE PUBLIC KEY
    guard
        let pub = PearContainer.pear(),
        let alg = PearContainer.pear(),
        let obj = PearObject().pear(oid: pear_pub),
        let oid = PearObject().pear(oid: pear_592),
        var pad = pear_zer.pearHexb,
        let key = pearPublicKey
    else {
        return nil
    }
    
    pub.create(pear_seq)
    alg.create(pear_seq)

    tbs.add(pub)
    pub.add(alg)
    alg.add(obj)
    alg.add(oid)
    pad.append(key)
    
    guard
        let bitPKey = PearObject().pear(bit: pad)
    else {
        return nil
    }
    
    pub.add(bitPKey)
    return tbs
}

func pearCreateCert(issuedTo: String, issuedBy: String, pearPublicKey: Data?) -> PearContainer? {
    create(issuedTo, issuedBy, pearPublicKey)
}
