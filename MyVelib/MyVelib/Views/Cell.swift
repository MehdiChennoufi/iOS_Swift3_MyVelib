//
//  Cell.swift
//  MyVelib
//
//  Created by etudiant-06 on 30/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var bikesNumberLabel: UILabel!
    @IBOutlet weak var bikeStandsNumberLabel: UILabel!
    @IBOutlet weak var distanceNumberLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    
    var station: Station!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
