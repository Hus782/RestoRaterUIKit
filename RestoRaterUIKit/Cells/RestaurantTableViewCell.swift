//
//  RestaurantTableViewCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import UIKit

final class RestaurantTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(image: UIImage, name: String, address: String) {
        self.ImageView.image = image
        self.nameLabel.text = name
        self.addressLabel.text = address
        
    }
    
}
