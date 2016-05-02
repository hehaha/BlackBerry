//
//  CabinetPowerCell.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/30.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import SnapKit

class CabinetPowerCell: UITableViewCell {
    let tailLable = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tailLable)
        tailLable.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-1)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
