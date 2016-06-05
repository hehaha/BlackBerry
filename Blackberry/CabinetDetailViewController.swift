//
//  CabinetDetailViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/24.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class CabinetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
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
        navigationItem.title = __cabinet.cabName
        
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
        return __cabinet.temperatureArray.count == 0 ? 0 : __cabinet.temperatureArray.count + 1
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
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(__cellIdentifier)!
            cell.textLabel?.text = "环境参数列表"
            cell.accessoryType = .DisclosureIndicator
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        if indexPath.row == __cabinet.temperatureArray.count {
            let newVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(String(ParameterSelectViewController)) as! ParameterSelectViewController
            newVC.cabinet = __cabinet
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    private func p_fetchData() {
        guard let cabId = __cabinet.cabId else {
            return
        }
        let user = User.shareInstance
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components([.Year, .Month, .Day], fromDate: date)
        let dateString = String(format: "%d-%02d-%02d", dateComponent.year, dateComponent.month, dateComponent.day)
        Alamofire.request(.GET, "http://\(user.ip):\(user.port)/DataCenter2/serverdata.action", parameters: ["cabId": cabId, "date": dateString]).responseJSON { [weak self] response in
            guard let result = response.result.value as? [String: AnyObject] else {
                return
            }
            print(response.result.value)
            var temperatureArray: [(String, Float)] = []
            if let frontTempList = result["front_panel_temp"] as? [Float] {
                for (index, value) in frontTempList.enumerate() {
                    temperatureArray.append(("前面板温度\(index + 1)", value))
                }
            }
            if let backTempList = result["back_panel_temp"] as? [Float] {
                for (index, value) in backTempList.enumerate() {
                    temperatureArray.append(("后面板温度\(index + 1)", value))
                }
            }
            if let powerList = result["cabinet_power"] as? [Float] {
                temperatureArray.append(("机柜总功率", powerList[0]))
                temperatureArray.append(("机柜功率1", powerList[1]))
                temperatureArray.append(("机柜功率2", powerList[2]))
            }
            if temperatureArray.count == 0, let message = result["msg"] as? String {
                let alertView = UIAlertView(title: "错误", message: message, delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                return
            }
            self?.__cabinet.temperatureArray = temperatureArray
            self?.__tableView.reloadData()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        navigationController?.popViewControllerAnimated(true)
    }
}
