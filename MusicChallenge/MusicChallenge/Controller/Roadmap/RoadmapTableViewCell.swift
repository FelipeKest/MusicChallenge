//
//  RoadmapTableViewCell.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class RoadmapTableViewCell: UITableViewCell {
    
    @IBOutlet var eventName: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var horario: UILabel!
    @IBOutlet var setlist: UILabel!
    @IBOutlet var numberOfSetlistSongs: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
