//
//  ParameterGraphViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/5/2.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import Alamofire

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
        guard let cabId = __cabinet.cabId else {
            return
        }
        let user = User.shareInstance
        let dateString = String(format: "%d-%02d-%02d", __dateComponent.year, __dateComponent.month, __dateComponent.day)
        Alamofire.request(.GET, "http:/\(user.ip):\(user.port)/DataCenter2/serverdatartime.action", parameters: ["cabId": cabId, "num": __parameter.value(), "date": dateString]).responseJSON {
            [weak self] response in
            guard let result = response.result.value as? [String: AnyObject] else {
                return
            }
            guard let times = result["time"] as? [String], datas = result["verticaldata"] as? [CGFloat] else {
                return
            }
            var points: [(CGFloat, String)] = []
            for (index, data) in datas.enumerate() {
                points.append((data, times[index]))
            }
            self?.__parametetGraphView.points = points
        }
    }
}
