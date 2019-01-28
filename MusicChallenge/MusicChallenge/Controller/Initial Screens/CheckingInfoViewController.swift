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
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var instruments = [Instrument.Bass.text,Instrument.Drums.text,Instrument.Guitar.text,Instrument.Others.text,Instrument.Singer.text]


    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.isHidden = true
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.txtName.delegate = self
        self.txtAge.delegate = self
        
        // Do any additional setup after loading the view.
        SessionManager.getCurrentUser { (musician, error) in

            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }

            if let _ = musician {
                print("tem musico")
                if let _ = musician?.band {
                    //tem musico e banda
                    print("tem banda")
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main") as? UITabBarController else {return}
                    DispatchQueue.main.async {
                        self.present(destinationViewController, animated: true, completion: nil)
                    }
                    return
                } else {
                    //tem musico sem banda
                    let bandStoryboard = UIStoryboard(name: "JoinBand", bundle: Bundle.main)
                    guard let destinationViewController = bandStoryboard.instantiateViewController(withIdentifier: "JoinBand") as? JoinBandViewController else {return}
                    DispatchQueue.main.async {
                        self.present(destinationViewController, animated: true, completion: nil)
                    }
                }
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
        
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        self.view.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.8)
        
        guard let realName =  name else {return}
        guard let strAge = age else {return}
        
        guard let realAge = Int(strAge) else {return}
        guard let userID = SessionManager.currentUserID else {print("error fetching uid"); return}
        
        let musician = Musician(name: realName, age: realAge, band: nil, id: userID, musicianRecordName: nil)
        
        DAO.createMusician(musician: musician) { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    print(error?.localizedDescription as Any)
                    return
                }
            }

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                let wantedStoryboard = UIStoryboard(name: "JoinBand", bundle: Bundle.main)
                let vc = wantedStoryboard.instantiateViewController(withIdentifier: "JoinBand")
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
