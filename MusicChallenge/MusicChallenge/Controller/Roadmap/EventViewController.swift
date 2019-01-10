//
//  EventViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 10/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var createdBy: UILabel!
    @IBOutlet var eventSetlistName: UILabel!
    @IBOutlet var setlistSongQtd: UILabel!
    @IBOutlet var eventSetlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
