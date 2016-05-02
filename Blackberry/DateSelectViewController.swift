//
//  DateSelectViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/5/1.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import SnapKit

private let forwardButtonTag = "forwardButton".hash
private let backwardButtonTag = "backwardButton".hash
private let cellIdentifier = "cell"

class DateSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var dateDidSeletedAction: ((date: NSDateComponents) -> ())?
    
    private let __collectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        return collectionView
    }()
    private let __monthLabel = UILabel()
    private var __selectDateComponent: NSDateComponents
    private var __currentMonth: (Int, Int) {
        didSet {
            __monthLabel.text = String(format: "%d%02d", __currentMonth.0, __currentMonth.1)
            if oldValue.0 != __currentMonth.0 || oldValue.1 != __currentMonth.1 {
                p_fetchData()
            }
        }
    }
    private var __dataSource: [String?] = []

    
    init(date selectedDate: NSDateComponents?) {
        if let dateComponent = selectedDate {
            __selectDateComponent = dateComponent
        }
        else {
            let calendar = NSCalendar.currentCalendar()
            let date = NSDate()
            __selectDateComponent = calendar.components([.Year, .Month, .Day], fromDate: date)
        }
        __currentMonth = (__selectDateComponent.year, __selectDateComponent.month)
        __monthLabel.text = String(format: "%d%02d", __selectDateComponent.year, __selectDateComponent.month)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "选择日期"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: .Plain, target: self, action: #selector(comfirmSelected))
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(__monthLabel)
        __monthLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(80)
        }
        
        let backwardButton = UIButton()
        backwardButton.tag = backwardButtonTag
        backwardButton.addTarget(self, action: #selector(changeDateButtonDidClick), forControlEvents: .TouchUpInside)
        backwardButton.setTitle("上个月", forState: .Normal)
        backwardButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        backwardButton.backgroundColor = UIColor(RGBInt: 0x008000)
        backwardButton.layer.cornerRadius = 5
        view.addSubview(backwardButton)
        backwardButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(__monthLabel)
            make.height.equalTo(__monthLabel)
            make.right.equalTo(__monthLabel.snp_left).offset(-12)
        }
        
        let forwardButton = UIButton()
        forwardButton.tag = forwardButtonTag
        forwardButton.addTarget(self, action: #selector(changeDateButtonDidClick), forControlEvents: .TouchUpInside)
        forwardButton.setTitle("下个月", forState: .Normal)
        forwardButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        forwardButton.backgroundColor = UIColor(RGBInt: 0x008000)
        forwardButton.layer.cornerRadius = 5;
        view.addSubview(forwardButton)
        forwardButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(__monthLabel)
            make.height.equalTo(__monthLabel)
            make.left.equalTo(__monthLabel.snp_right).offset(12)
        }
        
        __collectionView.delegate = self
        __collectionView.dataSource = self
        __collectionView.layer.borderWidth = 2
        __collectionView.layer.borderColor = UIColor(RGBInt: 0xb2b2b2).CGColor
        __collectionView.registerClass(DateCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(__collectionView)
        __collectionView.snp_makeConstraints { (make) in
            make.top.equalTo(__monthLabel.snp_bottom).offset(15)
            make.left.equalTo(view).offset(11)
            make.right.equalTo(view).offset(-11)
            make.bottom.equalTo(view).offset(-2)
        }
        
        p_fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let frame = __collectionView.frame
        let itemWidth = CGFloat(Int(frame.width / 7))
        let itemHeight = CGFloat(Int(frame.height / 7))
        let layout = __collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(itemWidth, itemHeight)
        __collectionView.setNeedsLayout()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! DateCell
        let content = __dataSource[indexPath.row]
        cell.content = content
        cell.backgroundColor = UIColor.whiteColor()
        guard let day = content, currentDay = Int(day) else {
            return cell
        }
        if __selectDateComponent.year == __currentMonth.0 && __selectDateComponent.month == __currentMonth.1 && __selectDateComponent.day == currentDay {
            cell.backgroundColor = UIColor(RGBInt: 0xb2b2b2)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DateCell
        guard let day = cell.content, selectedDay = Int(day) else {
            return
        }
        __selectDateComponent.setValue(__currentMonth.0, forComponent: .Year)
        __selectDateComponent.setValue(__currentMonth.1, forComponent: .Month)
        __selectDateComponent.setValue(selectedDay, forComponent: .Day)
        __collectionView.reloadData()
    }
    
    func changeDateButtonDidClick(button: UIButton) {
        let monthOffset = button.tag == forwardButtonTag ? 1 : -1
        let current = __currentMonth.1
        var newMonth = (current + monthOffset) % 12
        newMonth = newMonth == 0 ? 12 : newMonth
        var newYear = __currentMonth.0
        if monthOffset == 1 && newMonth == 1 {
            newYear += 1
        }
        else if monthOffset == -1 && newMonth == 12 {
            newYear -= 1
        }
        __currentMonth = (newYear, newMonth)
    }
    
    func comfirmSelected() {
        dateDidSeletedAction?(date: __selectDateComponent)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    private func p_fetchData() {
        let year = __currentMonth.0
        let month = __currentMonth.1
        __dataSource = []
        __dataSource.append("日")
        __dataSource.append("一")
        __dataSource.append("二")
        __dataSource.append("三")
        __dataSource.append("四")
        __dataSource.append("五")
        __dataSource.append("六")
        let daysNumber: Int
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            daysNumber = 31
        case 4, 6, 9, 11:
            daysNumber = 30
        case 2 where ((year % 100 != 0) && ( year % 4 == 0)) || (year % 400 == 0):
            daysNumber = 29
        default:
            daysNumber = 28
        }
        
        let component = NSDateComponents()
        component.setValue(year, forComponent: .Year)
        component.setValue(month, forComponent: .Month)
        component.setValue(1, forComponent: .Day)
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateFromComponents(component)
        let weekDay = calendar.component(.Weekday, fromDate: date!)
        for _ in 1..<weekDay {
            __dataSource.append(nil)
        }
        
        for i in 1...daysNumber {
            __dataSource.append("\(i)")
        }
        
        for _ in daysNumber...49 {
            __dataSource.append(nil)
        }
        __collectionView.reloadData()
    }

}
