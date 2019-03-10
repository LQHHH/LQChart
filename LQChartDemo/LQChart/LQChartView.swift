//
//  LQChartView.swift
//  LQChartTest
//
//  Created by hhh on 2019/3/7.
//  Copyright © 2019 hhh. All rights reserved.
//

import UIKit

enum LQChartViewType {
    case lineChart          //折线图
    case barChart           //柱状图
    case curveChart         //曲线图
    case pieChart           //饼状图
}

@objc protocol LQChartViewDataSource {
     func chartViewForDataSource(_ chartView:LQChartView) -> [Double]
}

class LQChartView: UIScrollView {
    
    public let LQLeftPadding   = 50
    public let LQRightPadding  = 20
    public let LQTopPadding    = 20
    public let LQBottomPadding = 30
    
    public var pointRect   = CGRect.zero
    public var valueRect   = CGRect.zero
    public var chartWidth  = 15 //单个数据宽
    public var pieChartColors:[UIColor] = []
    public var isNeedAxisY = true
    public var isNeedAxisX = true
    public var dataSource : LQChartViewDataSource?
    
    class func chartView(frame:CGRect, type:LQChartViewType) -> LQChartView {
        var chartView : LQChartView?
        switch type {
        case .lineChart:
            chartView = LQLineChartView.init(frame: frame)
            break
        case .barChart:
            chartView = LQBarChartView.init(frame: frame)
            break
        case .curveChart:
            chartView = LQCurveChartView.init(frame: frame)
            break
        case .pieChart:
            chartView = LQPieChartView.init(frame: frame)
            break
        }
        chartView?.delegate                       = chartView
        chartView?.showsVerticalScrollIndicator   = false
        chartView?.showsHorizontalScrollIndicator = false
        return chartView!
    }
    
    // MARK: - 坐标和值的转化
    
    public func xPointWithValue(xValue:CGFloat) -> CGFloat {
        let xPoint = self.pointRect.origin.x + self.pointRect.size.width * ((xValue - self.valueRect.origin.x)/self.valueRect.size.width);
        return xPoint
    }
    
    public func yPointWithValue(yValue:CGFloat) -> CGFloat {
        let yPoint = (self.pointRect.origin.y + self.pointRect.size.height) - self.pointRect.size.height * ((yValue - self.valueRect.origin.y) / self.valueRect.size.height)
        return yPoint
    }
    
   public func xValueWithPoint(xPoint:CGFloat) -> CGFloat {
        let xValue = (xPoint - self.pointRect.origin.x)/self.pointRect.size.width*self.valueRect.size.width + self.valueRect.origin.x;
        return xValue
    }
    
   public func yValueWithPoint(yPoint:CGFloat) -> CGFloat {
        let yValue = (self.pointRect.origin.y + self.pointRect.size.height - yPoint)/self.pointRect.size.height * self.valueRect.size.height + self.valueRect.origin.y;
        return yValue
    }
    
    public func contentOffsetDidChange(_ contentOffset:CGPoint) {}

}

extension LQChartView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self {
            return;
        }
        
        self.setNeedsDisplay()
        self.contentOffsetDidChange(self.contentOffset)
    }
}
