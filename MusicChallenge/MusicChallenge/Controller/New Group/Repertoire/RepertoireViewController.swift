//
//  RepertoireViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela de repertório

import UIKit

class RepertoireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var repertoireTableView: UITableView!
    //@IBOutlet var segmentedControl: UISegmentedControl!
    //@IBOutlet var addSongButton: UIBarButtonItem!
    //@IBOutlet var songSearchBar: UISearchBar!
    
    var songs: [Song] = [
        
                        Song(name: "Born To Be Wild", instruments: [
                            Instrument.Bass,
                            Instrument.Guitar,
                            Instrument.Drums,
                            Instrument.Singer
                            ],
                             creator: Musician(), id: ""),
                         
                        Song(name: "MEGALOVANIA", instruments: [
                            Instrument.Others,
                            Instrument.Guitar],
                             creator: Musician(), id: ""),
                         
                        Song(name: "Love Of My Life (Acapella)", instruments: [
                            Instrument.Singer,
                            Instrument.Singer,
                            Instrument.Singer,
                            Instrument.Singer,
                            Instrument.Singer],
                             creator: Musician(), id: ""),
        
                        Song(name: "The Sound Of Silence", instruments: [
                            Instrument.Bass],
                             creator: Musician(),
                             id: "")
        
    ]
    
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
        var iconArray = [cellRepertoire.instrument0, cellRepertoire.instrument1, cellRepertoire.instrument2, cellRepertoire.instrument3]
        
        if song.instruments.count > 4{
            for i in 0...3 {
                iconArray[i]?.image = song.instruments[i].image
            }
            
            cellRepertoire.additionalInstruments.text = "+\(song.instruments.count - 4)"
        }
        else{
            for i in 0...song.instruments.count-1 {
                iconArray[i]?.image = song.instruments[i].image
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
    
    
    
    
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OneSongViewController{
            let index = repertoireTableView.indexPathForSelectedRow?.last
            //destination
        }
    }*/
}
