//
//  GetUsersAndIDs.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//
import Foundation

func getSystemUsersAndIdentities() -> [OpenDirectoryUsers] {
    
    let authority = CSGetDefaultIdentityAuthority().takeUnretainedValue()
    let query = CSIdentityQueryCreate(nil, kCSIdentityClassUser, authority).takeRetainedValue()
    CSIdentityQueryExecute(query, 0, nil)
    
    let results = CSIdentityQueryCopyResults(query).takeRetainedValue()
    var users = [OpenDirectoryUsers]()
    
    for idx in 0..<CFArrayGetCount(results) {
        
        autoreleasepool  {
            
            let identity = unsafeBitCast(CFArrayGetValueAtIndex(results,idx), to: CSIdentity.self)
            
            if
                let uuid = CFUUIDCreateString(nil, CSIdentityGetUUID(identity).takeUnretainedValue()) as? String,
                let uid = CSIdentityGetPosixID(identity) as UInt32?,
                let longname = CSIdentityGetFullName(identity).takeUnretainedValue() as String?,
                let shortname = CSIdentityGetPosixName(identity).takeUnretainedValue() as String?,
                let image = CSIdentityGetImageData(identity).takeUnretainedValue() as Data?,
                let identities = getPairedTokenIds(longname, false) as [String]?,
                let securetoken = getPairedTokenIds(longname, false) as [String]? {
                
                let currentUser: OpenDirectoryUsers = OpenDirectoryUsers(
                    identities: identities,
                    securetoken: !securetoken.isEmpty,
                    shortname: shortname,
                    longname: longname,
                    uuid: uuid,
                    uid: Int(uid),
                    image: image
                )
                users.append(currentUser)
            }
        }
    }
    
    users = users.sorted(by: { $0.longname > $1.longname })
    return users
}
