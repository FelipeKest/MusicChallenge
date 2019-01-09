//
//  EditSongViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 09/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditSongViewController: UIViewController {

    @IBOutlet var songNameField: UITextField!
    @IBOutlet var keyField: UITextField!
    @IBOutlet var bpmField: UITextField!
    @IBOutlet var editSongTableView: UITableView!
    
    var song: Song!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songNameField.text = song.name

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
