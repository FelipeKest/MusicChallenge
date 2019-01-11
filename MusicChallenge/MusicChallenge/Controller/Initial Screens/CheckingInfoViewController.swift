//
//  CheckingInfoViewController.swift
//  MusicChallenge
//
//  Created by Lucas de Lima Gouveia on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class CheckingInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var gender = ["Feminino", "Masculino"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.gender[row]
    }

    
    @IBAction func register(_ sender: Any) {
        let name = txtName.text
        let email = txtEmail.text
        let age = txtAge.text
        let row = self.pickerView.selectedRow(inComponent: 0)
        
        print(row)
        print(self.gender[row])
        
        
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
