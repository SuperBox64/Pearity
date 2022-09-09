//
//  Auth.swift
//  Pearity
//
//  Created by Pierre Segula on 6/4/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation
import Swift

// https://github.com/sveinbjornt/STPrivilegedTask/blob/master/STPrivilegedTask.m
// https://github.com/gui-dos/Guigna/blob/9fdd75ca0337c8081e2a2727960389c7dbf8d694/Legacy/Guigna-Swift/Guigna/GAgent.swift#L42-L80

var message = ""

public struct Auth {
    
    public enum Error: Swift.Error {
        case create(OSStatus)
        case copyRights(OSStatus)
        case exec(OSStatus)
    }
    
    @discardableResult
    public static func executeWithPrivileges(
        _ command: String
    ) -> Result<FileHandle, Error> {
        
        let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
        var fn: @convention(c) (
            AuthorizationRef,
            UnsafePointer<CChar>,  // path
            AuthorizationFlags,
            UnsafePointer<UnsafePointer<CChar>?>,  // args
            UnsafeMutablePointer<UnsafeMutablePointer<FILE>>?
        ) -> OSStatus
        fn = unsafeBitCast(
            dlsym(RTLD_DEFAULT, "AuthorizationExecuteWithPrivileges"),
            to: type(of: fn)
        )
        
        var authorizationRef: AuthorizationRef? = nil
        var err = AuthorizationCreate(nil, nil, [], &authorizationRef)
        guard err == errAuthorizationSuccess else {
            return .failure(.create(err))
        }
        
        guard let authorizationRef = authorizationRef else { return .failure(.copyRights(0)) }
        
        defer { AuthorizationFree(authorizationRef, [.destroyRights]) }
        
        var components = command.components(separatedBy: " ")
        
        guard
            var path = components.remove(at: 0).cString(using: .utf8),
            let name = kAuthorizationRightExecute.cString(using: .utf8)
        else {
            return .failure(.copyRights(0))
        }

        var items: AuthorizationItem = name.withUnsafeBufferPointer { nameBuf in
            path.withUnsafeBufferPointer { pathBuf in
                
                func authItem(_ namedBuffer: UnsafePointer<CChar>, _ pathPtr: UnsafeMutableRawPointer?, pathCount: Int) -> AuthorizationItem {
                    return AuthorizationItem (
                        name: namedBuffer,
                        valueLength: pathCount,
                        value: pathPtr,
                        flags: 0
                    )
                }
                
                let pathPtr = UnsafeMutableRawPointer(mutating: pathBuf.baseAddress)
                
                guard let namedBuffer = nameBuf.baseAddress else {
                    return authItem(nameBuf.baseAddress!, pathPtr, pathCount: path.count)
                }
                
                return authItem(namedBuffer, pathPtr, pathCount: path.count)
            }
        }
        
        var rights: AuthorizationRights =
            withUnsafeMutablePointer(to: &items) { items in
                return AuthorizationRights(count: 1, items: items)
            }
        
        let flags: AuthorizationFlags = [
            .interactionAllowed,
            .preAuthorize,
            .extendRights,
        ]
        
        guard
            let displayName = NSString(string: kAuthorizationEnvironmentPrompt).utf8String,
            let prompt = UnsafeMutablePointer(mutating: NSString(string: message).utf8String)
        else {
            return .failure(.copyRights(0))
        }

        var env = AuthorizationItem(name: displayName, valueLength: message.count, value: prompt, flags: 0)
        
        var environment: AuthorizationEnvironment =
            withUnsafeMutablePointer(to: &env) { env in
            AuthorizationEnvironment(count: 1, items: env)
        }
    
        err = AuthorizationCopyRights(
            authorizationRef,
            &rights,
            &environment,
            flags,
            nil
        )
        
        guard
            err == errAuthorizationSuccess
        else {
            return .failure(.copyRights(err))
        }
        
        guard
            err == errAuthorizationSuccess
        else {
            return .failure(.copyRights(err))
        }
        
        let rest = components.map { $0.cString(using: .utf8) }

        var args = Array<UnsafePointer<CChar>?>(
            repeating: nil,
            count: rest.count + 1
        )
        
        for (idx, arg) in rest.enumerated() {
            guard let arg = arg else { return .failure(.copyRights(err)) }
            args[idx] = UnsafePointer<CChar>?(arg)
        }
        
        var file = FILE()
        let fh: FileHandle?
        
        (err, fh) = withUnsafeMutablePointer(to: &file) { file in
            var pipe = file
            let err = fn(authorizationRef, &path, [], &args, &pipe)
            guard err == errAuthorizationSuccess else {
                return (err, nil)
            }
            let fh = FileHandle(
                fileDescriptor: fileno(pipe),
                closeOnDealloc: true
            )
            return (err, fh)
        }
        guard err == errAuthorizationSuccess else {
            return .failure(.exec(err))
        }
        
        guard let fh = fh else {
            return .failure(.exec(err))
        }
        
        return .success(fh)
    }
}
