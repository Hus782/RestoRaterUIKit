//
//  UserTableViewCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/30/23.
//

import UIKit

final class UserTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(name: String, email: String, isAdmin: Bool) {
        self.nameLabel.text = name
        self.emailLabel.text = email
        self.roleLabel.isHidden = !isAdmin
    
    }
}
