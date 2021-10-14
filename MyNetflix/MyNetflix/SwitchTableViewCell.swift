//
//  SwitchTableViewCell.swift
//  MyNetflix
//
//  Created by 김지호 on 2021/09/29.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let s = UISwitch(frame: .zero)
        accessoryView = s
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
