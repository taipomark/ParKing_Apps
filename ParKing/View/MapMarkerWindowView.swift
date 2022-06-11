//
//  MapMarkerWindowView.swift
//  ParKing
//
//  Created by Mark Lai on 10/5/2022.
//

import UIKit

protocol MapMarkerDelegate: AnyObject {
    func didTapInfoButton(data: NSDictionary)
}

class MapMarkerWindow: UIView {

    @IBOutlet weak var ParkingName: UILabel!
    @IBOutlet weak var ParkingSpace: UILabel!
    @IBOutlet weak var ParkingVancancy: UILabel!
    @IBOutlet weak var ParkingAddress: UILabel!
    @IBOutlet weak var ParkingLabel: UILabel!
    
    weak var delegate: MapMarkerDelegate?
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
