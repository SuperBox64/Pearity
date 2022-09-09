//
//  Unfocus.swift
//  Pearity
//
//  Created by Pierre Segula on 6/7/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Cocoa

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {  }
    }
}

extension NSPopUpButton {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {  }
    }
}

extension NSButton {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {  }
    }
}

extension NSSwitch {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
