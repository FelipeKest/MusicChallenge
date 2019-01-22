//
//  ImportFromSetlistViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller da tela de importar músicas do repertório para uma setlist.

import UIKit

protocol SelectFromRepertoireProtocol {
    func getSongs(selectedSongs: [Song])
}

class ImportFromRepertoireViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var repertoireTableView: UITableView!
    
    static let identifier = "ImportFromRepertoireStoryboard"
    
    var delegate: SelectFromRepertoireProtocol?
    
    var checked = [Bool]()
    var selectedSongs: [Song] = []
    
    var songs: [Song] = [Song(name: "Watermelon Man"), Song(name: "Stairway To Heaven"), Song(name: "Hit The Road, Jack"), Song(name: "Pinball Wizard", instruments: [SongMusician.init(musician: Musician(), instrument: Instrument.Drums), SongMusician.init(musician: Musician(), instrument: Instrument.Guitar)], creator: Musician(), id: "aaaaaaaaaaaaa")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.repertoireTableView.dataSource = self
        self.repertoireTableView.delegate = self
        
        checked = Array(repeating: false, count: songs.count)
        
        repertoireTableView.allowsMultipleSelection = true
        let tableXib = UINib(nibName: "RepertoireTableViewCell", bundle: nil)
        repertoireTableView.register(tableXib, forCellReuseIdentifier: "repertoireCell")

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellRepertoire = tableView.dequeueReusableCell(withIdentifier: "repertoireCell", for: indexPath) as! RepertoireTableViewCell
        
        let song = songs[indexPath.row]
        var iconArray = [cellRepertoire.instrument0, cellRepertoire.instrument1, cellRepertoire.instrument2, cellRepertoire.instrument3, cellRepertoire.instrument4]
        
        if song.musicians.count > 5{
            for i in 1...4 {
                iconArray[i]?.image = song.musicians[i].instrument?.image
            }
            cellRepertoire.instrument0.isHidden = true
            cellRepertoire.additionalInstruments.text = "+\(song.musicians.count - 4)"
        }
        else{
            for i in 0...song.musicians.count-1 {
                iconArray[i]?.image = song.musicians[i].instrument?.image
            }
            
            cellRepertoire.additionalInstruments.text = ""
        }
        
        cellRepertoire.songName.text = song.name
        
        if checked[indexPath.row] == false{
            cellRepertoire.accessoryType = .none
        } else if checked[indexPath.row] {
            cellRepertoire.accessoryType = .checkmark
        }
        
        
        return cellRepertoire
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            cell.tintColor = UIColor.red
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
            }
        }
        
        //delegate?.getSong(selectedSong: songs[indexPath.row])
        //self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        //passar array de músicas selecionadas para o delegate
        for i in 0...songs.count-1 {
            if checked[i] == true {
                print(songs[i].name)
                selectedSongs.append(songs[i])
            }
        }
        
        if selectedSongs.count > 0 {
            delegate?.getSongs(selectedSongs: selectedSongs)
            dismiss(animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
