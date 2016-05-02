//
//  DateCell.swift
//  Blackberry
//
//  Created by 何鑫 on 16/5/2.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import SnapKit

class DateCell: UICollectionViewCell {
    private let __dayLabel = UILabel()
    
    var content: String? {
        get {
            return __dayLabel.text
        }
        
        set {
            __dayLabel.text = newValue ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(__dayLabel)
        __dayLabel.snp_makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
