//
//  RoadmapViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela de Roadmap, onde estão os eventos da banda

import UIKit

class RoadmapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewEventProtocol {
    
    
    @IBOutlet var roadmapTableView: UITableView!
    //@IBOutlet var searchBar: UISearchBar!
    //@IBOutlet var monthSelector: ? (descobrir o tipo disso)
    
    
    var events: [Event] = [
        Event(name: "Festival de Rock", place: "Avenida Real Edinburgo", date: String("11/04/2019").toDate(dateFormat: "dd-MM-yyyy"), bandID: "asghhhhhhhh", id: "sfdfasfasfasfas", eventType: EventTypes.Show),
        Event(name: "Jam Soul", place: "Casa da Gleidi", date: String("10/10/2019").toDate(dateFormat: "dd-MM-yyyy"), setlist: Setlist(name: "Jazz Em'Up", songs: [
            Song(name: "Hit The Road, Jack", instruments: [SongMusician()], creator: Musician(), id: "aaaaaaaaaaaaa"),
            Song(name: "Watermelon Man", instruments: [SongMusician()], creator: Musician(), id: "aasfasasfasf")]),
            bandID: "333333333", id: "4444444444", eventType: EventTypes.Rehearsal)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func getEvent(newEvent: Event) {
            events.append(newEvent)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.roadmapTableView.dataSource = self
        self.roadmapTableView.delegate = self
        
        if let index = self.roadmapTableView.indexPathForSelectedRow{
            self.roadmapTableView.deselectRow(at: index, animated: true)
        }
        
        roadmapTableView.reloadData()
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
            eventCell.setlist.text = events[indexPath.row].associatedSetlist?.name
            eventCell.setlist.textColor = UIColor.white
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
        let sb = UIStoryboard(name: "NewEvent", bundle: Bundle.main)
        
        let vc = sb.instantiateViewController(withIdentifier: "NewEventViewController") as! NewEventViewController
        
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
}
