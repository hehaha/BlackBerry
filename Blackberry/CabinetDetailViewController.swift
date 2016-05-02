//
//  CabinetDetailViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/24.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import ObjectMapper

class CabinetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var __cabinet: CabinetModel
    private let __cellIdentifier = "Cell"
    private let __tempCellIdentifier = "TempCell"
    private let __powerCellIdentifier = "PowerCell"

    private lazy var __tableView = UITableView()
    
    init(cabinet: CabinetModel) {
        __cabinet = cabinet
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "机房-机柜\(__cabinet.row)-\(__cabinet.col)"
        
        __tableView.delegate = self
        __tableView.dataSource = self
        __tableView.separatorStyle = .None
        __tableView.tableFooterView = UIView()
        __tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: __cellIdentifier)
        __tableView.registerClass(CabinetTempCell.self, forCellReuseIdentifier: __tempCellIdentifier)
        __tableView.registerClass(CabinetPowerCell.self, forCellReuseIdentifier: __powerCellIdentifier)
        view.addSubview(__tableView)
        __tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        p_fetchData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return __cabinet.temperatureArray.count + 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.row < __cabinet.temperatureArray.count {
            cell = tableView.dequeueReusableCellWithIdentifier(__tempCellIdentifier)!
            cell.selectionStyle = .None
            let tempCell = cell as! CabinetTempCell
            tempCell.tempInfo = __cabinet.temperatureArray[indexPath.row]
            switch indexPath.row {
            case let value where value == 0 && value == __cabinet.temperatureArray.count - 1:
                tempCell.topBorderView.hidden = false
                tempCell.bottomBorderView.hidden = false
            case let value where value == 0 && value != __cabinet.temperatureArray.count - 1:
                tempCell.topBorderView.hidden = false
                tempCell.bottomBorderView.hidden = true
            case let value where value == __cabinet.temperatureArray.count - 1:
                tempCell.topBorderView.hidden = true
                tempCell.bottomBorderView.hidden = false
            default:
                tempCell.topBorderView.hidden = true
                tempCell.bottomBorderView.hidden = true
            }
        }
        else if indexPath.row == __cabinet.temperatureArray.count {
            cell = tableView.dequeueReusableCellWithIdentifier(__powerCellIdentifier)!
            let powerCell = cell as! CabinetPowerCell
            powerCell.textLabel?.text = "机柜总功率"
            powerCell.accessoryType = .DisclosureIndicator
            if let totalPower = __cabinet.totalPower {
                powerCell.tailLable.text = "\(totalPower)kw"
            }
            else {
                powerCell.tailLable.text = "0kw"
            }
            
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(__cellIdentifier)!
            cell.textLabel?.text = "环境参数列图"
            cell.accessoryType = .DisclosureIndicator
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        if indexPath.row == __cabinet.temperatureArray.count + 1 {
            let newVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(String(ParameterSelectViewController)) as! ParameterSelectViewController
            newVC.cabinet = __cabinet
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    private func p_fetchData() {
        var temperatureArray: [(String, Int)] = []
        for i in 1...3 {
            temperatureArray.append(("前面板温度\(i)", i * 5))
        }
        for i in 1...3 {
            temperatureArray.append(("后面板温度\(i)", i * 5))
        }
        let total: Double = 0.08
        __cabinet = CabinetModel(cabId: __cabinet.cabId ?? 0, row: __cabinet.row, col: __cabinet.col, tempArray: temperatureArray, totalPower: total)
        
    }
}
