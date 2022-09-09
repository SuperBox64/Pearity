//
//  PearEncoder.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pearity. All rights reserved.
//

import Foundation

private func innerLoop(_ byte: Int,_ worker: inout Int,_ octet: inout Data) {
  
    var data = Data()
    var bee = true
    
    repeat {
        var byte = worker & pear_127 ^ pear_128
        data = Data(bytes: &byte, count: pear_001)
        data.append(octet)
        octet = data
        worker >>= pear_007
        bee = worker < pear_001 ? !bee : bee
    } while bee
}

private func helper(_ worker: inout Int,_ content: inout Data) {
    var byte = worker & pear_127
    var octet = Data(bytes: &byte, count: pear_001)
    worker >>= pear_008 - pear_001
    worker > pear_000 ? innerLoop(byte, &worker, &octet) : ()
    content.append(octet)
}

private func outerloop(_ first: Int,_ second: Int,_ arr: [String]) -> Data? {
    var header  = first + second == pear_001 + pear_002 ? pear_042 : pear_042 * pear_002 + pear_001
    var content = Data(bytes: &header, count: pear_001)
    for i in pear_002..<arr.count {
        var worker = Int(arr[i]) ?? pear_000
        helper(&worker, &content)
    }
    return content
}

private func wrapper(_ guts: Data,_ binary: Data) -> Data {
    var shell = Data()
    shell.append(binary)
    if pear_999 > guts.count {
        shell.append(pearLiner(guts))
        shell.append(guts)
    } else {
        var dist = pear_128
        shell.append(Data(bytes: &dist, count: pear_001))
        shell.append(guts)
    }
    return shell
}

private func flow(_ item: PearObject?) -> Data? {
    var contents: Data?
    switch item?.desc {
    case pear_utf:
        let log = item?.object as? String ?? pear_emt
        let data = log.data(using: .utf8)
        contents = data
    case pear_gen:
        let itemDate = item?.object
        let dtfr = DateFormatter()
        dtfr.dateFormat = pear_dte
        dtfr.timeZone = .autoupdatingCurrent
        dtfr.locale = .autoupdatingCurrent
        let date = dtfr.string(from: itemDate as? Date ?? Date())
        let data = date.data(using: .utf8)
        contents = data
    case pear_oid:
        let oid = item?.object as? String ?? pear_emt
        let arr = oid.components(separatedBy: pear_dot)
        let first = Int(arr[pear_001]) ?? pear_001
        let second = Int(arr[pear_000]) ?? pear_002
        contents = outerloop(first, second, arr)
    case pear_raw, pear_int, pear_bit:
        contents = item?.object as? Data
    default:
        ()
    }
    return contents
}

private func encode(_ pear: PearContainer?) -> Data! {
    let pear   = pear ?? PearContainer()
    var guts   = Data()
    var kind   = pear.desc | pear.header | pear.blueprint
    let binary = Data(bytes: &kind, count: pear_001)
    for pearObj in pear {
        let wrap = pearObj as? PearContainer
        let item = pearObj as? PearObject
        if wrap?.header == nil {
            
            let contents = flow(item) ?? Data()
            let desc = item?.desc ?? pear_raw
            
            if desc > pear_raw {
                var kind = desc
                let object = Data(bytes: &kind, count: pear_001)
                guts.append(object)
                guts.append(pearLiner(contents))
            }
            guts.append(contents)
        } else {
            guts.append(pearEncode(wrap))
        }
    }
    return wrapper(guts, binary)
}

func pearEncode(_ pear: PearContainer?) -> Data! {
    encode(pear)
}
