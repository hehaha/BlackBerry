//
//  User.swift
//  Blackberry
//
//  Created by 何鑫 on 16/6/5.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit

class User {
    var ip: String
    var port: String
    var userName: String
    var password: String
    var userID: Int
    
    static let shareInstance = User()
    
    static private let storageKey = "BlackBerryUser"
    
    private init() {
        guard let userDict = NSUserDefaults.standardUserDefaults().dictionaryForKey(User.storageKey) else {
            ip = ""
            port = ""
            userName = ""
            password = ""
            userID = 0
            return
        }
        
        guard let ip = userDict["ip"] as? String, port = userDict["port"] as? String, userName = userDict["userName"] as? String, password = userDict["password"] as? String, userID = userDict["userID"] as? Int else {
            self.ip = ""
            self.port = ""
            self.userName = ""
            self.password = ""
            self.userID = 0
            return
        }
        self.ip = ip
        self.password = password
        self.userID = userID
        self.port = port
        self.userName = userName
     }
    
    func save() {
        let userDict = ["ip": ip, "port": port, "userName": userName, "password": password, "userID": userID]
        NSUserDefaults.standardUserDefaults().setValue(userDict, forKey: User.storageKey)
    }
}