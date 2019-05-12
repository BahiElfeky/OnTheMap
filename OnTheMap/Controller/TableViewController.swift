//
//  TableViewController.swift
//  OnTheMap
//
//  Created by MAC on 04/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var mapViewClient = MapViewClient()
    var studentLocations : [StudentInfo]!
    
    @IBOutlet weak var locationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
        mapViewClient.getStudent { (data, error ) in
            
            if data != nil{
//                self.studentLocations = data as! [StudentInfo]
                self.studentLocations = StudentLocationModel.studentLocations
                print(data)
                
                DispatchQueue.main.async {
                    self.locationTableView.reloadData()
                }
            }
            else{
                if error != nil{
                    //showALert
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath) as! LocationTableViewCell
        cell.firstNameLabel.text = "\(self.studentLocations[indexPath.row].firstName!) \(self.studentLocations[indexPath.row].lastName!)"
        cell.mediaURLLabel.text = "\(studentLocations[indexPath.row].mediaURL!)"
        cell.pinImageView.image = UIImage(named: "icon_pin")!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(NSURL(string:studentLocations[indexPath.row].mediaURL)! as URL)
    }
    
}
