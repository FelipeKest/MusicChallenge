//
//  ViewController.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var vwView: UIView!
    
    @IBOutlet weak var scSegment: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func scSegmentedTapped(_ sender: Any) {
        
        let getIndex = scSegment.selectedSegmentIndex
        print (getIndex)
        
        switch (getIndex) {
        case 0:
            self.vwView.backgroundColor = UIColor.green
        case 1:
            self.vwView.backgroundColor = UIColor.blue
        default:
            print("no select")
        }
    }
    
    


}

