//
//  BandInfoViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela que mostra info sobre a banda e integrantes

import UIKit

class BandInfoViewController: UIViewController , UITableViewDataSource, UITabBarDelegate{
    

    @IBOutlet var membersTableView: UITableView!
    
    var band = Band(name: "Developers of Sound", members:[
        
        Musician(name: "Guilherme Vassallo", age: 21, band: Band(), id: "asfakgoakga"),
        Musician(name: "Felipe Kestelmann", age: 19, band: Band(), id: "asfakgoakga"),
        Musician(name: "Lucas Gouveia", age: 22, band: Band(), id: "asfakgoakga")
],
                    
        id: "agjagiadjgiadg")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return band.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let membersCell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! MembersTableViewCell
        
        
        
        return membersCell
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
