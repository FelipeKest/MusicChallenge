//
//  EditSetlistViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 09/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditSetlistViewController: UIViewController {

    @IBOutlet var setlistNameField: UITextField!
    
    var setlist: Setlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissRecognizer()
        setlistNameField.text = setlist.name

        // Do any additional setup after loading the view.
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(EditSongViewController.dismissKeyboard))
        
        tapRecognizer.cancelsTouchesInView = true
        
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

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
