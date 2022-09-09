//
//  Activate.swift
//  Pearity
//
//  Created by Pierre Segula on 6/16/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import AppKit

func activateLoginWindow() {
    let running = NSWorkspace.shared.runningApplications
    for i in running where i.localizedName == "SecurityAgent" {
        i.activate(options: .activateIgnoringOtherApps)
    }
}
