//
//  DatePickerCell.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import UIKit

final class DatePickerCell: UITableViewCell, ReusableView {

  
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    var onDateChanged: ((Date) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        onDateChanged?(sender.date)
    }
    
    func configure(withTitle title: String, date: Date, dateChanged: @escaping (Date) -> Void) {
            titleLabel.text = title
            datePicker.date = date
            onDateChanged = dateChanged
        }
    
}
