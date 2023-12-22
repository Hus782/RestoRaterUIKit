//
//  SecondaryButtonCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

class SecondaryButtonCell: UITableViewCell, ReusableView {

    @IBOutlet weak var button: UIButton!
    var buttonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withTitle title: String, action: @escaping () -> Void) {
        button.setTitle(title, for: .normal)
        self.buttonAction = action
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        buttonAction?()
    }
}
