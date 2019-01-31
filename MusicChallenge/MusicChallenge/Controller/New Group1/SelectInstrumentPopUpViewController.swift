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

class SelectInstrumentPopUpViewController: UIViewController {

    @IBOutlet var instrumentPicker: UIPickerView!
    
    var delegate: SelectInstrumentProtocol?
    
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

}
