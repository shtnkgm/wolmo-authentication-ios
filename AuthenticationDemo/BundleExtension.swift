//
//  BundleExtension.swift
//  Authentication
//
//  Created by Nahuel Gladstein on 7/18/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Foundation

internal extension Bundle {
    
    func getString(for key: String, fromPlist plist: String) -> String? {
        if let path = path(forResource: plist, ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                return dict[key] as? String
            }
        }
        return .none
    }
    
}
