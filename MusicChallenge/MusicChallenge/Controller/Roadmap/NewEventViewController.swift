//
//  NewEventViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 11/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

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
    
    var newEventSetlist: Setlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardDismissRecognizer()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        datePicker.date = Date()
        
        if newEventSetlist == nil {
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
            setlistSongQtd.text = "\(newEventSetlist?.songs.count ?? 0) músicas"
            setlistName.text = newEventSetlist?.name
        }
    }
    
    func getSetlist(selectedSetlist: Setlist) {
        self.newEventSetlist = selectedSetlist
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
        let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente retirar a setlist \(newEventSetlist?.name ?? "ERROR") do evento?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Retirar", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
