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
//    var realBand: [String:Any]?
    var band: Band?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SessionManager.getCurrentUser { (musician, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBAction func saveSong(_ sender: Any) {
        let bandID = "B3C027CE-F382-587E-9899-7F23867A42F5"
        guard let currentUser = SessionManager.currentUser else {return}
        DAO.add(musician: currentUser, bandID: bandID) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            DAO.fetchBand(with: bandID) { (bandRecord, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                guard let realBandRecord = bandRecord else {return}
                let realBand = Band(asDictionary: realBandRecord.asDictionary)
                print(realBand.name)
                //            print(realBand.id as Any)bad
            }
            
        }
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

