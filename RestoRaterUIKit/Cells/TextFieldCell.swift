//
//  TextFieldCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit
import TextFieldEffects

final class TextFieldCell: UITableViewCell, ReusableView {
    var textChanged: ((String) -> Void)?

    @IBOutlet weak var textField: HoshiTextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        textChanged?(sender.text ?? "")
    }
    
    func configure(title: String, content: String, textChanged: ((String) -> Void)?) {
//        self.titleLabel.text = title
        self.textField.text = content
        self.textField.placeholder = title
        self.textChanged = textChanged
    }

}
