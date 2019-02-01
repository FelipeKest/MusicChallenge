//
//  CreateSetlistViewController.swift
//  MusicChallenge
//
//  Created by Lucas de Lima Gouveia on 21/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

protocol NewSetlistProtocol {
    func getSetlist (newSetlist: Setlist)
}

class CreateSetlistViewController: UIViewController {
    
    @IBOutlet var nameField: UITextField!
    
    var newSetlist: Setlist?
    
    var delegate: NewSetlistProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDismissKeyboard()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        if (nameField.text?.isEmpty)! {
            print("nameField vazia")
            
            let emptyTextfieldAlert = UIAlertController(title: nil, message: "Preencha todos os campos de texto.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            emptyTextfieldAlert.addAction(okAction)
            
            self.present(emptyTextfieldAlert, animated: true, completion: nil)
            
        }
        else {
            newSetlist = Setlist(name: nameField?.text ?? "ERROR", songs: [])
            delegate?.getSetlist(newSetlist: newSetlist ?? Setlist(name: "ERROR", songs: []))
            print(newSetlist?.name ?? "NO SETLIST")
            dismiss(animated: true, completion: nil)
        }
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
