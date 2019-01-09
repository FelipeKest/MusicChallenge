//
//  OneSetlistViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller de uma setlist específica

import UIKit

class OneSetlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var setlistSongsTableView: UITableView!
    //@IBOutlet var setlistName: UILabel!
    @IBOutlet var songQtd: UILabel!
    @IBOutlet var statusBar: UINavigationItem!
    @IBOutlet var setlistCreator: UILabel!
    //@IBOutlet var bpm: UILabel!
    //@IBOutlet var key: UILabel!
    
    var setlist: Setlist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setlistSongsTableView.delegate = self
        self.setlistSongsTableView.dataSource = self
        
        let tableXib = UINib(nibName: "RepertoireTableViewCell", bundle: nil)
        setlistSongsTableView.register(tableXib, forCellReuseIdentifier: "repertoireCell")
        
        self.statusBar.title = setlist.name
        self.songQtd.text = "\(setlist.songs.count) Songs"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.setlistSongsTableView.indexPathForSelectedRow{
            self.setlistSongsTableView.deselectRow(at: index, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setlist.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songsCell = tableView.dequeueReusableCell(withIdentifier: "repertoireCell", for: indexPath) as! RepertoireTableViewCell
        
        let song = setlist.songs[indexPath.row]
        var iconArray = [songsCell.instrument0, songsCell.instrument1, songsCell.instrument2, songsCell.instrument3]
        
        if song.instruments.count > 4{
            for i in 0...3 {
                iconArray[i]?.image = song.instruments[i].type.image
            }
            
            songsCell.additionalInstruments.text = "+\(song.instruments.count - 4)"
        }
        else{
            for i in 0...song.instruments.count-1 {
                iconArray[i]?.image = song.instruments[i].type.image
            }
            
            songsCell.additionalInstruments.text = ""
        }
        
        songsCell.songName.text = song.name
        
        return songsCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSong" {
            let destination = segue.destination as? OneSongViewController
            let index = setlistSongsTableView.indexPathForSelectedRow?.row
            destination?.song = setlist.songs[index!]
            destination?.songSetlist = setlist
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSong", sender: self)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Como quer adicionar a música?", preferredStyle: .actionSheet)
        
        let addFromRepertoireAction = UIAlertAction(title: "Importar do repertório", style: .default)
        let newSongAction = UIAlertAction(title: "Criar nova música", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        optionMenu.addAction(addFromRepertoireAction)
        optionMenu.addAction(newSongAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    

    @IBAction func shareButton(_ sender: Any) {
        let ac = UIActivityViewController(activityItems: ["O setlist \(setlist.name) da minha banda já está com \(setlist.songs.count) músicas iradas!"], applicationActivities: [])
        present(ac, animated: true)
    }
  
    
    
    @IBAction func deleteButton(_ sender: Any) {
        let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente excluir a setlist \(setlist.name)?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Excluir", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        self.present(deleteAlert, animated: true, completion: nil)
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
