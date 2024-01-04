//
//  DetailInfoTableViewCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

final class DetailInfoTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String, content: String, isAdmin: Bool = false) {
        self.titleLabel.text = title
        self.contentLabel.text = content
    }
}
