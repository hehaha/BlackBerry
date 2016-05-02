//
//  GraphView.swift
//  Blackberry
//
//  Created by 何鑫 on 16/5/2.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    var points: [CGPoint] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var redrawComplete: (() -> Void)?
    
    private var __pointsPosition: [CGPoint] = []
    
    override func drawRect(rect: CGRect) {
        if points.count == 0 {
            return
        }
        // Drawing code
        var maxX:CGFloat = 0
        var maxY:CGFloat = 0
        
        for point in points {
            maxX = point.x > maxX ? point.x : maxX
            maxY = point.y > maxY ? point.y : maxY
        }
        let graphHeight = frame.height - 15
        let graphWidth = frame.width - 15
        let horizontalUnit = graphWidth / maxX
        let verticalUnit = graphHeight / maxY
        
        let startPoint = points.first!
        let path = UIBezierPath()
        path.lineWidth = 2
        path.moveToPoint(CGPointMake(startPoint.x * horizontalUnit, graphHeight - startPoint.y * verticalUnit))
        
        __pointsPosition = []
        for point in points {
            let position = CGPointMake(CGFloat(Int(point.x * horizontalUnit)), CGFloat(Int(graphHeight - point.y * verticalUnit)))
            __pointsPosition.append(position)
            path.addLineToPoint(position)
        }
        UIColor.blackColor().setStroke()
        path.stroke()
        redrawComplete?()
    }
        
    func poiontPositionWithIndex(index: Int) -> CGPoint? {
        if index >= __pointsPosition.count {
            return nil
        }
        return __pointsPosition[index]
    }
}
