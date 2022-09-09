//
//  SFAuth.swift
//  pam_bi_tid_swift
//
//  Created by Pierre Segula on 7/10/22.
//

import Foundation
import SecurityFoundation

private func invalidate(_ authorization: inout SFAuthorization?) {
    do {
        authorization?.invalidateCredentials()
        authorization = nil
    }
}

func sfAuth(reason: String, authorizationRight: String) -> Bool {

    typealias authItemPtr = UnsafeMutablePointer<AuthorizationItem>
    
    guard
        // Authorization write for running at root (runs within PAM)
        let authRight = (authorizationRight as NSString).utf8String
    else {
        // could not find authorization right
        return false
    }

    let authItemRight = AuthorizationItem(name: authRight, valueLength: 0, value: nil, flags: 0)
    let authItem = authItemPtr.allocate(capacity: 1)
    authItem.initialize(to: authItemRight)

    var rights = AuthorizationItemSet(count: 1, items: authItem)

    guard
        let prompt = (kAuthorizationEnvironmentPrompt as NSString).utf8String,
        let value = UnsafeMutablePointer(mutating: (reason as NSString).utf8String)
    else {
        
        // could not find authorization prompt
        return false
    }

    let environmentAuthorizationItem = AuthorizationItem(name: prompt, valueLength: reason.count, value: value, flags: 0)
    let environmentItem = authItemPtr.allocate(capacity: 1)
    environmentItem.initialize(to: environmentAuthorizationItem)

    var environment = AuthorizationItemSet(count: 1, items: environmentItem)

    let flags = [.interactionAllowed, .extendRights, .destroyRights] as AuthorizationFlags
    var authorization = SFAuthorization.authorization() as? SFAuthorization

    do {
        try authorization?.obtain(withRights: &rights, flags: flags, environment: &environment, authorizedRights: nil)
    
        invalidate(&authorization)
        
        // authorizated user success
        return true
    } catch {
        // -60006 equals user cancelled
        // -60005 equals access is denied (turn off the sandbox)
        //print("OSStatus:", (error as NSError).code)
        
        invalidate(&authorization)
        
        return false
    }
}
