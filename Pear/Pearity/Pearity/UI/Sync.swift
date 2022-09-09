//
//  Sync.swift
//  Pearity
//
//  Created by Pierre Segula on 6/15/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

func syncSmartCard(_ pearPki: PearPKI,_ smartCardIsInserted: Bool) {
    smartCardMenuItem.state = pearPki.card ? .on : .off
    SmartCard.smartCardMenuBar(pearPki: pearPki, lockScreen: false)
}
