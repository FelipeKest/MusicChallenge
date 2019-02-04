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

class SelectMusicianPopUpViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    

    @IBOutlet var musicianPicker: UIPickerView!
    
    static var identifier = "selectMusiciansPopUp"
    
    var delegate: SelectMusicianInstrumentProtocol?
    
    var selectedMusician = Musician()
    var selectedInstrument = Instrument.Bass
    
    let band = Band(name: "Developers of Sound", members: [
        Musician(name: "Guilherme Vassallo", age: 21, instruments: [Instrument.Guitar, Instrument.Singer, Instrument.Others], band: Band(), id: "aaaaa"),
        Musician(name: "Felipe Kestelmann", age: 21, instruments: [Instrument.Bass, Instrument.Singer], band: Band(), id: "aaaaa"),
        Musician(name: "Lucas Gouveia", age: 21, instruments: [Instrument.Drums, Instrument.Singer], band: Band(), id: "aaaaa"),
        Musician(name: "Andrew Costa", age: 21, instruments: [Instrument.Others], band: Band(), id: "aaaaa")
        ],
        id: "adjgiajigiajiga")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicianPicker.delegate = self
        musicianPicker.dataSource = self
        
         musicianPicker.setValue(UIColor.white, forKey: "textColor")
        
        musicianPicker.reloadAllComponents()
        
        selectedMusician = band.members[0]
        selectedInstrument = selectedMusician.instruments?[0] ?? Instrument.Bass
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        musicianPicker.reloadAllComponents()
        
       
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return band.members.count
        } else {
            print(selectedMusician.instruments?.count ?? "NO INSTRUMENTS")
            if (selectedMusician.instruments?.count)! > 0 {
                return (selectedMusician.instruments?.count)!
            }
            else {
                return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return band.members[row].name
        } else {
            return selectedMusician.instruments?[row].text
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMusician = band.members[row]
        } else {
            print(row)
            selectedInstrument = selectedMusician.instruments?[row] ?? Instrument.Bass
        }
        pickerView.reloadAllComponents()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            let titleData = band.members[row].name
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
            return myTitle
        } else {
            let titleData = selectedMusician.instruments?[row].text
            let myTitle = NSAttributedString(string: titleData ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            return myTitle
        }
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
        delegate?.getMusician(musician: selectedMusician, instrument: selectedInstrument)
        print(selectedInstrument)
        print(selectedMusician.name)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
