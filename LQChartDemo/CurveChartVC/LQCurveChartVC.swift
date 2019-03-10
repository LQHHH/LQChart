//
//  LQCurveChartVC.swift
//  LQChartDemo
//
//  Created by hhh on 2019/3/9.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

class LQCurveChartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.curveChartView)
        self.view.addSubview(self.curveChartView1)
        
    }
    
    //MARK: - lazy
    
    lazy var curveChartView: LQChartView = {
        let chartView = LQChartView.chartView(frame: CGRect.init(x: 20, y: 20 + navigationBar_height, width: screen_width - 40, height: 250), type: .curveChart)
        chartView.backgroundColor = .white
        chartView.chartWidth      = 10
        chartView.dataSource      = self
        return chartView
    }()
    
    lazy var curveChartView1: LQChartView = {
        let chartView = LQChartView.chartView(frame: CGRect.init(x: 20, y: 300 + navigationBar_height, width: screen_width - 40, height: 250), type: .curveChart)
        chartView.backgroundColor = .white
        chartView.chartWidth      = 100
        chartView.dataSource      = self
        return chartView
    }()
    
    lazy var dataSource: [Double] = {
        let dataSource = [355,270,187.0,334.0,160.0,167.0]
        return dataSource
    }()
    
}

extension LQCurveChartVC: LQChartViewDataSource {
    func chartViewForDataSource(_ chartView: LQChartView) -> [Double] {
        return self.dataSource
    }
}
