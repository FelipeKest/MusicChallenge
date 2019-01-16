//
//  RepertoireTableViewCell.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

//Célula da tableView do repertório

import UIKit

class RepertoireTableViewCell: UITableViewCell {
    
    @IBOutlet var songName: UILabel!
    
    @IBOutlet var instrument0: UIImageView!
    @IBOutlet var instrument1: UIImageView!
    @IBOutlet var instrument2: UIImageView!
    @IBOutlet var instrument3: UIImageView!
    
    @IBOutlet var additionalInstruments: UILabel!
    
    static let identifier = "repertoireCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
