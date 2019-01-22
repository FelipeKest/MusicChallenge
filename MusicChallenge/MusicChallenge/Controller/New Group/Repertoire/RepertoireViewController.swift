//
//  RepertoireViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela de repertório

import UIKit

class RepertoireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    
    @IBOutlet var repertoireTableView: UITableView!
    //@IBOutlet var segmentedControl: UISegmentedControl!
    //@IBOutlet var addSongButton: UIBarButtonItem!
    //@IBOutlet var songSearchBar: UISearchBar!
    
    var songs: [Song] = [Song(name: "Watermelon Man"), Song(name: "Stairway To Heaven"), Song(name: "Hit The Road, Jack"), Song(name: "Pinball Wizard", instruments: [SongMusician.init(musician: Musician(), instrument: Instrument.Drums), SongMusician.init(musician: Musician(), instrument: Instrument.Guitar)], creator: Musician(), id: "aaaaaaaaaaaaa")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.repertoireTableView.dataSource = self
        self.repertoireTableView.delegate = self
        
        let tableXib = UINib(nibName: "RepertoireTableViewCell", bundle: nil)
        repertoireTableView.register(tableXib, forCellReuseIdentifier: "repertoireCell")
        //self.songSearchBar.delegate = self
        //self.songSearchBar.returnKeyType = UIReturnKeyType.done
        //reload()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.repertoireTableView.indexPathForSelectedRow{
            self.repertoireTableView.deselectRow(at: index, animated: true)
        }
        
        repertoireTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellRepertoire = tableView.dequeueReusableCell(withIdentifier: RepertoireTableViewCell.identifier, for: indexPath) as! RepertoireTableViewCell
        
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
    
        
        return cellRepertoire
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSong" {
            let destination = segue.destination as? OneSongViewController
            let index = repertoireTableView.indexPathForSelectedRow?.row
            destination?.song = songs[index!]
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showSong", sender: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete Pressed")
            let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente excluir \(songs[indexPath.row].name)?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Excluir", style: .destructive)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OneSongViewController{
            let index = repertoireTableView.indexPathForSelectedRow?.last
            //destination
        }
    }*/
}
