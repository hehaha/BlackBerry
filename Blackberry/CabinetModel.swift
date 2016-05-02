//
//  File.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/5.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import ObjectMapper

struct CabinetModel: Mappable {
    var cabId: Int?
    var row: Int = 0
    var col: Int = 0
    var temperatureArray: [(String, Int)] = []
    var totalPower: Double?
    
    init?(_ map: Map) {
    }
    
    init(cabId id:Int, row: Int, col: Int, tempArray: [(String, Int)] = [], totalPower: Double? = nil) {
        self.cabId = id
        self.row = row
        self.col = col
        self.temperatureArray = tempArray
        self.totalPower = totalPower
    }
    
    mutating func mapping(map: Map) {
        cabId <- map["cabId"]
        row <- map["row"]
        col <- map["col"]
        temperatureArray <- map["temp"]
        totalPower <- map["total"]
    }
}