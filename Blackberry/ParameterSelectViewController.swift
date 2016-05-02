//
//  ParameterSelectViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/30.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit

private let __parameterList: [CabinetParameter] = [.averagePower, .averageElectricity, .serviceTemperature, .electricityOne, .electricityTwo, .voltageOne, .voltageTwo, .blowerOne, .blowerTwo, .blowerThree, .blowerFour]

private let __cellIdentifier = "cell"

class ParameterSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var __selectedDateComponents: NSDateComponents? {
        didSet {
            if let components = __selectedDateComponents {
                dateLabel.text = "\(components.year)年\(components.month)月\(components.day)日"
            }
        }
    }
    private var __selectedParameter: CabinetParameter?
    var cabinet: CabinetModel?
    
    @IBOutlet weak var dateSelectView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(dateSelectDidTapped))
        dateSelectView.addGestureRecognizer(tapGesture)
        tableView.layer.borderWidth = 2
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderColor = UIColor(RGBInt: 0xb2b2b2).CGColor
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: __cellIdentifier)
        
        navigationItem.title = "环境参数"

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let frame = tableView.frame
        let cellHeight = CGFloat(Int(frame.height / CGFloat(__parameterList.count)))
        tableView.rowHeight = cellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return __parameterList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(__cellIdentifier)!
        let parameter = __parameterList[indexPath.row]
        cell.textLabel?.text = parameter.rawValue
        parameter == __selectedParameter ? (cell.accessoryType = .Checkmark) : (cell.accessoryType = .None)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        __selectedParameter = __parameterList[indexPath.row]
        tableView.reloadData()
    }
    
    func dateSelectDidTapped(tapGesture: UITapGestureRecognizer) {
        let newVC = DateSelectViewController(date: __selectedDateComponents)
        newVC.dateDidSeletedAction = { [weak self] (dateComponents: NSDateComponents) in
            self?.__selectedDateComponents = dateComponents
        }
        self.navigationController?.pushViewController(newVC, animated: true)
    }

    @IBAction func submitButtonDidClicked(sender: UIButton) {
        guard let cabinet = self.cabinet else {
            return
        }

        let alertView: UIAlertView
        guard let parameter = __selectedParameter else {
            alertView = UIAlertView(title: "错误", message: "尚未选择参数", delegate: self, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        guard let components = __selectedDateComponents else {
            alertView = UIAlertView(title: "错误", message: "尚未选择时间", delegate: self, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        let newVC = ParameterGraphViewController(cabinet: cabinet, parameter: parameter, dateComponent: components)
        navigationController?.pushViewController(newVC, animated: true)
    }
}
