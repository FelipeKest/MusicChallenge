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
    //@IBOutlet var searchBar: UISearchBar!
    //@IBOutlet var monthSelector: ? (descobrir o tipo disso)
    
    
    var events: [Event] = [
        Event(name: "Batalha de Rap Medieval", place: "Avenida Real Edinburgo", date: String("11/04/427").toDate(dateFormat: "dd-MM-yyyy"), bandID: "asghhhhhhhh", id: "sfdfasfasfasfas", eventType: EventTypes.Show),
        Event(name: "Jam Soul", place: "Casa da Gleidi", date: String("10/10/2010").toDate(dateFormat: "dd-MM-yyyy"), setlist: Setlist(name: "Cool", songs: [Song(name: "CoolSong")]), bandID: "333333333", id: "4444444444", eventType: EventTypes.Rehearsal)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.roadmapTableView.dataSource = self
        self.roadmapTableView.delegate = self
        
        
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
        eventCell.eventTypeImage.image = events[indexPath.row].eventType.image
        
        
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
        if segue.identifier == "showEvent" {
            let destination = segue.destination as? EventViewController
            let index = roadmapTableView.indexPathForSelectedRow?.row
            destination?.event = events[index!]
        }
    }
    
   
    
    @IBAction func addEvent(_ sender: Any) {
        performSegue(withIdentifier: "newEvent", sender: self)
    }
    
}
