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
    
    override var dataSource: LQChartViewDataSource? {
        didSet{
            self.datas = self.dataSource?.chartViewForDataSource(self)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()
        self.drawPieChart(ctx!)
        self.layer.mask  = self.maskLayer
        self.animation()
    }
    
    func drawPieChart(_ ctx:CGContext) {
        ctx.saveGState()
        let count = self.datas!.count
        var startAngle = -Double.pi/2
        var endAngle   = startAngle
        for i in 0..<count {
            let item    = self.datas![i]
            let percent = item/self.totalValue
            let color   = self.pieChartColors[i]
            ctx.setFillColor(color.cgColor)
            let radius  = self.maxRadius/2 - CGFloat(padding)
            endAngle    = startAngle + Double.pi*2*percent
            let center  = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
            ctx.move(to: center)
            ctx.addArc(center: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
            ctx.fillPath()
            startAngle   = endAngle
        }
        ctx.restoreGState()
    }
    
    func animation() {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration  = 1.0
        animation.fromValue = NSNumber.init(value: 0)
        animation.toValue   = NSNumber.init(value: 1)
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode  = .forwards
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
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
        let maskLayer  = CAShapeLayer.init()
        let center     = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        let radius     = self.maxRadius/2 - CGFloat(padding)
        let path       = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(3*Double.pi/2), clockwise: true)
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth   = radius*2
        maskLayer.path        = path.cgPath
        maskLayer.fillColor   = UIColor.clear.cgColor
        maskLayer.strokeEnd   = 0
        return maskLayer
    }()
    

}
