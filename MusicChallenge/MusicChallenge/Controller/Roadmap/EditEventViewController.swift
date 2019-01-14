//
//  EditEventViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController {

    @IBOutlet var locationField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var setlistLabel: UILabel!
    @IBOutlet var setlistName: UILabel!
    @IBOutlet var setlistSongQtd: UILabel!
    @IBOutlet var changeButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var addSetlistButton: UIButton!
    @IBOutlet var setlistImage: UIImageView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        locationField.text = event.location
        nameField.text = event.name
        datePicker.date = event.date
        
        if event.associatedSetlist == nil {
            setlistLabel.isHidden = true
            addSetlistButton.titleLabel?.text = "Adicionar setlist"
            setlistSongQtd.isHidden = true
            changeButton.isHidden = true
            removeButton.isHidden = true
            setlistImage.isHidden = true
            setlistName.isHidden = true
        }
        else {
            setlistLabel.text = "Setlist:"
            addSetlistButton.isHidden = true
            setlistSongQtd.text = "\(event.associatedSetlist?.songs.count ?? 0) músicas"
            setlistName.text = event.associatedSetlist?.name
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
