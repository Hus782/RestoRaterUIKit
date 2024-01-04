//
//  TextFieldCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import UIKit
import TextFieldEffects

final class TextFieldCell: UITableViewCell, ReusableView {
    private var textChanged: ((String, Bool) -> Void)?
    private var validationType: ValidationType = .none
    private var placeHolder: String = ""
    private var validationState: ValidationResult = .success

    @IBOutlet weak var textField: HoshiTextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func textChanged(_ sender: HoshiTextField) {
        guard let text = sender.text else { return }
        
        if text.isEmpty && validationType == .email {
            textField.borderActiveColor = .link
            textField.borderInactiveColor = .gray
            textField.placeholder = placeHolder
            textChanged?(text, false)
            return
        }
        let validationResult = ValidationService.validate(text: text, for: validationType)

        textChanged?(text, validationResult == .success)
          // Update UI only if there is a change in validation state
          if validationResult != validationState {
              updateUIForValidationResult(validationResult, textField: sender)
          }
        
    }
    
    func configure(title: String, content: String, validationType: ValidationType = .none, isSecureField: Bool = false, textChanged: ((String, Bool) -> Void)?) {
        self.placeHolder = title
        self.textField.text = content
        self.textField.placeholder = title
        self.textChanged = textChanged
        self.validationType = validationType
        self.textField.isSecureTextEntry = isSecureField
    }

    private func updateUIForValidationResult(_ result: ValidationResult, textField: HoshiTextField) {
        switch result {
        case .success:
            resetToDefaultState(textField)
            validationState = .success
        case .failure(let message):
            if case .failure = validationState {
                // If error message changed, update placeholder
                textField.placeholder = message
            } else {
                // Change to invalid state and update UI
                textField.borderActiveColor = .red
                textField.borderInactiveColor = .red
                textField.placeholder = message
            }
            validationState = .failure(message)
        }
    }

    private func resetToDefaultState(_ textField: HoshiTextField) {
        textField.borderActiveColor = .link
        textField.borderInactiveColor = .gray
        textField.placeholder = placeHolder
    }
    
}
