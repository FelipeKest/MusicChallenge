//
//  InstrumentsTableViewCell.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 25/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class InstrumentsTableViewCell: UITableViewCell {

    @IBOutlet var instrumentName: UILabel!
    @IBOutlet var instrumentImage: UIImageView!
    
    static var identifier = "instrumentCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
