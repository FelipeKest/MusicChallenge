//
//  CreateSongViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller da tela de criar uma música.

import UIKit

class CreateSongViewController: UIViewController {

    @IBOutlet weak var songNameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createSongAction(_ sender: Any) {
        guard let songName = songNameTxt.text else {return}//displayAlertController}
        guard let currentUser = SessionManager.currentUser else {return}
        guard let currentBand = SessionManager.currentUser?.band else {return}
        var players: [SongMusician] = []
        SongMusician.asynchronousCreation(from: "919F6140-2C8B-4C85-9622-316A2C1B4624|Bass") { (songMusician1, error1) in
            SongMusician.asynchronousCreation(from: "CF4DCFF9-028F-4EA3-B6DF-5C4753DF51DF|Vocals", completionHandler: { (songMusician2, error2) in
                if (error1 == nil) && (error2 == nil) {
                    players.append(songMusician1!)
                    players.append(songMusician2!)
                }
                let song = Song(name: songName, instruments: players, creator: currentUser, id: "")
                DAO.createSong(song: song, by: currentUser, on: currentBand) { (error) in
                    if error != nil {
                        //display alert controller
                        print(error?.localizedDescription as Any)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
      
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
