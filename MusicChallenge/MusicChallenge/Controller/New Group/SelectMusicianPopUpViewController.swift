//
//  SelectMusicianPopUpViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 28/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

protocol SelectMusicianInstrumentProtocol {
    func getMusician (musician: Musician, instrument: Instrument)
}

class SelectMusicianPopUpViewController: UIViewController {

    @IBOutlet var musicianPicker: UIPickerView!
    
    var delegate: SelectMusicianInstrumentProtocol?
    
    let band = Band(name: "Developers of Sound", members: [
        Musician(name: "Guilherme Vassallo", age: 21, instruments: [Instrument.Guitar, Instrument.Singer, Instrument.Others], band: Band(), id: "aaaaa"),
        Musician(name: "Guilherme Vassallo", age: 21, instruments: [Instrument.Bass, Instrument.Singer], band: Band(), id: "aaaaa"),
        Musician(name: "Guilherme Vassallo", age: 21, instruments: [Instrument.Drums, Instrument.Singer], band: Band(), id: "aaaaa"),
        Musician(name: "Andrew Costa", age: 21, instruments: [Instrument.Others], band: Band(), id: "aaaaa")
        ],
        id: "adjgiajigiajiga")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func confirmButton(_ sender: Any) {
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
