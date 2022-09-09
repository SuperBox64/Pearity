//
//  POCView.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine
import CryptoTokenKit
import LocalAuthentication
struct PearView: View {
    
    @State var publicKeyHashValue: String = ""
    @State var pinValue: String = ""
    @State var desktopUserName = pearity
    @State var desktopMenu: [String] = ["Helloworld"]
    @State var halo = CGFloat(12)
    @State var radi = CGFloat(12)
    @State var runOnAppear: Bool = false
    @State var opacity: Double = 1.0
    @State var iconButtonSize = CGFloat(20)
    @State var statusLabel = "This Mac is protected by Todd Boss"

    //@State var counter = 0
    //let pub = NotificationCenter.default.publisher(for: NSNotification.Name("NSUserDefaultsDidChangeNotification")
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: radi * 2).fill(Color.white).opacity(0.2)
                            .frame(width: 174 + halo, height: 23 + halo)
                        
                        RoundedRectangle(cornerRadius: radi * 2).fill(Color.white).opacity(0.2)
                            .frame(width: 160 + halo, height: 22)
                        
                        Menu(desktopUserName) {
                            ForEach(desktopMenu, id: \.self) { name in
                                Button(name) {
                                    
                                    if desktopUserName == name {
                                        return
                                    }
                                    
                                    desktopUserName = name
                                    
                                    if name == pearity {
                                        removeTokenConfig()
                                        return
                                    }
                                

                                    let id = getCurrentID(user: String(name.dropFirst(2)), shortName: false) ?? name
                                    guard var pearPki = readSmartCard(currentUser: id) else { return }
                                
                                    
                                    pearPki.card = true
                                    SmartCard.smartCardOverlay(pearPki: pearPki)
                                    writeSmartCard(pearPki: pearPki, currentUser: id)
                                
                                    activateLoginWindow()
                                }
                            }
                        }
                        .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.50), radius: 0.5, x: 0, y: 0)
                        .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.25), radius: 5.0, x: 0, y: 1)
                        .frame(width: 160, height: 22, alignment: .center)
                        .menuStyle(.borderlessButton)
                        .controlSize(.large)
                        .multilineTextAlignment(.center)
                    }
                    //.opacity(0)
                    .padding(10)
                }
                
                ZStack {
                    Text(statusLabel)
                }
                .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.250), radius: 0.5, x: 0, y: 0)
                .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.125), radius: 5.0, x: 0, y: 1)
                .padding(10)
                
                // Restart
                HStack {
                    
                    Button {
                        opacity = 1.0
                        runCommandReturnStr(binary: "/sbin/shutdown", arguments: ["-h", "now"])
                    } label: {
                        
                        // Restart
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: radi * 2).fill(Color.white).opacity(0.2)
                                    .frame(width: iconButtonSize + halo, height: iconButtonSize + halo)
                                Image(systemName: "power")
                                    .resizable()
                                    .frame(width: iconButtonSize, height: iconButtonSize, alignment: .center)
                            }
                            
                            ZStack {
                                Text("Shutdown")
                            }
                            .brightness(0.5)
                            .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.50), radius: 0.5, x: 0, y: 0)
                            .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.25), radius: 5.0, x: 0, y: 1)
                        }
                    }
                    .frame(width: 67)
                    .buttonStyle(.borderless)
                    .padding(10)
                    
                    Button {
                        opacity = 1.0
                        runCommandReturnStr(binary: "/sbin/shutdown", arguments: ["-r", "now"])
                    } label: {
                        
                        // Restart
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: radi * 2).fill(Color.white).opacity(0.2)
                                    .frame(width: iconButtonSize + halo, height: iconButtonSize + halo)
                                Image(systemName: "restart.circle")
                                    .resizable()
                                    .frame(width: iconButtonSize, height: iconButtonSize, alignment: .center)
                            }
                            
                            ZStack {
                                Text("Restart")
                            }
                            .brightness(0.5)
                            .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.50), radius: 0.5, x: 0, y: 0)
                            .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.25), radius: 5.0, x: 0, y: 1)
                        }
                    }
                    .frame(width: 67)
                    .buttonStyle(.borderless)
                    .padding(10)
                    
                    Button {
                        opacity = 1.0
             
                        //runCommandReturnStr(binary: "/usr/bin/pmset", arguments: ["sleepnow"])
                    } label: {
                        
                        // Sleep
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: radi * 2).fill(Color.white).opacity(0.2)
                                    .frame(width: iconButtonSize + halo, height: iconButtonSize + halo)
                                
                                Image(systemName: "sleep")
                                    .resizable()
                                    .frame(width: iconButtonSize, height: iconButtonSize, alignment: .center)
                            }
                            
                            ZStack {
                                Text("Sleep")
                            }
                            .brightness(0.5)
                            .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.50), radius: 0.5, x: 0, y: 0)
                            .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.25), radius: 5.0, x: 0, y: 1)
                        }
                    }
                 
                    .frame(width: 67)
                    .buttonStyle(.borderless)
                    .padding(10)
                }
                .opacity(1)
            }
        }
        .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.60), radius: 0.50, x: 0, y: 0)
        .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.30), radius: 5.00, x: 0, y: 1)
        .shadow(color: .init(Color.RGBColorSpace.displayP3, white: 0, opacity: 0.15), radius: 10.0, x: 0, y: 2)
        .onHover { over in
            if over == false {
                activateLoginWindow()
            }
        }
        //.opacity(0)
       .opacity(opacity)

        .onDisappear {
            addTokenConfig()
        }
        //        .onReceive(pub) { _ in
        
        //        }
        .onAppear {
            
            if !runOnAppear {
                desktopMenu = [pearity]
                
                let users = getSystemUsersAndIdentities()
                
                //                // unplug all smartcards
                for u in users where !u.identities.isEmpty   {
                    let id = getCurrentID(user: u.longname, shortName: false) ?? u.shortname
                    guard var pearPki = readSmartCard(currentUser: id) else { return }
                    pearPki.card = false
                    writeSmartCard(pearPki: pearPki, currentUser: id)
                }
                
                addTokenConfig()
                
                for u in users where !u.identities.isEmpty {
                    desktopMenu.append("🔑 " + u.longname)
                }
                
                runOnAppear.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    PearListener().userDefaultsDidChange()
                }
                
                
//                authenticate()
                
            }
        }
        .preferredColorScheme(.dark)
        
    }
    
    func authenticateX() {
        
//        DispatchQueue.main.async {
//            if let consoleUser = getConsoleUserII(), 1 == 2 {
//
//                statusLabel = "Fingerprint Sensor is Ready"
//
//            } else {
//                statusLabel = "Calibrating Fingerprint Sensor"
//
//                sleep(2)
//
//                let users = getSystemUsersAndIdentities()
//
//                //Calibrate
//                for u in users {
//                    if let char = u.longname.first?.utf16 {
//                        typeItForMe().send(string: char)
//                        sleep(1)
//                    }
//                }
//
//                sleep(1)
//                typeItForMe().returnKey()
//                sleep(1)
//                typeItForMe().escKey()
//                statusLabel = "Fingerprint Sensor is Ready"
//
//            }
//
//        }

        
        //let aright = "use-login-window-ui" //This must be set to prevent caching after reboot
        //_ = sfAuth(reason: aright, authorizationRight: aright)
        

    //    //typeItForMe().lockScreenImmediate()
    //     var stringToSend: String = "T\n\rtincan\r"
    //
    //     // Let's send the password to the lock screen! (Works as long as no one is recording the screen)
    //     let sender = stringToSend.utf16
    //     typeItForMe().send(string: sender)
    //    sleep(1)
        //typeItForMe().lockScreenImmediate()

    //
    //    let context = LAContext()
    //
    //    // check whether biometric authentication is possible
    //    //if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
    //    // it's possible, so go ahead and use it
    //    let reason = "We need to unlock your data."
    //
    //    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
    //        // authentication has now completed
    //        if success {
    //            print("success", success)
    //            NSLog("=========== success: \(success)")
    //
    //            // authenticated successfully
    //        } else {
    //            print("authenticationError", authenticationError as Any)
    //            if let authenticationError = authenticationError {
    //                NSLog("=========== authenticationError: \(authenticationError)")
    //            }
    //
    //            // there was a problem
    //        }
    //    }
    //
        
    }

}

func sendSystemCommand(command: AEEventID) {
    var psn = ProcessSerialNumber(highLongOfPSN: UInt32(0), lowLongOfPSN: UInt32(kCurrentProcess))
    let target = NSAppleEventDescriptor(descriptorType: typeProcessSerialNumber, bytes: &psn, length: MemoryLayout.size(ofValue: psn))
    let event = NSAppleEventDescriptor(
        eventClass: kCoreEventClass,
        eventID: command,
        targetDescriptor: target,
        returnID: AEReturnID(kAutoGenerateReturnID),
        transactionID: AETransactionID(kAnyTransactionID)
    )
    
    _ = try? event.sendEvent(options: [.neverInteract, .noReply], timeout: TimeInterval(kNoTimeOut))
}


func test() {
    
    sendSystemCommand(command: kAESleep)
}



