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
    @IBOutlet var instrumentsTableView: UITableView!
    
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissRecognizer()
        
        instrumentsTableView.delegate = self
        instrumentsTableView.dataSource = self
        
        let tableXib = UINib(nibName: "InstrumentsTableViewCell", bundle: nil)
        instrumentsTableView.register(tableXib, forCellReuseIdentifier: "instrumentsCell")
        
        nameField.text = song?.name

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return song?.musicians.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let instrumentsCell = tableView.dequeueReusableCell(withIdentifier: InstrumentsTableViewCell.identifier, for: indexPath) as! InstrumentsTableViewCell
        
        instrumentsCell.instrumentImage.image = song?.musicians[indexPath.row].instrument?.image
        instrumentsCell.instrumentName.text = song?.musicians[indexPath.row].instrument?.text
        instrumentsCell.musicianName.text = song?.musicians[indexPath.row].musician?.name
        
        return instrumentsCell
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
