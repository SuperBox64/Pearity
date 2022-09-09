//
//  PearPinPrompt.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import SecurityInterface

func pearPinPrompt(_ right: String = kAuthorizationRightExecute, message: String) -> Bool {
    
    let rgt = UnsafeMutablePointer(mutating: (right as NSString).utf8String!)
    let authItem = AuthorizationItem(name: rgt, valueLength: 0, value: nil, flags: 0)
    
    let auth = UnsafeMutablePointer<AuthorizationItem>.allocate(capacity: 1)
    auth.initialize(to: authItem)
    
    guard
        let display = (kAuthorizationEnvironmentPrompt as NSString).utf8String,
        let txt = UnsafeMutablePointer(mutating: (message as NSString).utf8String)
    else {
        return false
    }
    
    var env = AuthorizationItem(name: display, valueLength:  message.count, value: txt, flags: 0)
    let ptr = UnsafeMutablePointer<AuthorizationItem>.allocate(capacity: 1)
    ptr.initialize(from: &env, count: 1)
    
    var rights = AuthorizationRights(count: 1, items: auth)
    var enviro = AuthorizationEnvironment(count: 1, items: ptr)
    var authRf = AuthorizationRef(bitPattern: 0)
    let iflags = [.interactionAllowed,.extendRights] as AuthorizationFlags
    
    return AuthorizationCreate(&rights, &enviro, iflags, &authRf) == 0
}
