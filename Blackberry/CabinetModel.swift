//
//  File.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/5.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import ObjectMapper

struct CabinetModel: Mappable {
    var cabName: String?
    var cabId: Int?
    var temperatureArray: [(String, Float)] = []
    var totalPower: Double?
    
    init?(_ map: Map) {
    }
    
    mutating func mapping(map: Map) {
        cabName <- map["text"]
        cabId <- map["id"]
//        row <- map["row"]
//        col <- map["col"]
//        temperatureArray <- map["temp"]
//        totalPower <- map["total"]
    }
}