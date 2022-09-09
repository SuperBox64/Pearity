///Users/star/Documents/Pearity/smartcard
//  PearTokenDriver.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import CryptoTokenKit

class PearTokenDriver: TKSmartCardTokenDriver, TKTokenDriverDelegate {
    func tokenDriver(_ driver: TKTokenDriver, tokenFor configuration: TKToken.Configuration) throws -> TKToken {
        PearToken(smartCard: TKSmartCard(), driver: self, configuration: configuration)
    }
}
