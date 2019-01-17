//
//  InstrumentsTableViewCell.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class InstrumentsTableViewCell: UITableViewCell {

    @IBOutlet var instrumentImage: UIImageView!
    @IBOutlet var instrumentName: UILabel!
    @IBOutlet var musicianImage: UIImageView!
    @IBOutlet var musicianName: UILabel!
    
    static let identifier = "instrumentsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
