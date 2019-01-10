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
    
    
    var events: [Event] = [Event(name: "Rock in Rio 2197", place: "Terra 2", date: String("10-10-2197").toDate(dateFormat: "dd-MM-yyyy"), bandID: "asafasf", id: "1215578"), Event(name: "Ensaio p/ o Lopalazooba", place: "Casa do Jordel", date: String("05-07-1873").toDate(dateFormat: "dd-MM-yyyy"), setlist: Setlist(name: "Paulera", songs: [], bandID: "1231214", id: "124124124"), bandID: "asafasf", id: "1215578")]
    
    override func viewDidLoad() {
        
        self.roadmapTableView.dataSource = self
        self.roadmapTableView.delegate = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.roadmapTableView.indexPathForSelectedRow{
            self.roadmapTableView.deselectRow(at: index, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! RoadmapTableViewCell
        
        eventCell.eventName.text = events[indexPath.row].name
        eventCell.horario.text = events[indexPath.row].date.toString(dateFormat: "dd-MM-yyyy")
        eventCell.location.text = events[indexPath.row].location
        
        
        if events[indexPath.row].associatedSetlist != nil { //evento tem setlist associada
            eventCell.setlist.text = "Setlist: \(events[indexPath.row].associatedSetlist?.name ?? "no_set_found")"
        }
        else { //não tem setlist associada
            eventCell.setlist.text = "Sem setlist!"
            eventCell.setlist.textColor = UIColor.lightGray
        }
        
        return eventCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEvent", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
}
