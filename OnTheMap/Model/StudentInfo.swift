//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import Foundation
class StudentInfo {
    var firstName: String!
    var lastName: String!
    var latitude: Double!
    var longitude: Double!
    var mapString: String!
    var mediaURL: String!
    var objectId: String!
    var uniqueKey: String!
    var updatedAt: String!
    
    init(_ dictionary: [String : Any]) {
        
        firstName = dictionary[Constants.firstName] as? String ?? ""
        lastName = dictionary[Constants.lastName] as? String ?? ""
        latitude = dictionary[Constants.Latitude] as? Double ?? 0.0
        longitude = dictionary[Constants.Longitude] as? Double ?? 0.0
        mapString = dictionary[Constants.MapString] as? String ?? ""
        mediaURL = dictionary[Constants.MediaURL] as? String ?? ""
        objectId = dictionary[Constants.ObjectId] as? String ?? ""
        uniqueKey = dictionary[Constants.UniqueKey] as? String ?? ""
        updatedAt = dictionary[Constants.UpdateAt] as? String ?? ""
        
    }
    
    
}


