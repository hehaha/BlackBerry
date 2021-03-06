//
//  ViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/2/9.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class RoomListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var __roomModels :[RoomModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let __cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "机房列表"
        navigationItem.hidesBackButton = true
        automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        p_fetchData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: __cellIdentifier)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return __roomModels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(__cellIdentifier)!
        let model = __roomModels[indexPath.row]
        cell.textLabel?.text = model.name
        cell.accessoryType = .DisclosureIndicator
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        selectedCell?.setSelected(false, animated: true)
        let room = __roomModels[indexPath.row]
        let detailVc = RoomDetailViewController(room: room)
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    
    private func p_fetchData() {
        let user = User.shareInstance
        Alamofire.request(.GET, "http://\(user.ip):\(user.port)/DataCenter2/showcabroom.action", parameters: ["userid": user.userID]).responseJSON { [weak self] response in
            guard let rooms = Mapper<RoomModel>().mapArray(response.result.value) else {
                self?.__roomModels = []
                return
            }
            self?.__roomModels = rooms
        }
    }

}

