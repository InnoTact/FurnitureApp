//
//  BuildningViewCell.swift
//  FurnitureApp
//
//  Created by Carl Claesson on 2018-11-11.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import UIKit

class BuildingViewCell: UITableViewCell {

    @IBOutlet weak var BuildingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(building: String) {
        BuildingImage.image = UIImage(named: building)
    }

}
