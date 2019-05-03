//
//  UtlisFunctions.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit
class UtlisFunctions{
    static func saveToUserDefaults(key: String , value: String){
        let kUserDefault = UserDefaults.standard
        print(value)
        kUserDefault.set(value, forKey: key)
        print("Done!")
        kUserDefault.synchronize()
}
    static func getFromUserDefault(key: String) -> Bool{
        let kUserDefault = UserDefaults.standard
        var bol = false
        if kUserDefault.object(forKey: key) != nil {
            bol = true
        }
        return bol
    }
}
