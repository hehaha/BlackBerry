//
//  CabinetCell.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/23.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit

class CabinetCell: UITableViewCell {
    
    private let __leftBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(RGBInt: 0xb2b2b2)
        return view
    }()
    
    private let __rightBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(RGBInt: 0xb2b2b2)
        return view

    }()
    
    let topBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(RGBInt: 0xb2b2b2)
        return view
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(RGBInt: 0xb2b2b2)
        return view
    }()
    
    var cabinet: CabinetModel? {
        didSet {
            if let row = cabinet?.cabName {
                textLabel?.text = row
            }
            else {
                textLabel?.text = "未匹配的机柜数据"
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(__leftBorderView)
        self.addSubview(__rightBorderView)
        self.addSubview(topBorderView)
        self.addSubview(bottomBorderView)
        
        __leftBorderView.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(2)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(2)
        }
        
        __rightBorderView.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-2)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(2)
        }
        
        topBorderView.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(2)
            make.left.equalTo(__leftBorderView)
            make.right.equalTo(__rightBorderView)
            make.height.equalTo(2)
        }
        
        bottomBorderView.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-2)
            make.left.equalTo(__leftBorderView)
            make.right.equalTo(__rightBorderView)
            make.height.equalTo(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
