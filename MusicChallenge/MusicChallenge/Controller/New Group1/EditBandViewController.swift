//
//  EditBandViewController.swift
//  MusicChallenge
//
//  Created by Lucas de Lima Gouveia on 16/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditBandViewController: UIViewController {

    @IBOutlet weak var concludeButton: UIButton!
    @IBOutlet weak var formationDate: UIDatePicker!
    
    
    override func viewDidLoad() {
        
        formationDate.setValue(UIColor.white, forKey: "textColor")
        
        formationDate.datePickerMode = UIDatePicker.Mode(rawValue: 1)!
        
        self.setupDismissKeyboard()
        
        concludeButton.layer.cornerRadius = 8
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
