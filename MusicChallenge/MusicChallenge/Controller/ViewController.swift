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
            }
        }
    }
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBAction func saveSong(_ sender: Any) {
        let bandID = SessionManager.currentUser?.band?.id
        let musicianName = SessionManager.currentUser?.name
        print(musicianName as Any)
        print("esse e o nome \(String(describing: bandID))")
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

