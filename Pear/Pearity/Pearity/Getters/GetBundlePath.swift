//
//  GetBundlePath.swift
//  Pearity
//
//  Created by Pierre Segula on 7/4/22.
//

import Foundation

func getBundlePath(resource: String, type: String? = nil ) -> String? {
    Bundle.main.path(forResource: resource, ofType: type)
}
