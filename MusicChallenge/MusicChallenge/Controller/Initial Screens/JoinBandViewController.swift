//
//  JoinBandViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller da tela de se juntar a uma banda ou criar uma.

import UIKit

class JoinBandViewController: UIViewController {
    
    @IBOutlet var bandCodeTextField: UITextField!
    @IBOutlet var confirmCodeButton: UIButton!
    @IBOutlet var createBandButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        confirmCodeButton.layer.cornerRadius = 8
        createBandButton.layer.cornerRadius = 8
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

}
