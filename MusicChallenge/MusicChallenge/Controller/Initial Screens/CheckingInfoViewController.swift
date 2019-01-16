//
//  CheckingInfoViewController.swift
//  MusicChallenge
//
//  Created by Lucas de Lima Gouveia on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class CheckingInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var instruments = [Instrument.Bass.text,Instrument.Drums.text,Instrument.Guitar.text,Instrument.Others.text,Instrument.Singer.text]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.txtName.delegate = self
        self.txtEmail.delegate = self
        self.txtAge.delegate = self
        
        // Do any additional setup after loading the view.
        SessionManager.getCurrentUser { (musician, error) in
            
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            if let _ = musician {
                if let _ = musician?.band {
                    //tem musico e banda
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main") as? UITabBarController else {return}
                    self.present(destinationViewController, animated: true, completion: nil)
                    return
                }
                //tem musico sem banda
                let bandStoryboard = UIStoryboard(name: "JoinBand", bundle: Bundle.main)
                guard let destinationViewController = bandStoryboard.instantiateViewController(withIdentifier: "JoinBand") as? JoinBandViewController else {return}
                self.present(destinationViewController, animated: true, completion: nil)
            }
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.instruments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.instruments[row]
    }

    
    @IBAction func register(_ sender: Any) {
        //Pegar nome e email do icloud
        let name = txtName.text
        let age = txtAge.text
        
        guard let realName =  name else {return}
        guard let strAge = age else {return}
        
        guard let realAge = Int(strAge) else {return}
        guard let userID = SessionManager.currentUserID else {print("error fetching uid"); return}
        
        let musician = Musician(name: realName, age: realAge, band: nil, id: userID)
        
        DAO.createMusician(musician: musician) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            DispatchQueue.main.async {
                let wantedStoryboard = UIStoryboard(name: "CreateBand", bundle: Bundle.main)
                
                let vc = wantedStoryboard.instantiateViewController(withIdentifier: "JoinBandViewController")
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
