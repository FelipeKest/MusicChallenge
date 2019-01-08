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
            let deleteMenu = UIAlertController(title: nil, message: "O que deseja fazer?", preferredStyle: .actionSheet)
            
            let takeOffAction = UIAlertAction(title: "Retirar da setlist \(songSetlist?.name ?? "ERRO")", style: .default)
            let deleteAction = UIAlertAction(title: "Excluir do repertório", style: .default)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            deleteMenu.addAction(takeOffAction)
            deleteMenu.addAction(deleteAction)
            deleteMenu.addAction(cancelAction)
            
            self.present(deleteMenu, animated: true, completion: nil)
            
        }
        else {
            let deleteMenu = UIAlertController(title: nil, message: "Deseja realmente excluir \(song.name)?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Excluir", style: .default)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            deleteMenu.addAction(deleteAction)
            deleteMenu.addAction(cancelAction)
            
            self.present(deleteMenu, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
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
