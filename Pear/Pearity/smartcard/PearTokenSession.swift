//
//  PearTokenSession.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import CryptoTokenKit
import CryptoKit
import Foundation

class PearTokenSession: TKSmartCardTokenSession, TKTokenSessionDelegate {
    private var success: Bool = false
        
    func tokenSession(_ session: TKTokenSession, beginAuthFor operation: TKTokenOperation, constraint: Any) throws -> TKTokenAuthOperation {
        guard
            let data = self.token.configuration.configurationData
        else {
            throw authError
        }
        
        let pearTokenAuth = PearTokenAuth()
        
        pearTokenAuth.pinFormat.minPINLength = 0
        pearTokenAuth.pinFormat.maxPINLength = 6
        
        pearTokenAuth.configData = data
        pearTokenAuth.success = { success in
            self.success = success
        }
        
        return pearTokenAuth
    }

    func tokenSession(_ session: TKTokenSession, supports operation: TKTokenOperation, keyObjectID: Any, algorithm: TKTokenKeyAlgorithm) -> Bool {
        algorithm.isAlgorithm(.ecdhKeyExchangeStandard) || algorithm.isAlgorithm(.ecdsaSignatureMessageX962SHA256)
    }
    
    func getPrivateKeyData() throws -> Data {
        guard
            let data = self.token.configuration.configurationData,
            let pearPki = decode(pear: data),
            let privateKeyData = try? AES256.decrypt(data: pearPki.priv, pass: pearPki.pass, salt: pearPki.salt, auth: pearPki.auth, iter: pearPki.iter)
        else {
            throw authNeededError
        }
        
        return privateKeyData
    }
    func tokenSession(_ session: TKTokenSession, sign dataToSign: Data, keyObjectID: Any, algorithm: TKTokenKeyAlgorithm) throws -> Data {
  
        if !self.success {
            throw authNeededError
        }
        
        guard
            let privateKeyData = try? getPrivateKeyData(),
            let privateKey = try? P256.Signing.PrivateKey.init(rawRepresentation: privateKeyData),
            let signature = try? privateKey.signature(for: dataToSign).derRepresentation
        else {
            throw authNeededError
        }
               
        return signature
    }
    
    func tokenSession(_ session: TKTokenSession, performKeyExchange otherPartyPublicKeyData: Data, keyObjectID objectID: Any, algorithm: TKTokenKeyAlgorithm, parameters: TKTokenKeyExchangeParameters) throws -> Data {

        guard
            let privateKeyData = try? getPrivateKeyData(),
            let privateKey = try? P256.KeyAgreement.PrivateKey(rawRepresentation: privateKeyData),
            let sharedKey = try? P256.KeyAgreement.PublicKey(x963Representation: otherPartyPublicKeyData),
            let sharedSecret = try? privateKey.sharedSecretFromKeyAgreement(with: sharedKey).withUnsafeBytes({ Data($0) })
        else {
            throw authNeededError
        }
                
        return sharedSecret
    }
}
