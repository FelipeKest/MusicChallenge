//
//  EditProfileViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 29/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, SelectInstrumentProtocol{
    
    
    
    @IBOutlet var instrumentsTableView: UITableView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var ageField: UITextField!
    
    var profile = Musician(name: "Felipe Gouveia", age: 75, instruments:
        [
            Instrument.Guitar, Instrument.Bass, Instrument.Others
        ]
        , band: Band(), id: "asdgkasdkasdh")
    
    var selectedInstruments: [Instrument] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instrumentsTableView.dataSource = self
        instrumentsTableView.delegate = self

        let tableXib = UINib(nibName: "InstrumentsTableViewCell", bundle: nil)
        instrumentsTableView.register(tableXib, forCellReuseIdentifier: "instrumentCell")
        
        selectedInstruments = profile.instruments ?? []
        
        nameField.text = profile.name
        ageField.text = "\(profile.age)"
        
                // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        instrumentsTableView.reloadData()
        
        instrumentsTableView.allowsSelection = false
        
        //print(selectedInstruments.count)
    }
    

    func getInstrument(instrument: Instrument) {
        selectedInstruments.append(instrument)
        
        instrumentsTableView.reloadData()
        
        //print(selectedInstruments.description)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addInstruments(_ sender: Any) {
        let sb = UIStoryboard(name: "SelectInstrumentPopUp", bundle: Bundle.main)
        
        let vc = sb.instantiateViewController(withIdentifier: SelectInstrumentPopUpViewController.identifier) as! SelectInstrumentPopUpViewController
        
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
}
