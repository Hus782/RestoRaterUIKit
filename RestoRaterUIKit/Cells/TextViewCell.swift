//
//  TextViewCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/2/24.
//

import UIKit

final class TextViewCell: UITableViewCell, ReusableView {
    var textChanged: ((String) -> Void)?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String, content: String, textChangedCompletion: @escaping (String) -> Void) {
        titleLabel.text = title
        textView.text = content
        textChanged = textChangedCompletion
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
}
