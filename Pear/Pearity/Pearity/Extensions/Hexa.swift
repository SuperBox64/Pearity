//
//  PearExtensions.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import CommonCrypto
import Cocoa
import CryptoKit
import Cocoa

extension Digest {
    var pearBytes: [UInt8] { Array(makeIterator()) }
    
    var pearData: Data { Data(pearBytes) }
    
    var pearHexc: String {
        pearBytes.map { String(format: pear_hex, $0) }.joined().uppercased()
    }
}

extension String {
    var pearHexb: Data? {
        var data = Data(capacity: count / pear_002)
        
        try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive).enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            
            guard
                let match = match,
                let byteString = (self as NSString).substring(with: match.range) as String?,
                let num = UInt8(byteString, radix: pear_016)
            else { return }
            
            data.append(num)
        }
        
        return data
    }
}

extension Data {
    var pearHexa: String {
        map { String(format: pear_hex, $0) }.joined().uppercased()
    }
    
    var hash: Data {
        Insecure.SHA1.hash(data: self).pearData
    }
    
    var pear256: Data {
        SHA256.hash(data: self).pearData
    }
}
