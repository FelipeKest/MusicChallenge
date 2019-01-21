//
//  NewEventViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

protocol NewEventProtocol {
    func getEvent (newEvent: Event)
}

class NewEventViewController: UIViewController , SelectSetlistProtocol{
    
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
    
    var newEvent: Event?
    var selectedSetlist: Setlist?
    
    var delegate: NewEventProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDismissKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        datePicker.date = Date()
        
        print(selectedSetlist?.name ?? "No setlist")
        
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
        let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente retirar a setlist \(newEvent?.associatedSetlist?.name ?? "ERROR") do evento?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Retirar", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
            if (nameField.text?.isEmpty)! || (locationField.text?.isEmpty)! {
              print("textfields vazias")
            }
            else {
            
            newEvent = Event(name: nameField.text ?? "ERROR", place: locationField.text ?? "ERROR", date: datePicker.date, bandID: "aaasfssavv", id: "156264773")
            
            if eventTypeSelector.isEnabledForSegment(at: 0) {
                newEvent?.eventType = EventTypes.Show
            }
            else{
                newEvent?.eventType = EventTypes.Rehearsal
            }
            
            newEvent?.associatedSetlist = selectedSetlist
            
            delegate?.getEvent(newEvent: newEvent!)
            
            dismiss(animated: true, completion: nil)
        }
    }
}
