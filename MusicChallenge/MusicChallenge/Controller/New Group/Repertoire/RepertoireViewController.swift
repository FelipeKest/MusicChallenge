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
                            Instrument(type: InstrumentTypes.Bass, id: ""),
                            Instrument(type: InstrumentTypes.Guitar, id: ""),
                            Instrument(type: InstrumentTypes.Drums, id: ""),
                            Instrument(type: InstrumentTypes.Singer, id: "")
                            ],
                                  bandID: "", id: ""),
                         
                        Song(name: "MEGALOVANIA", instruments: [
                            Instrument(type: InstrumentTypes.Others, id: ""),
                            Instrument(type: InstrumentTypes.Guitar, id: "")],
                                  bandID: "", id: ""),
                         
                        Song(name: "Love Of My Life (Acapella)", instruments: [
                            Instrument(type: InstrumentTypes.Singer, id: ""),
                            Instrument(type: InstrumentTypes.Singer, id: ""),
                            Instrument(type: InstrumentTypes.Singer, id: ""),
                            Instrument(type: InstrumentTypes.Singer, id: ""),
                            Instrument(type: InstrumentTypes.Singer, id: "")],
                                  bandID: "", id: ""),
        
                        Song(name: "The Sound Of Silence", instruments: [
                            Instrument(type: InstrumentTypes.Bass, id: "")], bandID: "", id: "")
        
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
                iconArray[i]?.image = song.instruments[i].type.image
            }
            
            cellRepertoire.additionalInstruments.text = "+\(song.instruments.count - 4)"
        }
        else{
            for i in 0...song.instruments.count-1 {
                iconArray[i]?.image = song.instruments[i].type.image
            }
            
            cellRepertoire.additionalInstruments.text = ""
        }
        
        cellRepertoire.songName.text = song.name
    
        
        return cellRepertoire
    }
    
    
    
    
    
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSong", sender: self)
    }*/
    
    
    
    
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OneSongViewController{
            let index = repertoireTableView.indexPathForSelectedRow?.last
            //destination
        }
    }*/
}
