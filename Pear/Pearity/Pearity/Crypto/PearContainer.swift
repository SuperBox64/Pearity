//
//  PearContainer.swift
//  Pearity
//
//  Created by Pear Security on 1/1/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

internal class PearContainer: NSMutableArray {
    
    var desc      = pear_raw
    var header    = pear_raw
    var blueprint = pear_raw

    private var object = NSMutableArray()
    
    class func pear() -> PearContainer! {
        PearContainer()
    }
    
    private func createOrSign(_ first: Int,_ second: Int,_ third: Int) {
        desc = first
        header = second
        blueprint = third
    }
    
    func create(_ first: Int) {
        createOrSign(first, pear_itm, pear_raw)
    }
    
    func pearSign(_ first: Int) {
        createOrSign(first, pear_itm, pear_raw)
    }
    
    override var count: Int {
        object.count
    }
    
    override func object(at index: Int) -> Any {
        object[index]
    }
    
    override func insert(_ obj: Any, at index: Int) {
        object[index] = obj
    }
}
