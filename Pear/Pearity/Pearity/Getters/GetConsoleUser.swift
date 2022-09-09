//
//  GetConsoleUser.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import SystemConfiguration

func isLoginWindowActive() -> Bool {
    if let consoleUser = SCDynamicStoreCopyConsoleUser(nil, nil, nil) as? String {
       return consoleUser == "loginwindow"
    } else {
        return true
    }
}


func getUser() -> String?  {
    SCDynamicStoreCopyConsoleUser(nil, nil, nil) as? String
}
