//
//  Config.swift
//  Pearity
//
//  Created by Pierre Segula on 6/16/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import CryptoTokenKit

func removeTokenConfig() {
    DispatchQueue.main.async {
        TKTokenDriver.Configuration.driverConfigurations["\(bundleId).smartcard"]?.removeTokenConfiguration(for: "\(pear_sec)")
    }
}

@discardableResult
func addTokenConfig() -> TKToken.Configuration? {
    TKTokenDriver.Configuration.driverConfigurations["\(bundleId).smartcard"]?.addTokenConfiguration(for: "\(pear_sec)")
}
