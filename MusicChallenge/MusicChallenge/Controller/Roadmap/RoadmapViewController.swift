//
//  RoadmapViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela de Roadmap, onde estão os eventos da banda

import UIKit

class RoadmapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var roadmapTableView: UITableView!
    @IBOutlet var addEventButton: UIBarButtonItem!
    
    //@IBOutlet var searchBar: UISearchBar!
    //@IBOutlet var monthSelector: ? (descobrir o tipo disso)
    
    
    var events: [Event] = [Event(name: "Rock in Rio 2197", place: "Terra 2", date: Date(), bandID: "asafasf", id: "1215578")]
    
    override func viewDidLoad() {
        
        self.roadmapTableView.dataSource = self
        self.roadmapTableView.delegate = self
        
        super.viewDidLoad()

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! RoadmapTableViewCell
        
        eventCell.eventName.text = events[indexPath.row].name
        eventCell.horario.text = events[indexPath.row].date.description
        
        return eventCell
    }

}
