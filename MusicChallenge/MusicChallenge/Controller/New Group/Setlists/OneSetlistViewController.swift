//
//  OneSetlistViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller de uma setlist específica

import UIKit

class OneSetlistViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate, SelectFromRepertoireProtocol {
    
    @IBOutlet var setlistSongsTableView: UITableView!
    //@IBOutlet var setlistName: UILabel!
    @IBOutlet var songQtd: UILabel!
    @IBOutlet var statusBar: UINavigationItem!
    @IBOutlet var setlistCreator: UILabel!
    @IBOutlet weak var setlistImage: UIImageView!
    
    @IBOutlet var noSongLabel1: UILabel!
    @IBOutlet var noSongLabel2: UILabel!
    
    //@IBOutlet var bpm: UILabel!
    //@IBOutlet var key: UILabel!
    
    var setlist: Setlist!
    
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setlistSongsTableView.delegate = self
        self.setlistSongsTableView.dataSource = self
        
        let tableXib = UINib(nibName: "RepertoireTableViewCell", bundle: nil)
        setlistSongsTableView.register(tableXib, forCellReuseIdentifier: "repertoireCell")

        addRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if setlist.songs.count == 0 {
            setlistSongsTableView.isHidden = true
            noSongLabel1.isHidden = false
            noSongLabel2.isHidden = false
        }
        else {
            setlistSongsTableView.isHidden = false
            noSongLabel2.isHidden = true
            noSongLabel1.isHidden = true
        }
        
        
        
        self.setlistCreator.text = "Criada por \(setlist.creator.name) em \(Date().toString(dateFormat: "dd-MM-yyyy"))"
        self.statusBar.title = setlist.name
        self.songQtd.text = "\(setlist.songs.count) Songs"
        
        if let index = self.setlistSongsTableView.indexPathForSelectedRow{
            self.setlistSongsTableView.deselectRow(at: index, animated: true)
        }
        
        setlistSongsTableView.reloadData()
        
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        setlistSongsTableView.addSubview(refreshControl!)
    }
    
    
    @objc func refreshTable() {
        //songs.append(Song(name: "ATUALIZOU?"))
        setlistSongsTableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    
    func getSongs(selectedSongs: [Song]) {
        for i in 0...selectedSongs.count-1 {
            print(selectedSongs[i].name)
            setlist.songs.append(selectedSongs[i])
        }
        //setlist.songs.append(selectedSong)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setlist.songs.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songsCell = tableView.dequeueReusableCell(withIdentifier: "repertoireCell", for: indexPath) as! RepertoireTableViewCell
        
        let song = setlist.songs[indexPath.row]
        var iconArray = [songsCell.instrument0, songsCell.instrument1, songsCell.instrument2, songsCell.instrument3, songsCell.instrument4]
        
        if song.musicians.count > 5{
            for i in 1...4 {
                iconArray[i]?.image = song.musicians[i].instrument?.image
            }
            songsCell.instrument0.isHidden = true
            songsCell.additionalInstruments.text = "+\(song.musicians.count - 4)"
        }
        else{
            for i in 0...song.musicians.count-1 {
                iconArray[i]?.image = song.musicians[i].instrument?.image
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
        if segue.identifier == "editSetlist" {
            let destination = segue.destination as? EditSetlistViewController
            destination?.setlist = setlist
        }
    }

    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSong", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete Pressed")
            let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente excluir \(setlist.songs[indexPath.row].name)?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Excluir", style: .destructive)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func addButton(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Como quer adicionar a música?", preferredStyle: .actionSheet)
        
        let addFromRepertoireAction = UIAlertAction(title: "Importar do repertório", style: .default) { action in
            let sb = UIStoryboard(name: "ImportFromRepertoire", bundle: Bundle.main)
            
            let vc = sb.instantiateViewController(withIdentifier: ImportFromRepertoireViewController.identifier) as! ImportFromRepertoireViewController
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        let newSongAction = UIAlertAction(title: "Criar nova música", style: .default){ action in
            self.performSegue(withIdentifier: "newSong", sender: self)
        }
        
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
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "editSetlist", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func changeImage(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
         let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        setlistImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
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
