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
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(date: Date, commnent: String, rating: Double, reviewType: ReviewType) {
        self.dateLabel.text = date.formattedDate()
        self.commentLabel.text = commnent
        
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
