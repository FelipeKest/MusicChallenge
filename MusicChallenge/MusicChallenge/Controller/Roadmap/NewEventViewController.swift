//
//  NewEventViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {
    
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
    
    var newEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        if newEvent?.associatedSetlist == nil {
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
            setlistSongQtd.text = "\(newEvent?.associatedSetlist?.songs.count ?? 0) músicas"
            setlistName.text = newEvent?.associatedSetlist?.name
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
    @IBAction func cancelButton(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
