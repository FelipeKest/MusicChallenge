//
//  BandInfoViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela que mostra info sobre a banda e integrantes

import UIKit

class BandInfoViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var membersLabel: UILabel!
    
    @IBOutlet var membersTableView: UITableView!
    
    var band = Band(name: "Developers of Sound", members:[
        
        Musician(name: "Guilherme Vassallo", age: 21, instruments: [Instrument.Guitar, Instrument.Singer], band: Band(), id: "Agjsdigiwhiwdisg"),
        Musician(name: "Felipe Kestelmann", age: 19, instruments: [Instrument.Bass], band: Band(), id: "asfakgoakga"),
        Musician(name: "Lucas Gouveia", age: 22, instruments: [Instrument.Drums], band: Band(), id: "asfakgoakga")
],
                    
        id: "agjagiadjgiadg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        membersTableView.dataSource = self
        membersTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.membersTableView.indexPathForSelectedRow{
            self.membersTableView.deselectRow(at: index, animated: true)
        }
        
        membersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return band.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let membersCell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! MembersTableViewCell
        
        let member = band.members[indexPath.row]
        var iconArray = [membersCell.memberInst1, membersCell.memberInst2, membersCell.memberInst1]
        
        if (member.instruments?.count)! > 3{
            for i in 1...2 {
                iconArray[i]?.image = member.instruments?[i].image
            }
            membersCell.memberInst1.isHidden = true
            membersCell.memberOtherInst.text = "+\((member.instruments?.count)! - 2)"
        }
        else{
            for i in 0...(member.instruments?.count)!-1 {
                iconArray[i]?.image = member.instruments?[i].image
            }
            
            membersCell.memberOtherInst.text = ""
        }
        
        membersCell.memberName.text = member.name
        
        return membersCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "memberProfile", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func codeSendButton(_ sender: Any) {
        let ac = UIActivityViewController(activityItems: ["Use este código para se juntar a nossa banda no BandPlan: F3G2C456G2V698VV23KS3JG34366GGHK-B"], applicationActivities: [])
        present(ac, animated: true)
    }
    
}
