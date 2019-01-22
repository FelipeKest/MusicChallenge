//
//  EventViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 10/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var createdBy: UILabel!
    @IBOutlet var eventSetlistName: UILabel!
    @IBOutlet var setlistSongQtd: UILabel!
    @IBOutlet var eventSetlistTableView: UITableView!
    @IBOutlet var goToSetlist: UIButton!
    @IBOutlet var eventTypeImage: UIImageView!
    @IBOutlet weak var acesseLabel: UILabel!
    

    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
        
        //createdBy.text =
        
        // Do any additional setup after loading the view.
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.eventSetlistTableView.dataSource = self
        self.eventSetlistTableView.delegate = self
        
        let tableXib = UINib(nibName: "RepertoireTableViewCell", bundle: nil)
        eventSetlistTableView.register(tableXib, forCellReuseIdentifier: "repertoireCell")
        
        eventName.text = event.name
        eventDate.text = event.date.toString(dateFormat: "dd-MM-yyyy")
        eventLocation.text = event.location
        eventTypeImage.image = event.eventType.image
        
        if event.associatedSetlist != nil {
            eventSetlistName.text = "Setlist: \(event.associatedSetlist?.name ?? "nenhuma")"
            
            setlistSongQtd.text = "\(event.associatedSetlist?.songs.count ?? 0) músicas"
            
            eventSetlistTableView.isHidden = false
            
            acesseLabel.isHidden = true
        }
        else {
            eventSetlistTableView.isHidden = true
            goToSetlist.isHidden = true
            
            eventSetlistName.text = "Sem setlist atrelada."
            
            acesseLabel.text = "Acesse 'editar' para adicionar uma."
            
            setlistSongQtd.isHidden = true
            
            acesseLabel.isHidden = false
        }
        
        if let index = self.eventSetlistTableView.indexPathForSelectedRow{
            self.eventSetlistTableView.deselectRow(at: index, animated: true)
        }
        
        eventSetlistTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (event.associatedSetlist?.songs.count) ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songsCell = tableView.dequeueReusableCell(withIdentifier: "repertoireCell", for: indexPath) as! RepertoireTableViewCell
        
        let song = event.associatedSetlist?.songs[indexPath.row]
        var iconArray = [songsCell.instrument0, songsCell.instrument1, songsCell.instrument2, songsCell.instrument3]
        
        if (song?.musicians.count)! > 4{
            for i in 0...3 {
                iconArray[i]?.image = song?.musicians[i].instrument?.image
            }
            
            songsCell.additionalInstruments.text = "+\((song?.musicians.count)! - 4)"
        }
        else{
            for i in 0...(song?.musicians.count)!-1 {
                iconArray[i]?.image = song?.musicians[i].instrument?.image
            }
            
            songsCell.additionalInstruments.text = ""
        }
        
        songsCell.songName.text = song?.name
        
        
        return songsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showSong", sender: indexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSetlist" {
            let destination = segue.destination as? OneSetlistViewController
            destination?.setlist = event.associatedSetlist
        }
        if segue.identifier == "showSong" {
            let destination = segue.destination as? OneSongViewController
            let index = eventSetlistTableView.indexPathForSelectedRow?.row
            destination?.song = event.associatedSetlist?.songs[index!]
        }
        if segue.identifier == "editEvent" {
            let destination = segue.destination as? EditEventViewController
            destination?.event = event
        }
        
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        if event.associatedSetlist != nil {
            let ac = UIActivityViewController(activityItems: ["Minha Banda estará no evento \(event.name) que acontece no dia \(event.date.toString(dateFormat: "dd-MM-yyyy")) em \(event.location)! Estamos preparando uma setlist incrível para o evento que contém \(event.associatedSetlist?.songs.count ?? 0) músicas!!! Esperamos vocês lá! Baixem o app BandPlan!"], applicationActivities: [])
            present(ac, animated: true)
        }
        else {
            let ac = UIActivityViewController(activityItems: ["Minha Banda estará no evento \(event.location), que acontece no dia \(event.date.toString(dateFormat: "dd-MM-yyyy")) em \(event.location)! Esperamos vocês lá! Baixem o app BandPlan!"], applicationActivities: [])
            present(ac, animated: true)
        }
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente excluir o evento \(event.name)?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Excluir", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "editEvent", sender: self)
    }
    
    @IBAction func goToSetlist(_ sender: Any) {
        performSegue(withIdentifier: "showSetlist", sender: self)
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
