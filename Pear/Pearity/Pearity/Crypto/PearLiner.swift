//
//  PearLiner.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

private func loop(_ wrld: inout Int,_ nova: Data,_ star: inout UInt8) {
    var flip = true
    func incr(){
        wrld += pear_001
    }
    repeat {
        let rang = Range(wrld...wrld)
        let lite = nova.subdata(in: rang)
        lite.copyBytes(to: &star, count: pear_001)
        star <= pear_000 ? incr() : flip.toggle()
    } while flip
}

private func infi(_ wrld: inout Int,_ nova: Data,_ star: inout UInt8) -> Data {
    let buzz = nova as NSData
    let year = -wrld + buzz.count
    let rang = NSRange(location: wrld, length: year)
    let lite = buzz.subdata(with: rang)
    var spce = lite.count ^ pear_128
    var infi = Data(bytes: &spce, count: pear_001)
    infi.append(lite)
    return infi
}

private func lineEncode(_ data: Data) -> Data {
    func send(_ dist: Int) -> Data {
        var wrld = pear_000
        var star = UInt8(pear_000)
        var supr = UInt32(bigEndian: UInt32(dist))
        let strd = MemoryLayout.stride(ofValue: supr)
        let nova = Data(bytes: &supr, count: strd)
        loop(&wrld, nova, &star)
        return infi(&wrld, nova, &star)
    }
    func stop(_ dist: inout Int) -> Data {
        Data(bytes: &dist, count: pear_001)
    }
    var dist = data.count
    return pear_128 >= dist ? stop(&dist) : send(dist)
}

func pearLiner(_ data: Data) -> Data {
    lineEncode(data)
}
