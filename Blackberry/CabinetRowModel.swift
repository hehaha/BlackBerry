//
//  File.swift
//  Blackberry
//
//  Created by 何鑫 on 16/6/4.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import ObjectMapper

struct CabinetRowModel: Mappable {
    var rowName: String?
    var cabList: [CabinetModel] = []
    
    init?(_ map: Map) {
    }
    
    mutating func mapping(map: Map) {
        rowName <- map["text"]
        cabList <- map["children.list"]
    }
}