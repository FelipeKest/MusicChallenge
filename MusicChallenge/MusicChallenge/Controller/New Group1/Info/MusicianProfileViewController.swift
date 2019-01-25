//
//  MusicianProfileViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela de perfil de um músico da banda

import UIKit

class MusicianProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var memberName: UILabel!
    @IBOutlet var memberAge: UILabel!
    
    @IBOutlet var instrumentsLabel: UILabel!
    @IBOutlet var instrumentsTableView: UITableView!
    
    var profile = Musician(name: "Lucas Kestelmann", age: 57, instruments: [Instrument.Guitar, Instrument.Drums, Instrument.Singer], band: Band(), id: "asldmglwmrogw")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instrumentsTableView.delegate = self
        instrumentsTableView.dataSource = self
        
        let tableXib = UINib(nibName: "InstrumentsTableViewCell", bundle: nil)
        instrumentsTableView.register(tableXib, forCellReuseIdentifier: "instrumentCell")
        
        // Do any additional setup after loading the view.
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.instruments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellInstrument = tableView.dequeueReusableCell(withIdentifier: InstrumentsTableViewCell.identifier, for: indexPath) as! InstrumentsTableViewCell
        
        cellInstrument.instrumentImage.image = profile.instruments?[indexPath.row].image
        cellInstrument.instrumentName.text = profile.instruments?[indexPath.row].text
        
        return cellInstrument
        
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeButton(_ sender: Any) {
        
    }
    

}
