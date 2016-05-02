//
//  ParameterGraphViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/5/2.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit

class ParameterGraphViewController: UIViewController {
    
    private let __cabinet: CabinetModel
    private let __parameter: CabinetParameter
    private let __parametetGraphView = ParameterGraphView()
    private let __dateComponent: NSDateComponents
    
    init(cabinet: CabinetModel, parameter: CabinetParameter, dateComponent: NSDateComponents) {
        __cabinet = cabinet
        __parameter = parameter
        __dateComponent = dateComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = __parameter.rawValue
        view.addSubview(__parametetGraphView)
        view.backgroundColor = UIColor.whiteColor()
        
        __parametetGraphView.backgroundColor = UIColor.whiteColor()
        __parametetGraphView.snp_makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(64, 12, 30, 12))
        }
        p_fetchData()
    }

    private func p_fetchData() {
        let datas: [CGFloat] = [12, 16, 28, 19, 14, 32]
        let times: [String] = ["20:00", "20:10", "20: 20", "20:30", "20:40", "20:50", "21:00"]
        var points: [(CGFloat, String)] = []
        for (index, data) in datas.enumerate() {
            points.append((data, times[index]))
        }
        __parametetGraphView.points = points
    }
}
