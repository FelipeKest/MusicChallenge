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
    let songToAdd = Song()
    let bandToAddIn = Band()

    @IBOutlet weak var labelText: UILabel!
    
    @IBAction func saveSong(_ sender: Any) {
        DAO.createSong(song: songToAdd, on: bandToAddIn) { (result, error) in
            if error != nil {
                print("Nao foi")
                print(error?.localizedDescription as Any)
            } else {
                DispatchQueue.main.async {
                    self.labelText.text = result?.name
                }
            }
        }
    }
    
    @IBAction func saveSetlist(_ sender: Any) {
        DAO.delete(song: songToAdd, from: bandToAddIn) { (songRecordId, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                DispatchQueue.main.async {
                    print("Song deleted")
                }
            }
        }
    }
    
    @IBAction func printe(_ sender: Any) {
        print("AHHHHHH")
    }
}

