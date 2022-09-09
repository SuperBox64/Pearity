//
//  PearBioPrompt.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import LocalAuthentication

func pearBioPrompt(reason: String, scmesg: String) -> Bool {
    
    var success = false
    
    let context = LAContext()
    context.localizedReason = "PIN Fallback"
    
    // Check if Biometrics is available
    // if not fallback to PIN prompt
    // todo: add check for PIN)
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) == false {
        success = pearPinPrompt(message: scmesg) //Fallback
        return success
    }
        
    // Workaround so we can wait for the result
    let semaphore = DispatchSemaphore(value: 0)

    //Proceed with Bio
    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { approved, error in
        if approved {
            success = true
        } else {
            switch (error as! LAError).code {
            case LAError.userCancel:
                success = false
            default:
                print("Bio OSStatus: ", (error as! LAError).code)
                break
            }
        }
        
        semaphore.signal()
    }

    _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    return success
}

