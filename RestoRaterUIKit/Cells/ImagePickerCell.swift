//
//  ImagePickerCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

final class ImagePickerCell: UITableViewCell, ReusableView {

    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    var pickImageAction: (() -> Void)?

  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func pickImageTapped(_ sender: UIButton) {
        pickImageAction?()
    }
}
