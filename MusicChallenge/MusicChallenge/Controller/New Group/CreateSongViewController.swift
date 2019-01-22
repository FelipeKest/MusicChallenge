//
//  CreateSongViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller da tela de criar uma música.

import UIKit

protocol NewSongProtocol {
    func getSong (newSong: Song)
}

class CreateSongViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var instrumentsTableView: UITableView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var keyField: UITextField!
    @IBOutlet var bpmField: UITextField!
    
    var newSong: Song?
    
    var delegate: NewSongProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDismissKeyboard()
        
        instrumentsTableView.delegate = self
        instrumentsTableView.dataSource = self
        
        let tableXib = UINib(nibName: "InstrumentsTableViewCell", bundle: nil)
       instrumentsTableView.register(tableXib, forCellReuseIdentifier: "instrumentsCell")

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newSong?.musicians.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let instrumentsCell = tableView.dequeueReusableCell(withIdentifier: InstrumentsTableViewCell.identifier, for: indexPath) as! InstrumentsTableViewCell
        
        instrumentsCell.instrumentImage.image = newSong?.musicians[indexPath.row].instrument?.image
        instrumentsCell.instrumentName.text = newSong?.musicians[indexPath.row].instrument?.text
        instrumentsCell.musicianName.text = newSong?.musicians[indexPath.row].musician?.name
        
        return instrumentsCell
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addInstrumentButton(_ sender: Any) {
        
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        if (nameField.text?.isEmpty)! {
            print("textfield vazia")
        }
        else {
        newSong = Song(name: nameField.text ?? "ERROR")
        delegate?.getSong(newSong: newSong ?? Song())
        print(newSong?.name ?? "NO SONG")
        
        dismiss(animated: true, completion: nil)
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

}
