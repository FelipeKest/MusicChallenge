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
    
    
    override func viewDidLoad() {
        
        setupKeyboardDismissRecognizer()
        
        concludeButton.layer.cornerRadius = 8
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(EditBandViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
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
