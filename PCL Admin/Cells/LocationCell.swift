//
//  LocationCell.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/31/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var accNo: UILabel!
    @IBOutlet var seqNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCell(_ location: Location) {
        self.name.text = location.CustomerName
        self.address.text = location.StreetAddress
        //self.accNo.text = String(location.CustomerId)
//        self.seqNo.text = self.i
    }
}
