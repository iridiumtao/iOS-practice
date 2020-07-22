//
//  ShowUserDetailTableViewCell.swift
//  iOS_practice_integrated
//
//  Created by 歐東 on 2020/7/22.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class ShowUserDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
