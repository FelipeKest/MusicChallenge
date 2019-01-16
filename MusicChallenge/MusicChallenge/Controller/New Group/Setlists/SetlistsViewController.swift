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
            
            Song(name: "Born To Be Wild"),
            
            Song(name: "MEGALOVANIA"),
            
            Song(name: "Love Of My Life (Acapella)"),
            
            Song(name: "The Sound Of Silence")
            ]
        ),
        
        Setlist(name: "SÓ AS TOP", songs: [
            
            Song(name: "MEGALOVANIA"),
            
            Song(name: "MEGALOVANIA DRUM COVER"),
            
            Song(name: "MEGALOVANIA ACAPELLA"),
            
            Song(name: "MEGALOVANIA PT.2")
            ]
        ),
        
        Setlist(name: "Jazzlike", songs: [
            
            Song(name: "Watermelon Man"),
            
            Song(name: "Gran Turismo 3 Theme"),
            
            Song(name: "Epic Sax Guy"),
            
            Song(name: "21st Century Schizoid Man"),
            
            Song(name: "Get Back")
            ]
        )
    ]
    
    
    
    override func viewDidLoad() {
        
        self.setlistsCollectionView.dataSource = self
        self.setlistsCollectionView.delegate = self
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
        
        setlistCell.numberOfSongs.text = "\(setlists[indexPath.row].songs.count)"
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
