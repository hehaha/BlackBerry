//
//  LoginViewController.swift
//  Blackberry
//
//  Created by 何鑫 on 16/6/4.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var iPTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "能耗管理系统"
        let user = User.shareInstance
        iPTextField.text = user.ip
        portTextField.text = user.port
        userTextField.text = user.userName
        passwordTextField.text = user.password
    }
    
    @IBAction func didClickScreen(sender: UITapGestureRecognizer) {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }

    @IBAction func loginButtonDidClicked(sender: UIButton) {
        guard let ip = iPTextField.text where ip.characters.count > 0 else {
            let alertView = UIAlertView(title: "错误", message: "iP还未填写！", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        guard let port = portTextField.text where port.characters.count > 0 else {
            let alertView = UIAlertView(title: "错误", message: "端口还未填写！", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        guard let userName = userTextField.text where userName.characters.count > 0 else {
            let alertView = UIAlertView(title: "错误", message: "用户名还未填写！", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        guard let password = passwordTextField.text where password.characters.count > 0 else {
            let alertView = UIAlertView(title: "错误", message: "密码还未填写！", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        let user = User.shareInstance
        user.ip = ip
        user.password = password
        user.userName = userName
        user.port = port
        user.userID = 171
        user.save()

        let url = "http://\(ip):\(port)/DataCenter2/userlogin.action"
        Alamofire.request(.GET, url, parameters: ["username": userName, "password": password]).responseJSON { [weak self] response in
            switch response.result {
            case .Success:
                if let JSON = response.result.value as? [String: AnyObject] {
                    if let success = JSON["success"] as? Bool, let message = JSON["msg"] as? String {
                        if success {
                            let newVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(String(RoomListViewController)) as! RoomListViewController
                            self?.navigationController?.pushViewController(newVC, animated: true)
                        }
                        else {
                            let alertView = UIAlertView(title: "错误", message: message, delegate: nil, cancelButtonTitle: "确定")
                            alertView.show()
                        }
                    }
                }
            case .Failure:
                let alertView = UIAlertView(title: "错误", message: "网络状况不好，请稍后再试!", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
        }
    }
    
    @IBAction func cancelButtonDidClicked(sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
