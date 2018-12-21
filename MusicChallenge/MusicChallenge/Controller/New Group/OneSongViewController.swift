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
    @IBOutlet var creatorName: UILabel!
    @IBOutlet var instrumentsTableView: UITableView!
    
    //var song: Song = Song(name: <#T##String#>, instruments: <#T##[Instrument]#>, bandID: <#T##String#>, id: <#T##String#>)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instrumentsTableView.delegate = self
        instrumentsTableView.dataSource = self

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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
