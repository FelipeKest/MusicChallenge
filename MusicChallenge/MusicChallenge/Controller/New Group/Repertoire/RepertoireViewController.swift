//
//  RepertoireViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela de repertório

import UIKit
import CloudKit

class RepertoireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var repertoireTableView: UITableView!
    //@IBOutlet var segmentedControl: UISegmentedControl!
    //@IBOutlet var addSongButton: UIBarButtonItem!
    //@IBOutlet var songSearchBar: UISearchBar!
    
    let documentsDirectoryPath:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    var imageURL: URL!
    let tempImageName = "yuan-thirdy-583227-unsplash.png"
    
   var publicDatabase: CKDatabase?
    
    var songs: [Song] = [
//                        Song(name: "Born To Be Wild"),
//                         
//                        Song(name: "MEGALOVANIA"),
//                         
//                        Song(name: "Love Of My Life (Acapella)"),
//        
//                        Song(name: "The Sound Of Silence")
        
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
        
        let image = UIImage(named: "yuan-thirdy-583227-unsplash.png")
        
        publicDatabase = DAO.database
        
        saveImage(image)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.repertoireTableView.indexPathForSelectedRow{
            self.repertoireTableView.deselectRow(at: index, animated: true)
        }
        
        guard let band = SessionManager.currentBand else {return}
        DAO.queryAllSongs(from: band, songsReferences: nil) { (error) in
            if error != nil {
                //TODO: Display Alert Controller
                print(error?.localizedDescription as Any)
            } else {
                self.songs = band.repertoire
                self.repertoireTableView.reloadData()
                print("tem",self.songs.count,"songs")
            }
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
    
    //teste de salvamento CKAsset
    func saveImage(_ image: UIImage?) {
        
        // Create a CKRecord
        let newRecord:CKRecord = CKRecord(recordType: "GuilsRecord")
        
        if let image = image {
            
            let imageData:Data = image.pngData()!
            let path:String = self.documentsDirectoryPath.appendingPathComponent(self.tempImageName)
            try? image.pngData()!.write(to: URL(fileURLWithPath: path), options: [.atomic])
            self.imageURL = URL(fileURLWithPath: path)
            try? imageData.write(to: self.imageURL, options: [.atomic])
            
            let File:CKAsset?  = CKAsset(fileURL: URL(fileURLWithPath: path))
            newRecord.setObject(File, forKey: "Image")
        }
        
        if let database = self.publicDatabase {
            
            database.save(newRecord, completionHandler: { (record:CKRecord?, error:Error?) in
                
                // Check if there was an error
                if error != nil {
                    NSLog((error?.localizedDescription)!)
                }
                else if let record = record {
                    
                    print(record.description)
                    
                }
                
                
            })
            
            
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellRepertoire = tableView.dequeueReusableCell(withIdentifier: "repertoireCell", for: indexPath) as! RepertoireTableViewCell
        
        let song = songs[indexPath.row]
        var iconArray = [cellRepertoire.instrument0, cellRepertoire.instrument1, cellRepertoire.instrument2, cellRepertoire.instrument3]
        
        if song.musicians.count > 4{
            for i in 0...3 {
                if let instrument = song.musicians[i].instrument {
                    iconArray[i]?.image = instrument.image
                }
            }
            
            cellRepertoire.additionalInstruments.text = "+\(song.musicians.count - 4)"
        }
        else{
            for i in 0...song.musicians.count-1 {
                if let instrument = song.musicians[i].instrument {
                    iconArray[i]?.image = instrument.image
                }
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
