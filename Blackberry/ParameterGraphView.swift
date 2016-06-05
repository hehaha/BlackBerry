//
//  ParameterGraphView.swift
//  Blackberry
//
//  Created by 何鑫 on 16/5/2.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit

class ParameterGraphView: UIView {
    
    private let __graphView = GraphView()
    private let __xAxisView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    
    private let __yAxisView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    
    private var __xLabels: [UILabel] = []
    private var __yLabels: [UILabel] = []
    private let __xLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    private let __yLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    var points: [(CGFloat, String)] = [] {
        didSet {
            var graphPoints: [CGPoint] = []
            for (x, y) in points.enumerate() {
                graphPoints.append(CGPointMake(CGFloat(x + 1), y.0))
            }
            __graphView.points = graphPoints
            while __xLabels.count != points.count {
                if __xLabels.count < points.count {
                    let xLabel = UILabel()
                    __xLabelContainerView.addSubview(xLabel)
                    xLabel.snp_makeConstraints(closure: { (make) in
                        make.bottom.equalTo(__xLabelContainerView)
                        make.top.equalTo(__xLabelContainerView)
                        make.centerX.equalTo(__xLabelContainerView.snp_left)
                    })
                    __xLabels.append(xLabel)
                    
                    let yLabel = UILabel()
                    __yLabelContainerView.addSubview(yLabel)
                    yLabel.snp_makeConstraints(closure: { (make) in
                        make.left.equalTo(__yLabelContainerView)
                        make.right.equalTo(__yLabelContainerView)
                        make.centerY.equalTo(__yLabelContainerView.snp_top)
                    })
                    __yLabels.append(yLabel)
                }
                else {
                    let lastX = __xLabels.popLast()
                    lastX?.removeFromSuperview()
                    let lastY = __yLabels.popLast()
                    lastY?.removeFromSuperview()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(__xAxisView)
        self.addSubview(__yAxisView)
        self.addSubview(__xLabelContainerView)
        self.addSubview(__yLabelContainerView)
        self.addSubview(__graphView)
        
        __xAxisView.snp_makeConstraints { (make) in
            make.bottom.equalTo(__xLabelContainerView.snp_top)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(2)
        }
        
        __yAxisView.snp_makeConstraints { (make) in
            make.left.equalTo(__yLabelContainerView.snp_right)
            make.top.equalTo(self).offset(18)
            make.bottom.equalTo(self)
            make.width.equalTo(2)
        }
        
        __xLabelContainerView.snp_makeConstraints { (make) in
            make.left.equalTo(__yAxisView.snp_right)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        __yLabelContainerView.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self).offset(18)
            make.bottom.equalTo(__xAxisView.snp_top)
        }
        
        __graphView.backgroundColor = UIColor.whiteColor()
        __graphView.snp_makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.equalTo(self).offset(18)
            make.bottom.equalTo(__xAxisView.snp_top)
            make.left.equalTo(__yAxisView.snp_right)
        }
        
        __graphView.redrawComplete = {[unowned self] in
            for i in 0..<self.points.count {
                let point = self.points[i]
                let xLabel = self.__xLabels[i]
                let yLabel = self.__yLabels[i]
                guard let position = self.__graphView.poiontPositionWithIndex(i) else {
                    continue
                }
                if !point.1.hasSuffix("30") && !point.1.hasSuffix("00") {
                    xLabel.hidden = true
                    yLabel.hidden = true
                    continue
                }
                xLabel.text = point.1
                xLabel.hidden = false
                yLabel.text = "\(point.0)"
                yLabel.hidden = false
                xLabel.snp_updateConstraints(closure: { (make) in
                    make.centerX.equalTo(self.__xLabelContainerView.snp_left).offset(position.x)
                })
                yLabel.snp_updateConstraints(closure: { (make) in
                    make.centerY.equalTo(self.__yLabelContainerView.snp_top).offset(position.y)
                })
                
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        __graphView.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
