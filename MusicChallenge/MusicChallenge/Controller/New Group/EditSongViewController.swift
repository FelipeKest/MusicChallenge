//
//  EditSongViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 09/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditSongViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var keyField: UITextField!
    @IBOutlet var bpmField: UITextField!
    @IBOutlet var musiciansTableView: UITableView!
    
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDismissKeyboard()
        
        musiciansTableView.delegate = self
        musiciansTableView.dataSource = self
        
        let tableXib = UINib(nibName: "MusiciansTableViewCell", bundle: nil)
        musiciansTableView.register(tableXib, forCellReuseIdentifier: "musiciansCell")
        
        nameField.text = song?.name

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return song?.musicians.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musiciansCell = tableView.dequeueReusableCell(withIdentifier: MusiciansTableViewCell.identifier, for: indexPath) as! MusiciansTableViewCell
        
        musiciansCell.instrumentImage.image = song?.musicians[indexPath.row].instrument?.image
        musiciansCell.instrumentName.text = song?.musicians[indexPath.row].instrument?.text
        musiciansCell.musicianName.text = song?.musicians[indexPath.row].musician?.name
        
        return musiciansCell
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addInstrumentButton(_ sender: Any) {
        
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
