//
//  RoomDetailViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/5.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import SnapKit

class RoomDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let __room: RoomModel
    private let __cellIdentifier = "Cell"
    private let __cabinetCellIdentifier = "CabinetCell"
    private lazy var __tableView = UITableView()
    private var __cabinets: [[CabinetModel]] = [] {
        didSet {
            __tableView.reloadData()
        }
    }
    private var __selectedSection: Int?
    
    init(room: RoomModel) {
        __room = room
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = __room.name
        
        __tableView.delegate = self
        __tableView.dataSource = self
        __tableView.separatorStyle = .SingleLine
        __tableView.tableFooterView = UIView()
        __tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: __cellIdentifier)
        __tableView.registerClass(CabinetCell.self, forCellReuseIdentifier: __cabinetCellIdentifier)
        view.addSubview(__tableView)
        __tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        p_fetchData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (__selectedSection == nil || section != __selectedSection) ? 1 : (__cabinets[__selectedSection!].count + 1)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return __cabinets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(__cabinetCellIdentifier) as! CabinetCell
            cell.cabinet = __cabinets[indexPath.section][indexPath.row - 1]
            switch indexPath.row {
            case let value where value == 1 && value == __cabinets[indexPath.section].count:
                cell.topBorderView.hidden = false
                cell.bottomBorderView.hidden = false
            case let value where value == 1 && value != __cabinets[indexPath.section].count:
                cell.topBorderView.hidden = false
                cell.bottomBorderView.hidden = true
            case let value where value == __cabinets[indexPath.section].count:
                cell.topBorderView.hidden = true
                cell.bottomBorderView.hidden = false
            default:
                cell.topBorderView.hidden = true
                cell.bottomBorderView.hidden = true
            }
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(__cellIdentifier)!
            let model = __cabinets[indexPath.section].first
            if let row = model?.row {
                cell.textLabel?.text = "行\(row)"
            }
            else {
                cell.textLabel?.text = "行错误"
            }
            cell.accessoryType = .DetailButton
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        if let cabinetCell = cell as? CabinetCell {
            let newVC = CabinetDetailViewController(cabinet: cabinetCell.cabinet!)
            navigationController?.pushViewController(newVC, animated: true)
        }
        else {
            switch __selectedSection {
            case .Some(let selected) where selected == indexPath.section:
                var deleteIndexPaths: [NSIndexPath] = []
                for i in 1...__cabinets[selected].count {
                    deleteIndexPaths.append(NSIndexPath(forRow: i, inSection: selected))
                }
                __selectedSection = nil
                __tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Top)
            case .Some(let selected) where selected != indexPath.section:
                var deleteIndexPaths: [NSIndexPath] = []
                var insertIndexPaths: [NSIndexPath] = []
                for i in 1...__cabinets[selected].count {
                    deleteIndexPaths.append(NSIndexPath(forRow: i, inSection: selected))
                }
                for i in 1...__cabinets[indexPath.section].count {
                    insertIndexPaths.append(NSIndexPath(forRow: i, inSection: indexPath.section))
                }
                __selectedSection = indexPath.section
                __tableView.beginUpdates()
                __tableView.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Top)
                __tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Top)
                __tableView.endUpdates()
            default:
                __selectedSection = indexPath.section
                var insertIndexPaths: [NSIndexPath] = []
                for i in 1...__cabinets[indexPath.section].count {
                    insertIndexPaths.append(NSIndexPath(forRow: i, inSection: indexPath.section))
                }
                __tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .Top)

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func p_fetchData() {
        var count = 20
        var modelMap: [Int: [CabinetModel]] = [ : ]
        while count > 0 {
            let row = random() % 10
            let col = random() % 10
            let cadId = random()
            var rowCabinets = modelMap[row]
            if rowCabinets == nil {
                rowCabinets = []
            }
            let model = CabinetModel(cabId: cadId, row: row, col: col)
            rowCabinets?.append(model)
            modelMap[row] = rowCabinets
            count -= 1
        }
        __cabinets = modelMap.map{ ($0.0, $0.1.sort{ $0.col < $1.col }) }.sort{ $0.0 < $1.0 }.map{ $0.1 }
        __tableView.reloadData()
    }
    
}
