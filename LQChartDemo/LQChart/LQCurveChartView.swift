//
//  LQCurveChartView.swift
//  LQChartDemo
//
//  Created by hhh on 2019/3/9.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

class LQCurveChartView: LQChartView {

    var datas : [Double]?
    
    override var dataSource: LQChartViewDataSource? {
        didSet{
            self.datas = self.dataSource?.chartViewForDataSource(self)
            var x      = (self.datas!.count - 1) * self.chartWidth + LQLeftPadding + LQRightPadding
            if CGFloat(x) < frame.width {
                x = Int(frame.width)
            }
            self.contentSize = CGSize.init(width: CGFloat(x), height: frame.size.height)
            self.pointRect   = CGRect.init(x: CGFloat(LQLeftPadding+20), y: CGFloat(LQTopPadding), width: self.contentSize.width-CGFloat(LQLeftPadding)-CGFloat(LQRightPadding+20), height: self.contentSize.height-CGFloat(LQTopPadding)-CGFloat(LQBottomPadding))
            self.valueRect   = CGRect.init(x: 0.0, y: 0.0, width: Double((self.datas?.count)!-1), height: self.maxValue)
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.datas?.count == 0 {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        self.drawChart(ctx!)
        if self.isNeedAxisX {
            self.drawAxisX(ctx!)
        }
        if self.isNeedAxisY == true {
            self.drawAxisY(ctx!)
            self.drawTextInAxisY(ctx!)
        }
    }
    
    func drawAxisY(_ ctx:CGContext) {
        ctx.saveGState()
        //y轴
        let lineColor = UIColor.init(white: 0, alpha: 0.2)
        ctx.setStrokeColor(lineColor.cgColor)
        ctx.setLineWidth(0.5)
        let startPoint = CGPoint.init(x: CGFloat(LQLeftPadding)+self.contentOffset.x, y: self.frame.size.height - CGFloat(LQBottomPadding))
        ctx.move(to: startPoint)
        let endPointY    = CGPoint.init(x: CGFloat(LQLeftPadding)+self.contentOffset.x, y: CGFloat(LQTopPadding))
        ctx.addLine(to: endPointY)
        ctx.strokePath()
        ctx.restoreGState()
    }
    
    func drawAxisX(_ ctx:CGContext) {
        ctx.saveGState()
        //x轴
        let lineColor = UIColor.init(white: 0, alpha: 0.2)
        ctx.setStrokeColor(lineColor.cgColor)
        ctx.setLineWidth(0.5)
        let startPoint = CGPoint.init(x: CGFloat(LQLeftPadding)+self.contentOffset.x, y: self.frame.size.height - CGFloat(LQBottomPadding))
        let endPointX   = CGPoint.init(x:  self.frame.size.width + self.contentOffset.x, y: self.frame.size.height - CGFloat(LQBottomPadding))
        ctx.move(to: startPoint)
        ctx.addLine(to: endPointX)
        ctx.strokePath()
        ctx.restoreGState()
    }
    
    func drawTextInAxisY(_ ctx:CGContext) {
        ctx.saveGState()
        //y轴文字
        let maxText = "\(lround(self.maxValue))"
        let attributedString = NSMutableAttributedString.init(string: maxText)
        let textColor        = UIColor.init(white: 0, alpha: 0.3)
        attributedString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor:textColor], range: NSMakeRange(0, maxText.count))
        let size = attributedString.size()
        attributedString.draw(in: CGRect.init(x: (CGFloat(LQLeftPadding)-size.width)/2+self.contentOffset.x, y: CGFloat(LQTopPadding)-size.height/2, width: size.width, height: size.height))
        
        let centerText = "\(lround(Double(2*lround(self.maxValue)/3)))"
        let centerAttributedString = NSMutableAttributedString.init(string: centerText)
        centerAttributedString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor:textColor], range: NSMakeRange(0, centerText.count))
        let centerSize = centerAttributedString.size()
        let centerY = (self.frame.size.height - CGFloat(LQTopPadding + LQBottomPadding))/3+CGFloat(LQTopPadding)-centerSize.height/2;
        centerAttributedString.draw(in: CGRect.init(x: (CGFloat(LQLeftPadding)-centerSize.width)/2+self.contentOffset.x, y:centerY, width: centerSize.width, height: centerSize.height))
        
        let bottomText = "\(lround(Double(lround(self.maxValue)/3)))"
        let bottomAttributedString = NSMutableAttributedString.init(string: bottomText)
        bottomAttributedString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor:textColor], range: NSMakeRange(0, bottomText.count))
        let bottomSize = bottomAttributedString.size()
        let bottomY = 2*(self.frame.size.height - CGFloat(LQTopPadding + LQBottomPadding))/3+CGFloat(LQTopPadding)-bottomSize.height/2;
        bottomAttributedString.draw(in: CGRect.init(x: (CGFloat(LQLeftPadding)-bottomSize.width)/2+self.contentOffset.x, y: bottomY, width: bottomSize.width, height: bottomSize.height))
        
        
        ctx.restoreGState()
    }
    
    func drawChart(_ ctx:CGContext) {
        ctx.saveGState()
        let count:Int   = self.datas!.count
        ctx.setStrokeColor(UIColor.init(red: 84.0/255.0, green: 196.0/255.0, blue: 252.0/255.0, alpha: 1).cgColor)
        ctx.setLineWidth(1)
        for i in 0..<count-1 {
            let value = self.datas![i]
            let startPoint  = CGPoint.init(x: self.xPointWithValue(xValue: CGFloat(i)), y: self.yPointWithValue(yValue: CGFloat(value)))
            let value1 = self.datas![i+1]
            let endPoint  = CGPoint.init(x: self.xPointWithValue(xValue: CGFloat(i+1)), y: self.yPointWithValue(yValue: CGFloat(value1)))
            
            if i == 0 {
                ctx.move(to: startPoint)
            }
            else {
                ctx.addCurve(to: endPoint, control1: CGPoint.init(x: (endPoint.x-startPoint.x)/2+startPoint.x, y: startPoint.y), control2:  CGPoint.init(x: (endPoint.x-startPoint.x)/2+startPoint.x, y: endPoint.y))
            }
            
        }
        ctx.strokePath()
        
        self.drawGradientLayer(ctx)
        
        ctx.setFillColor(self.backgroundColor!.cgColor)
        ctx.fill(CGRect.init(x:Double(self.contentOffset.x), y: 0.0, width: Double(LQLeftPadding), height: Double(self.frame.size.height) - Double(LQBottomPadding)+1))
        
        ctx.restoreGState()
        
    }
    
    func drawGradientLayer(_ ctx:CGContext) {
        ctx.saveGState()
        
        let colorSpace  = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0,1.0]
        let startColor  = UIColor.init(red: 84.0/255.0, green: 196.0/255.0, blue: 252.0/255.0, alpha: 0.4).cgColor
        let endColor    = UIColor.init(red: 84.0/255.0, green: 196.0/255.0, blue: 252.0/255.0, alpha: 0.6).cgColor
        let gradient    = CGGradient.init(colorsSpace: colorSpace, colors: [startColor,endColor] as CFArray, locations: locations)
        let pathRect    = self.fillPath().cgPath.boundingBox
        
        let startPoint  = CGPoint.init(x:pathRect.midX, y: pathRect.maxY)
        let endPoint    = CGPoint.init(x:pathRect.midX, y: pathRect.minY)
        
        ctx.saveGState()
        ctx.addPath(self.fillPath().cgPath)
        ctx.clip()
        ctx.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options:CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        ctx.restoreGState()
        
    }
    
    func fillPath() -> UIBezierPath {
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x:CGFloat(LQLeftPadding+20), y:  self.frame.size.height - CGFloat(LQBottomPadding)))
        let count:Int   = self.datas!.count
        var lastPoint   = CGPoint.zero
        for i in 0..<count-1 {
            let value = self.datas![i]
            let startPoint  = CGPoint.init(x: self.xPointWithValue(xValue: CGFloat(i)), y: self.yPointWithValue(yValue: CGFloat(value)))
            let value1 = self.datas![i+1]
            let endPoint  = CGPoint.init(x: self.xPointWithValue(xValue: CGFloat(i+1)), y: self.yPointWithValue(yValue: CGFloat(value1)))
            if i == 0 {
                path.addLine(to:startPoint)
            }
            else{
            path.addCurve(to: endPoint, controlPoint1: CGPoint.init(x: (endPoint.x-startPoint.x)/2+startPoint.x, y: startPoint.y), controlPoint2: CGPoint.init(x: (endPoint.x-startPoint.x)/2+startPoint.x, y: endPoint.y))
            }
            if (i+2 == count) {
                lastPoint = endPoint
            }
        }
        path.addLine(to: CGPoint.init(x: lastPoint.x , y:  self.frame.size.height - CGFloat(LQBottomPadding)))
        path.close()
        return path
    }
    
    //MARK: - lazy
    
    lazy var maxValue: Double = {
        var max = self.datas![0]
        let count:Int   = self.datas!.count
        for i in 0..<count {
            let value = self.datas![i]
            if value > max {
                max = value
            }
        }
        
        return max
    }()

}
