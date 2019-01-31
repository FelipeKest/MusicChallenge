//
//  EditProfileViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 29/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
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
        
                // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
