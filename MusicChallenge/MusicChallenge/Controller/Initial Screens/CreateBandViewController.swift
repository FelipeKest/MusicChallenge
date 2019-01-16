//
//  CreateBandViewController.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 16/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class CreateBandViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBio: UITextView!
    @IBOutlet weak var txtGenero: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtName.delegate = self
        self.txtBio.delegate = self
        self.txtGenero.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func createBand(_ sender: Any) {
        guard let name = txtName.text else {return}
        guard let currentUser = SessionManager.currentUser else {return}
        let band = Band(name: name, members: [currentUser], id: "")
        
        DAO.createBand(band: band, user: currentUser) { (savedBand, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToBand", sender: self)
            }
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
