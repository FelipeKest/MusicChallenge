//
//  CreateSongViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller da tela de criar uma música.

import UIKit

protocol NewSongProtocol {
    func getSong (newSong: Song)
}

class CreateSongViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, SelectMusicianInstrumentProtocol{
    
    
    @IBOutlet var musiciansTableView: UITableView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var keyField: UITextField!
    @IBOutlet var bpmField: UITextField!
    
    var newSong: Song?
    var selectedMusicians: [SongMusician] = []
    
    var delegate: NewSongProtocol?
    
    var refreshControl: UIRefreshControl?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDismissKeyboard()
        
        musiciansTableView.delegate = self
        musiciansTableView.dataSource = self
        
        let tableXib = UINib(nibName: "MusiciansTableViewCell", bundle: nil)
        musiciansTableView.register(tableXib, forCellReuseIdentifier: "musiciansCell")
        
        // Do any additional setup after loading the view.
        
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        musiciansTableView.reloadData()
    }
    
    func getMusician(musician: Musician, instrument: Instrument) {
        
        selectedMusicians.append(SongMusician(musician: musician, instrument: instrument))
        
        if selectedMusicians.count > 0 {
         for i in 0 ... selectedMusicians.count - 1 {
         print(selectedMusicians[i].musician?.name ?? "NAO TEM MUSICO")
         print(selectedMusicians[i].instrument?.text ?? "NAO TEM INSTRUMENTO")
            }
        }
        self.musiciansTableView.reloadData()
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        musiciansTableView.addSubview(refreshControl!)
    }
    
    
    @objc func refreshTable() {
        //songs.append(Song(name: "ATUALIZOU?"))
        musiciansTableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMusicians.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musiciansCell = tableView.dequeueReusableCell(withIdentifier: MusiciansTableViewCell.identifier, for: indexPath) as! MusiciansTableViewCell
        
        musiciansCell.instrumentImage.image = selectedMusicians[indexPath.row].instrument?.image
        musiciansCell.instrumentName.text = selectedMusicians[indexPath.row].instrument?.text
        musiciansCell.musicianName.text = selectedMusicians[indexPath.row].musician?.name
        
        return musiciansCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete Pressed")
            let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente excluir \(selectedMusicians[indexPath.row].musician?.name ?? "ERROR")?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Excluir", style: .destructive)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addInstrumentButton(_ sender: Any) {
        let sb = UIStoryboard(name: "SelectMusiciansPopUp", bundle: Bundle.main)
        
        let vc = sb.instantiateViewController(withIdentifier: SelectMusicianPopUpViewController.identifier) as! SelectMusicianPopUpViewController
        
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        if (nameField.text?.isEmpty)! {
            print("textfield vazia")
        }
        else {
            newSong = Song(name: nameField.text ?? "ERROR")
            delegate?.getSong(newSong: newSong ?? Song())
            print(newSong?.name ?? "NO SONG")
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
