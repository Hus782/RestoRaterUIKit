//
//  RatingPickerCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

final class RatingPickerCell: UITableViewCell, ReusableView {
    
    @IBOutlet var stars: [UIButton]!
    private var ratingChanged: ((Int) -> Void)?
    private let onColor = Constants.activeStarColor
    private let offColor = Constants.inactiveStarColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        updateRating(sender.tag)
        ratingChanged?(sender.tag)
    }
    
    func updateRating(_ rating: Int) {
        for (index, button) in stars.enumerated() {
            button.tintColor = index < rating ? onColor : offColor
        }
    }
    
    func configure(withRating rating: Int, ratingChanged: @escaping (Int) -> Void) {
        self.ratingChanged = ratingChanged
        updateRating(rating)
    }
    
}
