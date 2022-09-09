//
//  PearTokenAuth.swift
//  smartcard
//
//  Created by Pierre Segula on 6/19/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import CryptoTokenKit

private var PINAttempts = 0
private var maxTripped  = false
private var dateExpire  = Date().timeIntervalSince1970
private var multiplier  = Double(1)

let authNeededError = NSError(domain: TKErrorDomain, code: TKError.Code.authenticationNeeded.rawValue, userInfo: [NSLocalizedDescriptionKey : ""])
let authFailedError = NSError(domain: TKErrorDomain, code: TKError.Code.authenticationFailed.rawValue, userInfo: [NSLocalizedDescriptionKey : "🍐 Incorrect PIN or Password"])
let authError = NSError(domain: TKErrorDomain, code: TKError.Code.authenticationFailed.rawValue, userInfo: [NSLocalizedDescriptionKey : ""])

typealias success = (Bool) -> ()

class PearTokenAuth: TKTokenSmartCardPINAuthOperation {
    var success: success?
    var configData = Data()
    
    override func finish() throws {
        
        guard
            !configData.isEmpty
        else {
            throw authError
        }
        
        guard
            let thisPin = self.pin,
            let thisPinData = thisPin.data(using: .utf8),
            let mach = machineID().replacingOccurrences(of: "-", with: "").data(using: .utf8),
            let pearPki = decode(pear: configData)
        else {
            throw authFailedError
        }
        
        if PINAttempts >= pearPki.maxa && Date().timeIntervalSince1970 <= dateExpire {
            var PINAttemptsError = NSError(domain: TKErrorDomain, code: TKError.Code.authenticationFailed.rawValue, userInfo: [NSLocalizedDescriptionKey : "⏰ Please wait 1 minute"])
            
            if multiplier > 1 {
                PINAttemptsError = NSError(domain: TKErrorDomain, code: TKError.Code.authenticationFailed.rawValue, userInfo: [NSLocalizedDescriptionKey : "⏰ Please wait \(Int(multiplier)) minutes"])
            }
            maxTripped = true
            throw PINAttemptsError
        } else if maxTripped && Date().timeIntervalSince1970 > dateExpire {
            PINAttempts = 0
            multiplier += 1
            maxTripped = false
        }
        
        do {
            try AES256.decrypt(data: pearPki.pinh, pass: mach, salt: pearPki.pins, auth: thisPinData + pearPki.auth, iter: pearPki.iter)
        } catch {
            PINAttempts += 1
            
            if PINAttempts >= pearPki.maxa {
                dateExpire = Date().timeIntervalSince1970 + (pearPki.time * multiplier)
            }
            
            let PINAttemptsError = NSError(domain: TKErrorDomain, code: TKError.Code.authenticationFailed.rawValue, userInfo: [NSLocalizedDescriptionKey : "🛑 Max attempts reached"])
            throw PINAttempts >= pearPki.maxa ? PINAttemptsError : authFailedError
        }
        
        PearListener().broadcast(message: "success")
        
        PINAttempts = 0  // reset PINAttempts
        multiplier  = 1  // reset multiplier
        
        // Return a practical random number to throw off sniffers
        success?(true)
    }
}
