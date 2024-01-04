//
//  RestaurantHeaderCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

final class RestaurantHeaderCell: UITableViewCell, ReusableView {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(name: String, address: String, imageData: Data) {
        self.nameLabel.text = name
        self.addressLabel.text = address
        self.restaurantImageView.image = UIImage(data: imageData)
    }
    
}
