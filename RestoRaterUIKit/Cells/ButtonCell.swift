//
//  ButtonCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit

final class ButtonCell: UITableViewCell, ReusableView {

    @IBOutlet weak var buttonView: UIButton!
    private var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(withTitle title: String, action: @escaping () -> Void) {
        buttonView.setTitle(title, for: .normal)
        self.buttonAction = action
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        buttonAction?()
    }
}
