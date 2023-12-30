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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String, content: String, isAdmin: Bool = false) {
        self.titleLabel.text = title
        self.contentLabel.text = content
    }
    
}
