//
//  OneSongViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller de uma música específica.

import UIKit

class OneSongViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var songName: UILabel!
    //@IBOutlet var creatorName: UILabel!
    //@IBOutlet var instrumentsTableView: UITableView!
    
    @IBOutlet var instrument1: UIImageView!
    @IBOutlet var instrument2: UIImageView!
    @IBOutlet var instrument3: UIImageView!
    @IBOutlet var instrument4: UIImageView!
    @IBOutlet var instrument5: UIImageView!
    @IBOutlet var instrument6: UIImageView!
    
    @IBOutlet var key: UILabel!
    @IBOutlet var bpm: UILabel!
    
    var song: Song!
    var songSetlist: Setlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var iconArray = [instrument1, instrument2, instrument3, instrument4, instrument5, instrument6]
        
        if song.instruments.count > 6{
            for i in 0...5 {
                iconArray[i]?.image = song.instruments[i].type.image
            }
            
            /*cellRepertoire.additionalInstruments.text = "+\(song.instruments.count - 6)"*/
        }
        else{
            for i in 0...song.instruments.count-1 {
                iconArray[i]?.image = song.instruments[i].type.image
            }
            
            //additionalInstruments.text = ""
        }
        
        songName.text = song.name
        //bpm.text
        
        /*instrumentsTableView.delegate = self
        instrumentsTableView.dataSource = self*/

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //temporário!
        let songsCell = tableView.dequeueReusableCell(withIdentifier: "songsCell", for: indexPath) as! RepertoireTableViewCell
        
        return songsCell
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        if songSetlist != nil { //Está vindo de uma setlist
            let optionMenu = UIAlertController(title: nil, message: "O que deseja fazer?", preferredStyle: .actionSheet)
            
            let takeOffAction = UIAlertAction(title: "Retirar da setlist \(songSetlist?.name ?? "ERRO")", style: .default)
            let deleteAction = UIAlertAction(title: "Excluir do repertório", style: .destructive, handler: {action in
                
                let confirmationAlert = UIAlertController(title: nil, message: "Deseja realmente excluir \(self.song.name)?", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Excluir", style: .destructive)
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
                
                confirmationAlert.addAction(deleteAction)
                confirmationAlert.addAction(cancelAction)
                
                self.present(confirmationAlert, animated: true, completion: nil)
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            optionMenu.addAction(takeOffAction)
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true, completion: nil)
            
        }
        else {
            let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente excluir \(song.name)?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Excluir", style: .destructive)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        
        if songSetlist != nil {
            let ac = UIActivityViewController(activityItems: ["Minha banda possui no repertório a música \(song.name)! Estamos utilizando o app de iOS BandPlan para organizar nossa banda. Baixe você também!"], applicationActivities: [])
            present(ac, animated: true)
        }
        else {
            let ac = UIActivityViewController(activityItems: ["O setlist \(songSetlist?.name ?? "ERRO") da minha banda inclui a música \(song.name)! Estamos utilizando o app de iOS BandPlan para organizar nossa banda. Baixe você também!"], applicationActivities: [])
            present(ac, animated: true)
        }
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        
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
