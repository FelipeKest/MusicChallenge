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
            Song(name: "Stairway to Heaven", instruments: [SongMusician()], creator: Musician(), id: "aaaaaaaaaaaaa")]),
        Setlist(name: "Jazz Em'Up", songs: [
            Song(name: "Hit The Road, Jack", instruments: [SongMusician()], creator: Musician(), id: "aaaaaaaaaaaaa"), Song(name: "Watermelon Man", instruments: [SongMusician()], creator: Musician(), id: "aasfasasfasf")])
    ]
    
    
    
    override func viewDidLoad() {
        
        self.setlistsCollectionView.dataSource = self
        self.setlistsCollectionView.delegate = self
        
        let collectionXib = UINib(nibName: "SetlistCollectionViewCell", bundle: nil)
        setlistsCollectionView.register(collectionXib, forCellWithReuseIdentifier: "setlistCell")
//        let shape = UIView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: 0, width: 1, height: UIScreen.main.bounds.height))
//        shape.UIColor
//        shape.addSubview(self.view)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        setlistsCollectionView.reloadData()
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
}
