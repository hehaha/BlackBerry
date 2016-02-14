//
//  ViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/2/9.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request(.GET, "http://localhost:8000/v4/feature").responseJSON { result -> Void in
            print(result.result.value)
        }
        let bigView = UIView()
        bigView.backgroundColor = UIColor.redColor()
        view.addSubview(bigView)3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

