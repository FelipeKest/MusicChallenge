//
//  CheckingInfoViewController.swift
//  MusicChallenge
//
//  Created by Lucas de Lima Gouveia on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class CheckingInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var concludeButton: UIButton!
    
   // @IBOutlet weak var pickerViewGender: UIPickerView!
//    @IBOutlet weak var pickerViewInstruments: UIPickerView!
    
    
    var gender = ["Feminino", "Masculino"]
    //var instruments = ["Electric Guitar", "Acoustic Guitar", "Bass", "Drums","Keyboard/Piano",  ]
    var instruments: [Instrument] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        concludeButton.layer.cornerRadius = 8
        //self.pickerViewGender.delegate = self
        //self.pickerViewGender.dataSource = self
//        self.pickerViewInstruments.delegate = self
//        self.pickerViewInstruments.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerViewGender(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.gender.count
    }
    
    func pickerViewInstruments(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.instruments.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.gender[row]
    }
    
    func pickerViewInstruments(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.instruments[row].text
    }

    
    @IBAction func register(_ sender: Any) {
        let name = txtName.text
        let email = txtEmail.text
        let age = txtAge.text
        //let gender = self.pickerViewGender.selectedRow(inComponent: 0)
        //let instrument = pickerViewInstruments.selectedRow(inComponent: 0)
        
//        print(gender)
//        print(self.gender[gender])
        
     
        
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
