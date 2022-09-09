//
//  PinView.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import SwiftUI

struct PinView: View {
    @State var popover: NSPopover
    @State var newPin: String = ""
    @State var verPin: String = ""
    @State var shakeField: Int = 0
    
    let maxChar = 6
    
    private func preparePin() {
        let id = getCurrentID(user: NSUserName(), shortName: true) ?? NSUserName()
        let mach = machineID().replacingOccurrences(of: "-", with: "").data(using: .utf8)

        if var pearPki = readSmartCard(currentUser: id),
           let pind = newPin.data(using: .utf8),
           case let salt = AES256.getSalt(32),
           case let rndd = AES256.getSalt(32),

           let pine = try? AES256.encrypt(data: rndd, pass: mach ?? pearPki.pass, salt: salt, auth: pind + pearPki.auth, iter: pearPki.iter) {
            
            let tokenConfig = SmartCard.getConfig()
            pearPki.pinh = pine
            pearPki.pins = salt
            tokenConfig?.configurationData = encode(pear: pearPki)
            writeSmartCard(pearPki: pearPki, currentUser: id)
        }
    }
    
    func verifyPIN() {
        if verPin == newPin {
            preparePin()
            self.presentationMode.wrappedValue.dismiss()
            popover.performClose(self)
        } else {
            withAnimation(.easeInOut) {
                self.shakeField += 1
            }
        }
    }
    
    func cancelPIN() {
        self.presentationMode.wrappedValue.dismiss()
        
        
        
        popover.performClose(self)
    }
    
    var closeButton: some View {
        VStack {
            HStack {
                Button(action: {
                    cancelPIN()
                }) {
                    Image(systemName: "xmark")
                        .imageScale(.small)
                }
                .frame(width: 18, height: 18, alignment: .center)
                .padding(.bottom, -1)
                .cornerRadius(18)
                Text("Pearity")
                    .fontWeight(.medium)
                    .opacity(0.85)
                    .padding(.leading, -2)
                    .padding(.top, -1)
                
            }
            .padding(.leading, -4)
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        Group {
            VStack {
                closeButton
                
                VStack {
                    ZStack {
                        if newPin == "" {
                            Text("New")
                                .opacity(0.45)
                                .padding(.bottom, 2)
                        }
                        
                        SecureField("", text: $newPin)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.clear)
                            .disableAutocorrection(true)
                            .multilineTextAlignment(.center)
                            .onReceive(newPin.publisher.collect()) {
                                self.newPin = String($0.prefix(maxChar))
                            }
                    }
                    .frame(height: 15, alignment: .center)
                    
                    ZStack {
                        if verPin == "" {
                            Text("Verify")
                            //    .frame(width: 74, alignment: .center)
                                .opacity(0.45)
                                .padding(.bottom, 2)
                        }
                        
                        SecureField("", text: $verPin, onCommit: verifyPIN)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.clear)
                            .disableAutocorrection(true)
                            .multilineTextAlignment(.center)
                        
                            .onReceive(verPin.publisher.collect()) {
                                self.verPin = String($0.prefix(maxChar))
                            }
                    }
                    .frame(height: 15, alignment: .center)
                    
                }
                .frame(height: 30, alignment: .center)
                .padding(.top, 5)
                .padding(.bottom, 8)
                .modifier(Shake(animatableData: CGFloat(shakeField)))
                
                HStack {
                    Button("Save PIN​") {
                        verifyPIN()
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .padding(0)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification)) { _ in
            self.presentationMode.wrappedValue.dismiss()
            popover.performClose(self)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)) { _ in
            self.presentationMode.wrappedValue.dismiss()
            popover.performClose(self)
        }
        .onAppear{
            // NSApp.activate(ignoringOtherApps: false)
        }
        .frame(width: 95, height: 120)
        .padding(0)
    }
}
