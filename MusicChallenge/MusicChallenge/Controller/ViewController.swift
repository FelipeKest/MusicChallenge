//
//  ViewController.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LoginManager {
    
    
    func getCurrentUser(completionHandler: @escaping (Musician?, Error?) -> Void) {
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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

