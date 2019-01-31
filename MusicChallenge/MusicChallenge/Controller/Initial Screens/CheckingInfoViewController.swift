//
//  CheckingInfoViewController.swift
//  MusicChallenge
//
//  Created by Lucas de Lima Gouveia on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class CheckingInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectInstrumentProtocol {
    
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var concludeButton: UIButton!
    @IBOutlet var instrumentsTableView: UITableView!
    
   // @IBOutlet weak var pickerViewGender: UIPickerView!
//    @IBOutlet weak var pickerViewInstruments: UIPickerView!
    
    
    var gender = ["Feminino", "Masculino"]
    //var instruments = ["Electric Guitar", "Acoustic Guitar", "Bass", "Drums","Keyboard/Piano",  ]
    var selectedInstruments: [Instrument] = []
    
    var profile = Musician(name: "Felipe Gouveia", age: 75, instruments:
        [
        ]
        , band: Band(), id: "asdgkasdkasdh")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instrumentsTableView.dataSource = self
        instrumentsTableView.delegate = self
        
        let tableXib = UINib(nibName: "InstrumentsTableViewCell", bundle: nil)
        instrumentsTableView.register(tableXib, forCellReuseIdentifier: "instrumentCell")
        
        instrumentsTableView.allowsSelection = false
        
        
        selectedInstruments = profile.instruments ?? []
        
        self.setupDismissKeyboard()
        
        concludeButton.layer.cornerRadius = 8
        //self.pickerViewGender.delegate = self
        //self.pickerViewGender.dataSource = self
//        self.pickerViewInstruments.delegate = self
//        self.pickerViewInstruments.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    func getInstrument(instrument: Instrument) {
        selectedInstruments.append(instrument)
        
        instrumentsTableView.reloadData()
        
        //print(selectedInstruments.description)
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedInstruments.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInstrument = tableView.dequeueReusableCell(withIdentifier: InstrumentsTableViewCell.identifier, for: indexPath) as! InstrumentsTableViewCell
        
        cellInstrument.instrumentImage.image = selectedInstruments[indexPath.row].image
        cellInstrument.instrumentName.text = selectedInstruments[indexPath.row].text
        
        return cellInstrument
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete Pressed")
            let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente retirar o instrumento \(selectedInstruments[indexPath.row].text) do seu perfil?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Retirar", style: .destructive)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }

    
    @IBAction func register(_ sender: Any) {
        let name = txtName.text
        let age = txtAge.text
        //let gender = self.pickerViewGender.selectedRow(inComponent: 0)
        //let instrument = pickerViewInstruments.selectedRow(inComponent: 0)
//        print(gender)
//        print(self.gender[gender])
    }
    
    
    @IBAction func addInstrument(_ sender: Any) {
        let sb = UIStoryboard(name: "SelectInstrumentPopUp", bundle: Bundle.main)
        
        let vc = sb.instantiateViewController(withIdentifier: SelectInstrumentPopUpViewController.identifier) as! SelectInstrumentPopUpViewController
        
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
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
