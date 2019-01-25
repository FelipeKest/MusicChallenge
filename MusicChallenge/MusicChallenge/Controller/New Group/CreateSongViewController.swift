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
    
    @IBOutlet var musiciansTableView: UITableView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var keyField: UITextField!
    @IBOutlet var bpmField: UITextField!
    
    var newSong: Song?
    
    var delegate: NewSongProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDismissKeyboard()
        
        musiciansTableView.delegate = self
        musiciansTableView.dataSource = self
        
        let tableXib = UINib(nibName: "MusiciansTableViewCell", bundle: nil)
       musiciansTableView.register(tableXib, forCellReuseIdentifier: "musiciansCell")

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newSong?.musicians.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musiciansCell = tableView.dequeueReusableCell(withIdentifier: MusiciansTableViewCell.identifier, for: indexPath) as! MusiciansTableViewCell
        
        musiciansCell.instrumentImage.image = newSong?.musicians[indexPath.row].instrument?.image
        musiciansCell.instrumentName.text = newSong?.musicians[indexPath.row].instrument?.text
        musiciansCell.musicianName.text = newSong?.musicians[indexPath.row].musician?.name
        
        return musiciansCell
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

}
