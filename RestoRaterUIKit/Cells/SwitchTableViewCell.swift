//
//  SwitchTableViewCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/31/23.
//

import UIKit

final class SwitchTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    var switchValueChanged: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        switchValueChanged?(sender.isOn)
    }
    
    func configure(title: String, description: String, isOn: Bool, switchValueChanged: ((Bool) -> Void)?) {
          self.titleLabel.text = title
          self.descriptionLabel.text = description
          self.switchView.isOn = isOn
          self.switchValueChanged = switchValueChanged
      }
    
}
