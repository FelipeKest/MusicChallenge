//
//  RepertoireViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela de repertório

import UIKit

class RepertoireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var repertoireTableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var addSongButton: UIBarButtonItem!
    @IBOutlet var songSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.repertoireTableView.dataSource = self
        self.repertoireTableView.delegate = self
        self.songSearchBar.delegate = self
        self.songSearchBar.returnKeyType = UIReturnKeyType.done
        reload()*/
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellRepertoire = tableView.dequeueReusableCell(withIdentifier: "cellRepertoire", for: indexPath) as! RepertoireTableViewCell
        
        return cellRepertoire
    }

}
