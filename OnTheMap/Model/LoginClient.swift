//
//  LoginClient.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import Foundation
import UIKit

class LoginClient {
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func loginUser (usernameLogin: String, passwordLogin: String, completionHandlerForPost: @escaping (_ result: AnyObject?,_ message: String?,_ error: NSError?) -> Void) {
        
        let _ = taskForPostMethod(usernameLogin, url: URL(string: Constants.BaseURL + Constants.Session)!, username: usernameLogin, password: passwordLogin) { (results,message, error) in
            if let error = error {
                completionHandlerForPost(nil,message, error)
            }
            else {
                completionHandlerForPost(results,nil, nil)
            }
        }
    }
    
    func taskForPostMethod(_ method: String, url: URL, username: String, password: String, completionHandlerForPost: @escaping (_ result: AnyObject?,_ message: String?,_ error: NSError?) -> Void) {
        
        let url = URL(string:Constants.PublicUserURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPost(nil,error, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
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
            
            let newData = data?.subdata(in: 5..<data!.count)
            if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                let dict = json as? [String:Any],
                let sessionDict = dict["session"] as? [String: Any],
                let accountDict = dict["account"] as? [String: Any]  {
                
                let key = accountDict["key"] as? String
                let sessionId = sessionDict["id"] as? String
                UtlisFunctions.saveToUserDefaults(key: "userkey" , value: key!)
                UtlisFunctions.saveToUserDefaults(key: "usersessionid" , value: sessionId!)
                print(key ?? "Empty Key")
                print(sessionId ?? "Empty session id")
                completionHandlerForPost(key as AnyObject,nil, nil)
                
            } else {
                let errString = "Couldn't parse response"
                let error = [NSLocalizedDescriptionKey : errString]
                completionHandlerForPost(nil,errString, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: error))
                
            }
            print(newData!)
            
        }
        task.resume()
    }
    class func sharedInstance() -> LoginClient {
        struct Singleton {
            static var sharedInstance = LoginClient()
        }
        return Singleton.sharedInstance
    }
    
    func logout (_ completionHandler: @escaping (_ result: Bool, _ message: String, _ error: Error?)->()){
        if let appDelegate = appDelegate {
            var request = URLRequest(url: appDelegate.parseURLFromParameter([:]))
            
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard (error == nil) else {
                    completionHandler (false, "There was an error with your request: \(error!)", error)
                    print ("There was an error with your request: \(error!)")
                    return
                }
                
                completionHandler (true, "", nil)
                
            }
            task.resume()
            
        }
    }
}
