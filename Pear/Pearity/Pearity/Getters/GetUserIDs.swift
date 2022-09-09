//
//  GetUserIDs.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import OpenDirectory

func getPairedTokenIds(_ user: String,_ secureToken: Bool) -> [String] {
    getUserIdentities(user,secureToken)
}

private func getUserIdentities(_ user: String,_ secureToken: Bool) -> [String] {
    
    let odsn = ODSession()
    let type = ODNodeType(kODNodeTypeLocalNodes)
    let attr = "dsAuthMethodNative"
    let tkid = "tokenidentity"
    let secu = "SecureToken"
    
    guard
        let node = try? ODNode(session: odsn, type: type),
        let find = try? ODQuery(
            node: node,
            forRecordTypes: kODRecordTypeUsers,
            attribute: kODAttributeTypeRecordName,
            matchType: ODMatchType(kODMatchContains),
            queryValues: user,
            returnAttributes: attr,
            maximumResults: 1
        )
       
    else {
        return []
    }

    let result = try? find.resultsAllowingPartial(false) as? [ODRecord]
    let tokens = try? result?.first?.values(forAttribute: kODAttributeTypeAuthenticationAuthority) as? [String]
    
    if secureToken, let stoken = tokens?.filter({$0.contains(tkid)}).map({ $0.replacingOccurrences(of: ";\(secu);", with: "") }) {
        return stoken
    } else if let tkid = tokens?.filter({$0.contains(tkid)}).map({ $0.replacingOccurrences(of: ";\(tkid);", with: "") }) {
        return tkid
    } else {
        return []
    }
}
