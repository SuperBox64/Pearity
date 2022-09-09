//
//  Insertion.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

@discardableResult
func Insertion() -> Bool {
    
        let tokenID = SmartCard.getTokenID()
        
        let query : [String : Any] =
        [kSecClass as String: kSecClassKey,
         kSecAttrTokenID as String: tokenID,
         kSecReturnAttributes as String: true,
         //kSecReturnPersistentRef as String: true,
         //kSecReturnRef as String: true
        ]
        
        var smartcard: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &smartcard)
        //let dictionary = smartcard as? NSDictionary
        //let pkhh = dictionary?["klbl"] as? Data ?? Data()
        
        //let publicKeyHash = pkhh.pearHexa
        return status == 0
}
