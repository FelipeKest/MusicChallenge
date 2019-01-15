//
//  EditEventViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController, SelectSetlistProtocol{
    
    @IBOutlet var locationField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var setlistLabel: UILabel!
    @IBOutlet var setlistName: UILabel!
    @IBOutlet var setlistSongQtd: UILabel!
    @IBOutlet var changeButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var addSetlistButton: UIButton!
    @IBOutlet var setlistImage: UIImageView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        locationField.text = event.location
        nameField.text = event.name
        datePicker.date = event.date
        
        if event.associatedSetlist == nil {
            setlistLabel.isHidden = true
            addSetlistButton.isHidden = false
            addSetlistButton.titleLabel?.text = "Adicionar setlist"
            setlistSongQtd.isHidden = true
            changeButton.isHidden = true
            removeButton.isHidden = true
            setlistImage.isHidden = true
            setlistName.isHidden = true
        }
        else {
            setlistLabel.isHidden = false
            setlistLabel.text = "Setlist:"
            setlistSongQtd.isHidden = false
            changeButton.isHidden = false
            removeButton.isHidden = false
            setlistImage.isHidden = false
            setlistName.isHidden = false
            addSetlistButton.isHidden = true
            setlistSongQtd.text = "\(event.associatedSetlist?.songs.count ?? 0) músicas"
            setlistName.text = event.associatedSetlist?.name
        }
    }
    
    func getSetlist(selectedSetlist: Setlist) {
        self.event.associatedSetlist = selectedSetlist
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addSetlistButton(_ sender: Any) {
        print("button pressed")
        
        let sb = UIStoryboard(name: "ChooseSetlist", bundle: Bundle.main)
        
        let vc = sb.instantiateViewController(withIdentifier: "ChooseSetlistViewController") as! ChooseSetlistViewController
        
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeButton(_ sender: Any) {
        print("button pressed")
        
        let sb = UIStoryboard(name: "ChooseSetlist", bundle: Bundle.main)
        
        let vc = sb.instantiateViewController(withIdentifier: "ChooseSetlistViewController") as! ChooseSetlistViewController
        
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func removeButton(_ sender: Any) {
        let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente retirar a setlist \(event.associatedSetlist?.name ?? "ERROR") do evento?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Retirar", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
