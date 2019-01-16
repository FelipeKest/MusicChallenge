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
    
    @IBAction func displayActivity(_ sender: Any) {
        let textToShare = [SessionManager.currentUser?.band?.id]
        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [.openInIBooks, .addToReadingList, .postToFacebook, .postToWeibo, .postToFlickr, .postToVimeo, .postToTencentWeibo, .postToTwitter, .saveToCameraRoll, .markupAsPDF ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
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
