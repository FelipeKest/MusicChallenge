//
//  SelectInstrumentPopUpViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 31/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

protocol SelectInstrumentProtocol {
    func getInstrument(instrument: Instrument)
}

class SelectInstrumentPopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var instrumentPicker: UIPickerView!
    
    static var identifier = "selectInstrumentPopUp"
    
    var delegate: SelectInstrumentProtocol?
    
    var instruments = Instrument.allCases
    var selectedinstrument = Instrument.Bass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instrumentPicker.delegate = self
        instrumentPicker.dataSource = self

        instrumentPicker.reloadAllComponents()
        print(instruments.description)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return instruments.count
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return instruments[row].text
    }*/
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       instrumentPicker.reloadAllComponents()
        
        selectedinstrument = instruments[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = instruments[row].text
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return myTitle
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        print(selectedinstrument.text)
        
        delegate?.getInstrument(instrument: selectedinstrument)
        
        dismiss(animated: false, completion: nil)
    }
    
    
}
