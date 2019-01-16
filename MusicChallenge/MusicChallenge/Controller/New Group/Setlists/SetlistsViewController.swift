//
//  SongsViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class SetlistsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var setlistsCollectionView: UICollectionView!
    //@IBOutlet var segmentedControl: UISegmentedControl!
    //@IBOutlet var addSetlistButton: UIBarButtonItem!
    
    var setlists: [Setlist] = [
        
        Setlist(name: "Rock Diversas", songs: [
            
            Song(name: "Born To Be Wild", instruments: [
                Instrument(type: InstrumentTypes.Bass, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: ""),
                Instrument(type: InstrumentTypes.Drums, id: ""),
                Instrument(type: InstrumentTypes.Singer, id: "")
                ],
                      bandID: "", id: ""),
            
            Song(name: "MEGALOVANIA", instruments: [
                Instrument(type: InstrumentTypes.Others, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: "")
                ],
                      bandID: "", id: ""),
            
            Song(name: "Love Of My Life (Acapella)", instruments: [
                Instrument(type: InstrumentTypes.Singer, id: ""),
                Instrument(type: InstrumentTypes.Singer, id: ""),
                Instrument(type: InstrumentTypes.Singer, id: ""),
                Instrument(type: InstrumentTypes.Singer, id: ""),
                Instrument(type: InstrumentTypes.Singer, id: "")
                ],
                      bandID: "", id: ""),
            
            Song(name: "The Sound Of Silence", instruments: [
                Instrument(type: InstrumentTypes.Bass, id: "")
                ], bandID: "", id: "")
            
            ]
            , bandID: "", id: ""),
        
        Setlist(name: "SÓ AS TOP", songs: [
            
            Song(name: "MEGALOVANIA", instruments: [
                Instrument(type: InstrumentTypes.Bass, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: ""),
                Instrument(type: InstrumentTypes.Drums, id: ""),
                Instrument(type: InstrumentTypes.Singer, id: "")
                ],
                      bandID: "", id: ""),
            
            Song(name: "MEGALOVANIA DRUM COVER", instruments: [
                Instrument(type: InstrumentTypes.Drums, id: ""),
                Instrument(type: InstrumentTypes.Drums, id: "")
                ],
                      bandID: "", id: ""),
            
            Song(name: "MEGALOVANIA ACAPELLA", instruments: [
                Instrument(type: InstrumentTypes.Singer, id: ""),
                Instrument(type: InstrumentTypes.Singer, id: "")
                ],
                      bandID: "", id: ""),
            
            Song(name: "MEGALOVANIA PT.2", instruments: [
                Instrument(type: InstrumentTypes.Bass, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: ""),
                Instrument(type: InstrumentTypes.Others, id: ""),
                Instrument(type: InstrumentTypes.Others, id: "")
                ], bandID: "", id: "")
            
            ]
            , bandID: "", id: ""),
        
        Setlist(name: "Jazzlike", songs: [
            
            Song(name: "Watermelon Man", instruments: [
                Instrument(type: InstrumentTypes.Bass, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: ""),
                Instrument(type: InstrumentTypes.Drums, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: "")
                ],
                 bandID: "", id: ""),
            
            Song(name: "Gran Turismo 3 Theme", instruments: [
                Instrument(type: InstrumentTypes.Bass, id: ""),
                Instrument(type: InstrumentTypes.Others, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: "")
                ],
                 bandID: "", id: ""),
            
            Song(name: "Epic Sax Guy", instruments: [
                Instrument(type: InstrumentTypes.Others, id: "")
                ],
                 bandID: "", id: ""),
            
            Song(name: "21st Century Schizoid Man", instruments: [
                Instrument(type: InstrumentTypes.Bass, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: ""),
                Instrument(type: InstrumentTypes.Others, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: "")
                ], bandID: "", id: ""),
            
            Song(name: "Get Back", instruments: [
                Instrument(type: InstrumentTypes.Bass, id: ""),
                Instrument(type: InstrumentTypes.Guitar, id: ""),
                Instrument(type: InstrumentTypes.Drums, id: ""),
                Instrument(type: InstrumentTypes.Singer, id: "")
                ], bandID: "", id: "")
            
            ]
            , bandID: "", id: ""),
        
        
    ]
    
    
    
    override func viewDidLoad() {
        
        self.setlistsCollectionView.dataSource = self
        self.setlistsCollectionView.delegate = self
        
        let collectionXib = UINib(nibName: "SetlistCollectionViewCell", bundle: nil)
        setlistsCollectionView.register(collectionXib, forCellWithReuseIdentifier: "setlistCell")
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let setlistCell = collectionView.dequeueReusableCell(withReuseIdentifier: "setlistCell", for: indexPath) as! SetlistCollectionViewCell
        
        setlistCell.numberOfSongs.text = "\(setlists[indexPath.row].songs.count) Músicas"
        setlistCell.setlistName.text = setlists[indexPath.row].name
        
        return setlistCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSetlist", sender: "self")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OneSetlistViewController {
            let index = setlistsCollectionView.indexPathsForSelectedItems?.last
            destination.setlist = setlists[(index?.item)!]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

}
