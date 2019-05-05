//
//  MapViewClient.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit
import Foundation

class MapViewClient {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func getStudent(completionHandler: @escaping(_ studentInfo: [AnyObject]?, _ error: NSError?) -> Void) {
        
        let _=taskForGetMethod(Constants.StudentLocations) { (results, error) in
            
            if results == nil {
                completionHandler(nil, error)
            }
            else {
                completionHandler(results, nil)
            }
        }
    }
    
    func taskForGetMethod(_ method: String, completionHandler: @escaping (_ result: [AnyObject]!, _ error: NSError) -> Void) -> Void {
        
        let methodParameters = [Constants.limit:"100",Constants.order:Constants.UpdateAtParam,
                                Constants.skip:"400"]
        print(methodParameters)
        
        
        if let appDelegate = appDelegate {
            var request = URLRequest(url: appDelegate.parseURLFromParameter(methodParameters as [String : AnyObject], withPathExtension: "/StudentLocation"))
            request.addValue(Constants.application_id, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.api_key, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            let session = URLSession.shared
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                func sendError(_ error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandler(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
                }
                guard (error == nil) else {
                    sendError("There was an error with your request: \(error!)")
                    return
                }
                
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    sendError("Your request returned a status code other than 2xx!")
                    return
                }
                
                
                guard data != nil else {
                    sendError("No data was returned by the request!")
                    return
                }
                let parsedResult : [String:AnyObject]!
                do {
                    parsedResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    sendError("Could not parse data from JSON")
                }
                guard let studentsLocationResults = parsedResult["results"] as? [[String: AnyObject]] else {
                    let userInfo = [NSLocalizedDescriptionKey : "Could not find key result in \(parsedResult)"]
                    completionHandler(nil, NSError(domain: "studentInformation", code: 1, userInfo: userInfo))
                    return
                }
                var model = [StudentInfo]()
                for dic in studentsLocationResults {
                    model.append(StudentInfo(dic))
                }
                print(model.capacity)
                completionHandler(model,NSError())
                
                
                
            }
            task.resume()
        }
        
    }
    func postStudentLocation (studentLocation: StudentInfo, completionHandler: @escaping (_ result: Bool, _ message: String, _ error: Error?)->()){
        
        if let appDelegate = appDelegate {
            var request = URLRequest(url: appDelegate.parseURLFromParameter([:] as [String : AnyObject], withPathExtension: "/StudentLocation"))
            request.httpMethod = "POST"
            request.addValue(Constants.application_id, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.api_key, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let methodParam : [String:Any] = [
                "\(Constants.UniqueKey)" : "1234",
                "\(Constants.firstName)" : "\(studentLocation.firstName!)",
                "\(Constants.lastName)": "\(studentLocation.lastName!)"
                ,"\(Constants.MapString)": "\(studentLocation.mapString!)",
                "\(Constants.MediaURL)": "\(studentLocation.mediaURL!)",
                "\(Constants.Latitude)": "\(studentLocation.latitude!)",
                "\(Constants.Longitude)": "\(studentLocation.longitude!)"
                
            ]
            do {
                request.httpBody = try? JSONSerialization.data(withJSONObject: methodParam, options: .prettyPrinted)
                
            } catch let error {
                print(error.localizedDescription)
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard (error == nil) else {
                    completionHandler (false, "", error)
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    completionHandler (false, "Your request returned a status code other than 2xx!", error)
                    return
                }
                guard let data = data else {
                    completionHandler (false, "No data was returned by the request!", error)
                    
                    return
                }
                
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                    
                } catch {
                    completionHandler (false, "Could not parse the data as JSON: '\(data)'", error)
                    return
                }
                guard let studentsLocationID = parsedResult["objectId"] as? String else {
                    completionHandler (false, "Cannot find key 'objectId' in \(String(describing: parsedResult))", error)
                    return
                }
                completionHandler (true, "", nil)
            }
            task.resume()
        }
        
    }
    
}
