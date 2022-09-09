//
//  PearObject.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

internal class PearObject: NSObject {
    var desc = pear_raw
    var object: Any?
    
    // These never change
    let header = pear_raw
    let blueprint = pear_raw
    
    private func str(_ bit: Data?) -> PearObject? {
        self.desc = pear_bit
        self.object = bit
        return self
    }
    
    private func raw(_ data: Data?) -> PearObject? {
        self.desc = pear_raw
        self.object = data
        return self
    }

    private func gen(_ date: Date?) -> PearObject? {
        self.desc = pear_gen
        self.object = date
        return self
    }
    
    private func dat(_ int: Data?) -> PearObject? {
        self.desc = pear_int
        self.object = int
        return self
    }
    
    private func abc(_ oid: String?) -> PearObject? {
        self.desc = pear_oid
        self.object = oid
        return self
    }
    
    private func txt(_ utf: String?) -> PearObject? {
        self.desc = pear_utf
        self.object = utf
        return self
    }
    
    func pear(bit: Data?) -> PearObject? {
        str(bit)
    }
    
    func pear(dat: Data?) -> PearObject? {
        raw(dat)
    }
    
    func pear(int: Data?) -> PearObject? {
        dat(int)
    }
    
    func pear(dte: Date?) -> PearObject? {
        gen(dte)
    }

    func pear(oid: String?) -> PearObject? {
        abc(oid)
    }
    
    func pear(utf: String?) -> PearObject? {
        txt(utf)
    }
}
