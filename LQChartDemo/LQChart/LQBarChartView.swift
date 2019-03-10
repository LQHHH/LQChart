//
//  LQBarChartView.swift
//  LQChartDemo
//
//  Created by hhh on 2019/3/9.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

class LQBarChartView: LQChartView {
    
    let chartSpace = 20  //柱状图之间的间距
    var barWidth   = 0
    
    var datas : [Double]?
    
    override var dataSource: LQChartViewDataSource? {
        didSet{
            self.datas = self.dataSource?.chartViewForDataSource(self)
            var x      = self.datas!.count * (self.chartWidth + chartSpace) + chartSpace + LQLeftPadding + LQRightPadding
            barWidth   = self.chartWidth
            if CGFloat(x) < frame.width {
                x = Int(frame.width)
                barWidth = (Int(frame.width) - LQLeftPadding - LQRightPadding - chartSpace*(self.datas!.count + 1))/(self.datas!.count)
            }
            self.contentSize = CGSize.init(width: CGFloat(x), height: frame.size.height)
            self.pointRect   = CGRect.init(x: CGFloat(LQLeftPadding+chartSpace), y: CGFloat(LQTopPadding), width: self.contentSize.width-CGFloat(LQLeftPadding)-CGFloat(LQRightPadding), height: self.contentSize.height-CGFloat(LQTopPadding)-CGFloat(LQBottomPadding))
            self.valueRect   = CGRect.init(x: 0.0, y: 0.0, width: Double((self.datas?.count)!), height: self.maxValue)
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
        
        for i in 0..<count {
            let value = self.datas![i]
            let pointY = self.yPointWithValue(yValue: CGFloat(value))
            let pointX = self.xPointWithValue(xValue: CGFloat(i))
            let point  = CGPoint.init(x: pointX, y: pointY)
            let path = UIBezierPath.init()
            path.move(to: CGPoint.init(x: point.x, y: self.frame.size.height - CGFloat(LQBottomPadding)))
            path.addLine(to: CGPoint.init(x: point.x, y:point.y))
            path.addLine(to: CGPoint.init(x: point.x+CGFloat(barWidth), y:point.y))
            path.addLine(to: CGPoint.init(x: point.x+CGFloat(barWidth), y:self.frame.size.height - CGFloat(LQBottomPadding)))
            path.close()
            let startColor  = UIColor.init(red: 253.0/255.0, green: 163.0/255.0, blue: 66.0/255.0, alpha: 0.6).cgColor
            let endColor    = UIColor.init(red: 253.0/255.0, green: 163.0/255.0, blue: 66.0/255.0, alpha: 0.8).cgColor
            let colors = [startColor,endColor]
            let locations:[CGFloat] = [0.0,0.5,1.0]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
            let pathRect    = path.cgPath.boundingBox
            
            let startPoint  = CGPoint.init(x:pathRect.midX, y: pathRect.maxY)
            let endPoint    = CGPoint.init(x:pathRect.midX, y: pathRect.minY)
            
            ctx.saveGState()
            ctx.addPath(path.cgPath)
            ctx.clip()
            ctx.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options:CGGradientDrawingOptions.drawsBeforeStartLocation)
            ctx.restoreGState()
        }
       
        ctx.setFillColor(self.backgroundColor!.cgColor)
        ctx.fill(CGRect.init(x:Double(self.contentOffset.x), y: 0.0, width: Double(LQLeftPadding), height: Double(self.frame.size.height) - Double(LQBottomPadding)+1))
        
        ctx.restoreGState()
        
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
