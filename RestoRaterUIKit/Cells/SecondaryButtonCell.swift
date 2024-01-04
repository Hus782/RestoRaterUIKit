//
//  SecondaryButtonCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

final class SecondaryButtonCell: UITableViewCell, ReusableView {

    @IBOutlet weak var button: UIButton!
    private var buttonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withTitle title: String, action: @escaping () -> Void) {
        button.setTitle(title, for: .normal)
        self.buttonAction = action
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        buttonAction?()
    }
}
