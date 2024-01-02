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
    private let activeStarColor = UIColor.yellow  // Color for active (rated) stars
    private let inactiveStarColor = UIColor.gray  // Color for inactive stars
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupInitialStarAppearance()
    }
    
    private func setupInitialStarAppearance() {
        for imageView in stars {
            imageView.image = UIImage(systemName: "star.fill") // All stars are filled
            imageView.tintColor = inactiveStarColor
        }
    }
    
    func configure(withRating rating: Double) {
        ratingLabel.text = Lingo.restaurantDetailAverageRating + String(format: "%.2f", rating)
        for index in 0..<stars.count {
            stars[index].image = StarRatingUtility.imageForRating(rating, at: index)
            stars[index].tintColor = StarRatingUtility.colorForStar(at: index, rating: rating)
        }
    }
}
