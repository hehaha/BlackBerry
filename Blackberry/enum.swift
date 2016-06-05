//
//  enum.swift
//  Blackberry
//
//  Created by 何鑫 on 16/5/2.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import Foundation

enum CabinetParameter: String {
    case averagePower = "平均温度"
    case averageElectricity = "环境温度"
    case serviceTemperature = "服务器温度"
    case electricityOne = "电流一"
    case electricityTwo = "电流二"
    case voltageOne = "电压一"
    case voltageTwo = "电压二"
    case blowerOne = "风扇一"
    case blowerTwo = "风扇二"
    case blowerThree = "风扇三"
    case blowerFour = "风扇四"
    
    func value() -> Int {
        switch self {
        case .averagePower:
            return 0
        case .averageElectricity:
            return 1
        case .serviceTemperature:
            return 2
        case .electricityOne:
            return 3
        case .electricityTwo:
            return 4
        case .voltageOne:
            return 5
        case .voltageTwo:
            return 6
        case .blowerOne:
            return 7
        case .blowerTwo:
            return 8
        case .blowerThree:
            return 9
        case .blowerFour:
            return 10
        }
    }
}
