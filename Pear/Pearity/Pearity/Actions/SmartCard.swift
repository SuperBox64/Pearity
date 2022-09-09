//
//  SmartCard.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import CryptoTokenKit

class SmartCard {
    
    class func getTokenID() -> String {
        String("\(bundleId).smartcard:\(pear_sec)")
    }
    
    class func getConfig() -> TKToken.Configuration? {
        for (driverConfigs, existingDriverConfig) in TKSmartCardTokenDriver.Configuration.driverConfigurations where driverConfigs.contains("\(bundleId).smartcard") {
            for (tokenConfigs, exitingTokenConfig) in existingDriverConfig.tokenConfigurations where tokenConfigs.contains("\(pear_sec)") {
                
                return exitingTokenConfig
            }
        }
        
        return addTokenConfig()
    }
    
    private static func smartCardRoutine(_ pearPki: PearPKI,_ tokenConfig: TKToken.Configuration) {
        
        //let card = Insertion()
        
            if let keychainItems = getKeyChainItems(pearPki: pearPki) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    tokenConfig.keychainItems = keychainItems
                }
                tokenConfig.configurationData = encode(pear: pearPki)
            }
        
    }
    
    class func smartCardMenuBar(pearPki: PearPKI, lockScreen: Bool = true) {
        if pearPki.card {
            if let tokenConfig = addTokenConfig() {
                smartCardRoutine(pearPki, tokenConfig)
            }
        } else {
            

            removeTokenConfig()

            let card = Insertion()
            print("card", card)

            if let tokenConfig = addTokenConfig() {
                tokenConfig.keychainItems = []
                tokenConfig.keychainItems.removeAll()
                tokenConfig.configurationData = nil

            }
            
           let card2 = Insertion()
            print("card2", card2)

            if lockScreen {
          //    lockScreenImmediate()
            }
            
            //if Insertion() {
            //runCommandReturnStr(binary: "/usr/bin/open", arguments: ["-a","ScreenSaverEngine"])
            //runCommandReturnStr(binary: "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine", arguments: ["-a"])
            //}
        }
    }
    
    class func lockScreenImmediate() {
        typealias call = @convention(c) () -> ()
        let login = "/System/Library/PrivateFrameworks/login.framework/Versions/Current/login"
        let sclsi = "SACLockScreenImmediate"
        unsafeBitCast(dlsym(dlopen(login, RTLD_NOW), sclsi), to: call.self)()
    }
    
    class func smartCardOverlay(pearPki: PearPKI) {
        if pearPki.card {
            if let tokenConfig = getConfig() {
                smartCardRoutine(pearPki, tokenConfig)
            }
        } else {
            removeTokenConfig()
        }
    }
    
    class func getKeyChainItems(pearPki: PearPKI) -> [TKTokenKeychainItem]? {
        
        let label = pearity
        let labelCert = "\(label).cert"
        let labelKey = "\(label).key"
        
        guard
            let crt: SecCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, pearPki.cert as CFData),
            let publicKey = SecCertificateCopyKey(crt),
            let pearPublicKey = SecKeyCopyExternalRepresentation(publicKey, nil) as? Data,
            let labelKeyData = labelKey.data(using: .utf8),
            let tokenKey: TKTokenKeychainKey = TKTokenKeychainKey(certificate: nil, objectID: labelKeyData),
            let labelCertData = labelCert.data(using: .utf8),
            let tokenCert: TKTokenKeychainCertificate = TKTokenKeychainCertificate(certificate: crt, objectID: labelCertData)
        else {
            return nil
        }
        
        let tokenOperations = [
            TKTokenOperation.signData.rawValue,
            TKTokenOperation.performKeyExchange.rawValue
        ]
        
        let arr = [
            "✍️".data(using: .utf16),
            "🔑".data(using: .utf16)
        ]
        
        var tokenConstraint: [Int: TKTokenOperationConstraint] = [:]
        
        for (i, tokenOperation) in tokenOperations.enumerated() {
            tokenConstraint[tokenOperation] = arr[i] as TKTokenOperationConstraint?
        }
        
        tokenKey.constraints = tokenConstraint as [NSNumber: Any] //Required
        
        tokenCert.label = label
        tokenKey.label = "\(label).key"
        
        tokenKey.canSign = true
        tokenKey.canPerformKeyExchange = true
        tokenKey.canDecrypt = false
        tokenKey.isSuitableForLogin = true
        
        tokenKey.keyType = kSecAttrKeyTypeECSECPrimeRandom as String
        tokenKey.applicationTag = label.data(using: .utf16)
        tokenKey.keySizeInBits = 256
        tokenKey.publicKeyData = pearPublicKey
        tokenKey.publicKeyHash = pearPublicKey.hash
        
        return [tokenKey, tokenCert]
    }
    
}
