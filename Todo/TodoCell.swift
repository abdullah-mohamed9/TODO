//
//  TodoCell.swift
//  Todo
//
//  Created by Dragon on 19/05/2023.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var todoCreationDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
