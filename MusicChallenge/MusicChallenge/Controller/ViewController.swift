//
//  ViewController.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    @IBAction func saveSong(_ sender: Any) {
        DAO.createSong(song: Song(), on: Band()) { (result, error) in
            if error != nil {
                print("Nao foi")
                print(error?.localizedDescription as Any)
            } else {
                DispatchQueue.main.async {
                    let newView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                    newView.backgroundColor = UIColor(red: 1, green: 1, blue: 0.2, alpha: 1)
                    self.view.addSubview(newView)
                }
            }
        }
    }
    
    @IBAction func saveSetlist(_ sender: Any) {
//        DAO.createSetlist(setlist: Setlist(name: "Songs From Hell", songs: [], id: "", bandId: ""), on: Band()) { (result, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//            } else {
//                DispatchQueue.main.async {
//                    let newView = UIView(frame: CGRect(x: 200, y: 200, width: 200, height: 200))
//                    newView.backgroundColor = UIColor(red: 1, green: 0, blue: 0.2, alpha: 1)
//                    self.view.addSubview(newView)
//                }
//            }
//        }
    }
    
    @IBAction func printe(_ sender: Any) {
        print("AHHHHHH")
    }
}

