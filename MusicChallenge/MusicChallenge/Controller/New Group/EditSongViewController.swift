//
//  EditSongViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 09/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditSongViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var keyField: UITextField!
    @IBOutlet var bpmField: UITextField!
    @IBOutlet var musiciansTableView: UITableView!
    
    var band = Band()
    
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDismissKeyboard()
        
        musiciansTableView.delegate = self
        musiciansTableView.dataSource = self
        
        let tableXib = UINib(nibName: "MusiciansTableViewCell", bundle: nil)
        musiciansTableView.register(tableXib, forCellReuseIdentifier: "musiciansCell")
        
        nameField.text = song?.name

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return song?.musicians.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musiciansCell = tableView.dequeueReusableCell(withIdentifier: MusiciansTableViewCell.identifier, for: indexPath) as! MusiciansTableViewCell
        
        musiciansCell.instrumentImage.image = song?.musicians[indexPath.row].instrument?.image
        musiciansCell.instrumentName.text = song?.musicians[indexPath.row].instrument?.text
        musiciansCell.musicianName.text = song?.musicians[indexPath.row].musician?.name
        
        return musiciansCell
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addInstrumentButton(_ sender: Any) {
        
        let message = "\n\n\n\n\n\n"
        
        let alert = UIAlertController(title: "Selecione um músico e um instrumento que ele toca", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: UIScreen.main.bounds.width - 20, height: 140))
        pickerFrame.tag = 555
        pickerFrame.delegate = self as! UIPickerViewDelegate
        
        alert.view.addSubview(pickerFrame)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            
            
            
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
