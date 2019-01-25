//
//  MembersTableViewCell.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 24/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import UIKit

class MembersTableViewCell: UITableViewCell {

    @IBOutlet var memberName: UILabel!
    @IBOutlet var memberImage: UIImageView!
    
    @IBOutlet var memberInst1: UIImageView!
    @IBOutlet var memberInst2: UIImageView!
    @IBOutlet var memberInst3: UIImageView!
    
    @IBOutlet var memberOtherInst: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
