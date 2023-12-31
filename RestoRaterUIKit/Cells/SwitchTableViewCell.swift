//
//  SwitchTableViewCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/31/23.
//

import UIKit

class SwitchTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String, description: String, isOn: Bool) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.switchView.isOn = isOn
    }
    
}
