//
//  JoinBandViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller da tela de se juntar a uma banda ou criar uma.

import UIKit

class JoinBandViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtCode.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addMusician(_ sender: Any) {
        guard let code = txtCode.text else {return}
        guard let currentUser = SessionManager.currentUser else {return}
        DAO.add(musician: currentUser, bandID: code) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToBand", sender: self)
            }
        }
    }
    //    @IBAction func createBand(_ sender: Any) {
//        guard let name = txtName.text else {return}
//        guard let currentMusician = SessionManager.currentUser else {return}
//        let band = Band(name: name, members: [currentMusician], id: "")
//        DAO.createBand(band: band, user: currentMusician) { (band, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                return
//            }
//            else {
//                print("Successful")
//            }
//        }
//    }
//
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        txtCode.resignFirstResponder()
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
