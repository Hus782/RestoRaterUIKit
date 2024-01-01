//
//  StarRatingCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

final class StarRatingCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var stars: [UIImageView]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(withRating rating: Double) {
        self.ratingLabel.text = Lingo.restaurantDetailAverageRating +  String(rating)
        for (index, imageView) in stars.enumerated() {
            if rating > Double(index) + 0.5 {
                imageView.image = UIImage(systemName: "star.fill")
            } else if rating > Double(index) {
                imageView.image = UIImage(systemName: "star.leadinghalf.filled")
            } else {
                imageView.image = UIImage(systemName: "star")
            }
        }
    }
    
}
