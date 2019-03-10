//
//  LQLineChartVC.swift
//  LQChartTest
//
//  Created by hhh on 2019/3/7.
//  Copyright © 2019 hhh. All rights reserved.
//

import UIKit

class LQLineChartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.lineChartView)
        self.view.addSubview(self.lineChartView1)
       
    }
    
    //MARK: - lazy
    
    lazy var lineChartView: LQChartView = {
        let chartView = LQChartView.chartView(frame: CGRect.init(x: 20, y: 20 + navigationBar_height, width: screen_width - 40, height: 250), type: .lineChart)
            chartView.backgroundColor = .white
            chartView.chartWidth      = 10
            chartView.dataSource      = self
        return chartView
    }()
    
    lazy var lineChartView1: LQChartView = {
        let chartView = LQChartView.chartView(frame: CGRect.init(x: 20, y: 300 + navigationBar_height, width: screen_width - 40, height: 250), type: .lineChart)
        chartView.backgroundColor = .white
        chartView.chartWidth      = 100
        chartView.dataSource      = self
        return chartView
    }()
    
    lazy var dataSource: [Double] = {
        let dataSource = [500.8,50.0,334.0,60.0,167.0,177.0,187.0,334.0,60.0,167.0]
        return dataSource
    }()

}

extension LQLineChartVC: LQChartViewDataSource {
    func chartViewForDataSource(_ chartView: LQChartView) -> [Double] {
        return self.dataSource
    }
}
