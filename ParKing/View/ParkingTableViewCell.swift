//
//  ParkingTableViewCell.swift
//  ParKing
//
//  Created by Mark Lai on 5/5/2022.
//

import UIKit

class ParkingTableViewCell: UITableViewCell {
    
    @IBOutlet var ParkingName: UILabel!
    @IBOutlet var ParkingAddress: UILabel!
    @IBOutlet var ParkingDistrict: UILabel!
    @IBOutlet var ParkingVancancy: UILabel!
    @IBOutlet var ParkingVancancyImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
