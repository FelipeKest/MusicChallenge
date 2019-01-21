//
//  CreateSongViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Viewcontroller da tela de criar uma música.

import UIKit

class CreateSongViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var instrumentsTableView: UITableView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var keyField: UITextField!
    @IBOutlet var bpmField: UITextField!
    
    var newSong: Song?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissRecognizer()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        instrumentsTableView.delegate = self
        instrumentsTableView.dataSource = self
        
        let tableXib = UINib(nibName: "InstrumentsTableViewCell", bundle: nil)
        instrumentsTableView.register(tableXib, forCellReuseIdentifier: "instrumentsCell")
    }
    
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(EditSongViewController.dismissKeyboard))
        
        tapRecognizer.cancelsTouchesInView = true
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newSong?.musicians.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let instrumentsCell = tableView.dequeueReusableCell(withIdentifier: InstrumentsTableViewCell.identifier, for: indexPath) as! InstrumentsTableViewCell
        
        instrumentsCell.instrumentImage.image = newSong?.musicians[indexPath.row].instrument?.image
        instrumentsCell.instrumentName.text = newSong?.musicians[indexPath.row].instrument?.text
        instrumentsCell.musicianName.text = newSong?.musicians[indexPath.row].musician?.name
        
        return instrumentsCell
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
