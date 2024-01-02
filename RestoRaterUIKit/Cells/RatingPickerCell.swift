//
//  RatingPickerCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

final class RatingPickerCell: UITableViewCell, ReusableView {
    
    @IBOutlet var stars: [UIButton]!
    var ratingChanged: ((Int) -> Void)?
    private let onColor = UIColor.yellow
    private let offColor = UIColor.gray
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
