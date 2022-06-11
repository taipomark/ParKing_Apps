//
//  LatestTableViewCell.swift
//  ParKing
//
//  Created by Mark Lai on 24/4/2022.
//

import UIKit

class LatestTableViewCell: UITableViewCell {
    
    @IBOutlet var AlertName: UILabel!
    @IBOutlet var AlertReported: UILabel!
    @IBOutlet var AlertTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
