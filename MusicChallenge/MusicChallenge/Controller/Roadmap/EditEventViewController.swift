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
    @IBOutlet var eventTypeSelector: UISegmentedControl!
    
    var event: Event!
    var selectedSetlist: Setlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDismissKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        datePicker.datePickerMode = UIDatePicker.Mode(rawValue: 1)!
        
        locationField.text = event.location
        nameField.text = event.name
        datePicker.date = event.date
        
        if event.associatedSetlist != nil && selectedSetlist == nil {
            selectedSetlist = event.associatedSetlist
        }
        
        print(selectedSetlist?.name ?? "NO SETLIST")
        
        if selectedSetlist == nil {
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
            setlistSongQtd.text = "\(selectedSetlist?.songs.count ?? 0) músicas"
            setlistName.text = selectedSetlist?.name
        }
    }
    
    func getSetlist(selectedSetlist: Setlist) {
        self.selectedSetlist = selectedSetlist
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
    
    @IBAction func doneButton(_ sender: Any) {
        
        if (nameField.text?.isEmpty)! || (locationField.text?.isEmpty)! {
            print("textfields vazias")
            let emptyTextfieldAlert = UIAlertController(title: nil, message: "Preencha todos os campos de texto.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            emptyTextfieldAlert.addAction(okAction)
            
            self.present(emptyTextfieldAlert, animated: true, completion: nil)
        }
        else {
            
            event.name = nameField.text ?? "ERROR"
            event.location = locationField.text ?? "ERROR"
            event.date = datePicker.date
            
            if eventTypeSelector.isEnabledForSegment(at: 0) {
                event?.eventType = EventTypes.Show
            }
            else{
                event?.eventType = EventTypes.Rehearsal
            }
            
            event?.associatedSetlist = selectedSetlist
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


