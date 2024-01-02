//
//  ReviewCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

final class ReviewCell: UITableViewCell, ReusableView {
    
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialStarAppearance()
    }
    
    private func setupInitialStarAppearance() {
        for imageView in stars {
            imageView.image = UIImage(systemName: "star.fill")
            imageView.tintColor = StarRatingUtility.inactiveStarColor
        }
    }
    
    func configure(date: Date, comment: String, rating: Double, reviewType: ReviewType) {
        self.dateLabel.text = date.formattedDate()
        self.commentLabel.text = comment
        
        switch reviewType {
        case .latest:
            titleLabel.text = Lingo.reviewSectionLatestReview
        case .highestRated:
            titleLabel.text = Lingo.reviewSectionHighestRatedReview
        case .lowestRated:
            titleLabel.text = Lingo.reviewSectionLowestRatedReview
        default:
            titleLabel.isHidden = true
        }
        
        for index in 0..<stars.count {
            stars[index].image = StarRatingUtility.imageForRating(rating, at: index)
            stars[index].tintColor = StarRatingUtility.colorForStar(at: index, rating: rating)
        }
    }
}
