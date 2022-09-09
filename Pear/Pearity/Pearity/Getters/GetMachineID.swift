//
//  GetMachineID.swift
//  pearitycli
//
//  Created by Pierre Segula on 6/12/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

func machineID() -> String {
    let device = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))

    guard
        let uuid = IORegistryEntryCreateCFProperty(device, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)
    else {
        return NSUserName()
    }

    IOObjectRelease(device)

    return uuid.takeUnretainedValue() as? String ?? NSUserName()
}
