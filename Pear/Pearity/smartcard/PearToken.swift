//
//  PearToken.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import CryptoTokenKit

class PearToken: TKSmartCardToken, TKTokenDelegate {
    init(smartCard: TKSmartCard, driver tokenDriver: TKSmartCardTokenDriver, configuration: TKToken.Configuration) {
        super.init(smartCard: smartCard, aid: "A000000116A001".data(using: .utf8), instanceID: configuration.instanceID, tokenDriver: tokenDriver)
        smartCard.isSensitive = true
    }

    func createSession(_ token: TKToken) throws -> TKTokenSession {
        return PearTokenSession(token:self)
    }
}
