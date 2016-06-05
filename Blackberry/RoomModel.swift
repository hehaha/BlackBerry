//
//  File.swift
//  Blackberry
//
//  Created by 何鑫 on 16/2/14.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import ObjectMapper

struct RoomModel: Mappable {
    var name: String?
    var roomId: Int?
    
    init?(_ map: Map) {
        
    }
    
    init?(roomId id: Int, name: String) {
        self.name = name
        self.roomId = id
    }
    
    mutating func mapping(map: Map) {
        roomId <- map["centerNo"]
        name <- map["text"]
    }
}
