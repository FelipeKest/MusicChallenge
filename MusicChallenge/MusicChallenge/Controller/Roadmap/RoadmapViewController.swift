//
//  RoadmapViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela de Roadmap, onde estão os eventos da banda

import UIKit


class RoadmapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,  NewEventProtocol {
    
    
    @IBOutlet var roadmapTableView: UITableView!
    //@IBOutlet var searchBar: UISearchBar!
    //@IBOutlet var monthSelector: ? (descobrir o tipo disso)
    
    @IBOutlet var noEventLabel1: UILabel!
    @IBOutlet var noEventLabel2: UILabel!
    
    var refreshControl: UIRefreshControl?
    
    var events: [Event] = [
        Event(name: "Festival de Rock", place: "Avenida Real Edinburgo", date: String("10/10/2020").toDate(dateFormat: "dd-MM-yyyy"), bandID: "asghhhhhhhh", id: "sfdfasfasfasfas", eventType: EventTypes.Show),
        
        Event(name: "Jam Soul", place: "Casa da Gleidi", date: String("11/05/2019").toDate(dateFormat: "dd-MM-yyyy"), setlist: Setlist(name: "Jazz Em'Up", songs: [
            Song(name: "Hit The Road, Jack", instruments: [SongMusician()], creator: Musician(), id: "aaaaaaaaaaaaa"),
            Song(name: "Watermelon Man", instruments: [SongMusician()], creator: Musician(), id: "aasfasasfasf")]),
            bandID: "333333333", id: "4444444444", eventType: EventTypes.Rehearsal),
        
        Event(name: "Jam Livre", place: "Casa do Joe", date: String("11/04/2019").toDate(dateFormat: "dd-MM-yyyy"), setlist: Setlist(name: "Jazz Em'Up", songs: [
            Song(name: "Hit The Road, Jack", instruments: [SongMusician()], creator: Musician(), id: "aaaaaaaaaaaaa"),
            Song(name: "Watermelon Man", instruments: [SongMusician()], creator: Musician(), id: "aasfasasfasf")]),
              bandID: "333333333", id: "4444444444", eventType: EventTypes.Rehearsal)
    ]
    
    var sortedEvents: [Event] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    
    func getEvent(newEvent: Event) {
            events.append(newEvent)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.roadmapTableView.dataSource = self
        self.roadmapTableView.delegate = self
    
        
        if events.count == 0 {
            roadmapTableView.isHidden = true
            noEventLabel1.isHidden = false
            noEventLabel2.isHidden = false
        }
        else {
            roadmapTableView.isHidden = false
            noEventLabel2.isHidden = true
            noEventLabel1.isHidden = true
        }
        
        if let index = self.roadmapTableView.indexPathForSelectedRow{
            self.roadmapTableView.deselectRow(at: index, animated: true)
        }
        
        roadmapTableView.reloadData()
        
        sortedEvents = events.sorted { ( ev1, ev2) -> Bool in
            return ev1.date < ev2.date
        }
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        roadmapTableView.addSubview(refreshControl!)
    }
    
    
    @objc func refreshTable() {
        //songs.append(Song(name: "ATUALIZOU?"))
        sortedEvents = events.sorted { ( ev1, ev2) -> Bool in
            return ev1.date < ev2.date
        }
        roadmapTableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! RoadmapTableViewCell
        
        eventCell.eventName.text = sortedEvents[indexPath.row].name
        eventCell.horario.text = sortedEvents[indexPath.row].date.toString(dateFormat: "dd-MM-yyyy")
        eventCell.location.text = sortedEvents[indexPath.row].location
        eventCell.eventTypeImage.image = sortedEvents[indexPath.row].eventType.image
        
        
        if sortedEvents[indexPath.row].associatedSetlist != nil { //evento tem setlist associada
            eventCell.setlist.text = sortedEvents[indexPath.row].associatedSetlist?.name
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete Pressed")
            let deleteAlert = UIAlertController(title: nil, message: "Deseja realmente excluir \(sortedEvents[indexPath.row].name)?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Excluir", style: .destructive)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEvent" {
            let destination = segue.destination as? EventViewController
            let index = roadmapTableView.indexPathForSelectedRow?.row
            destination?.event = sortedEvents[index!]
        }
    }
    
   
    
    @IBAction func addEvent(_ sender: Any) {
        let sb = UIStoryboard(name: "NewEvent", bundle: Bundle.main)
        
        let vc = sb.instantiateViewController(withIdentifier: "NewEventViewController") as! NewEventViewController
        
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


