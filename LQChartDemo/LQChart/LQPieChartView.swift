//
//  LQPieChartView.swift
//  LQChartDemo
//
//  Created by hhh on 2019/3/10.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

class LQPieChartView: LQChartView {
    
    let padding = 20
    var datas : [Double]?
    var pieShapeLayers = [LQPieChartShapeLayer]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isScrollEnabled = false
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = .clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var dataSource: LQChartViewDataSource? {
        didSet{
            self.datas = self.dataSource?.chartViewForDataSource(self)
            if self.pieChartColors.count > 0 {
                self.draw()
            }
        }
    }
    
    override var pieChartColors: [UIColor] {
        didSet {
            if (self.datas != nil) {
                self.draw()
            }
        }
    }
    
    func draw() {
        self.drawPieChart()
        self.layer.mask  = self.maskLayer
        self.animation()
    }
    
    func drawPieChart() {
        let count = self.datas!.count
        var startAngle = -Double.pi/2
        var endAngle   = startAngle
        for i in 0..<count {
            let item                = self.datas![i]
            let percent             = item/self.totalValue
            let color               = self.pieChartColors[i]
            let radius              = self.maxRadius/2 - CGFloat(padding)
            endAngle                = startAngle + Double.pi*2*percent
            let center              = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
            let bezierPath          = UIBezierPath()
            bezierPath.move(to: center)
            bezierPath.addArc(withCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
            let pieShapeLayer        = LQPieChartShapeLayer()
            pieShapeLayer.path       = bezierPath.cgPath
            pieShapeLayer.fillColor  = color.cgColor
            pieShapeLayer.startAngle = startAngle
            pieShapeLayer.endAngle   = endAngle
            self.layer.addSublayer(pieShapeLayer)
            self.pieShapeLayers.append(pieShapeLayer)
            startAngle              = endAngle
        }
    }
    
    func animation() {
        let animation                   = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration              = 1.0
        animation.fromValue             = NSNumber.init(value: 0)
        animation.toValue               = NSNumber.init(value: 1)
        animation.autoreverses          = false
        animation.isRemovedOnCompletion = false
        animation.fillMode              = .forwards
        animation.timingFunction        = CAMediaTimingFunction.init(name: .easeInEaseOut)
        self.maskLayer.add(animation, forKey: nil)
    }
    
    //MARK: - lazy
    
    lazy var totalValue: Double = {
        var total = 0.0
        for item in self.datas! {
            total = total + item
        }
        return total
    }()
    
    lazy var maxRadius: CGFloat = {
        if self.frame.size.width > self.frame.size.height {
            return self.frame.size.height
        }
        return self.frame.size.width
    }()
    
    lazy var maskLayer: CAShapeLayer = {
        let maskLayer         = CAShapeLayer.init()
        let center            = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        let radius            = self.maxRadius/2 - CGFloat(padding)
        let path              = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(3*Double.pi/2), clockwise: true)
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth   = radius*2
        maskLayer.path        = path.cgPath
        maskLayer.fillColor   = UIColor.clear.cgColor
        return maskLayer
    }()
    
    //MARK: - 重写touchesBegan
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        for layer in self.pieShapeLayers {
            if layer.path?.contains(touchPoint!) ?? false {
                layer.isSelected = !layer.isSelected
                if layer.isSelected {
                    let angle      = (layer.startAngle + layer.endAngle) / 2
                    let point      = CGPoint(x: Double(layer.position.x) + 20.0 * cos(angle), y: Double(layer.position.y) + 20.0 * sin(angle))
                    layer.position = point
                }
                else {
                    layer.position = CGPoint.zero
                }
            }
            else {
                layer.position = CGPoint.zero
                layer.isSelected = false
            }
        }
    }
}

// MARK: - 自定义layer

class LQPieChartShapeLayer: CAShapeLayer {
    var isSelected  = false
    var startAngle  = 0.0
    var endAngle    = 0.0
}
