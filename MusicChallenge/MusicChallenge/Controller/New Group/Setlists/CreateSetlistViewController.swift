//
//  CreateSetlistViewController.swift
//  MusicChallenge
//
//  Created by Lucas de Lima Gouveia on 21/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class CreateSetlistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissRecognizer()

        // Do any additional setup after loading the view.
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CreateSetlistViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
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
