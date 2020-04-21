//
//  CustomerListCell.swift
//  PCL Admin
//
//  Created by Rutul Desai on 4/21/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import UIKit

class CustomerListCell: UITableViewCell {
    @IBOutlet weak var PickUpTimeLbl: UILabel!
    @IBOutlet weak var CollectionStatusImage: UIImageView!
    
    @IBOutlet weak var CustomerIDLbl: UILabel!
    @IBOutlet weak var CollectionStatusLbl: UILabel!
    @IBOutlet weak var SpecimensDistanceLbl: UILabel!
    @IBOutlet weak var AddressLbl: UILabel!
    @IBOutlet weak var CustomerNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCell(_ location: Location) {
            self.CustomerNameLbl.text = location.CustomerName
        let address = location.StreetAddress
        self.AddressLbl.text = address
            self.CustomerIDLbl.text = String(location.CustomerId)
    //        self.seqNo.text = self.i
        }
    
    

}