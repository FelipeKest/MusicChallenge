//
//  ViewController.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var bandID: String?
    var realBand: [String:Any]?
    var band: Band?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SessionManager.getCurrentUser { (musician, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                self.bandID = musician?.band?.id
                DAO.queryBand(id: self.bandID!, completionHandler: { (bandRecord, bandError) in
                    if error != nil {
                        print(bandError?.localizedDescription as Any)
                    } else {
                        self.realBand = bandRecord?.asDictionary
                        self.band = Band(asDictionary: self.realBand!)
                    }
                })
            }
        }
    }
    
  
 
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBAction func saveSong(_ sender: Any) {
           
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
//        SessionManager.getCurrentUser { (user, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                return
//            } else {
//                self.labelText.text = user?.value(forKey: "band")
//            }
//        }
    }
}

