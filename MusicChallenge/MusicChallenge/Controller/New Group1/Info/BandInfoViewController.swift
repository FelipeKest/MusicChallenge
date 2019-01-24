//
//  BandInfoViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//ViewController da tela que mostra info sobre a banda e integrantes

import UIKit

class BandInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
