//
//  LQBarChartVC.swift
//  LQChartDemo
//
//  Created by hhh on 2019/3/9.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

class LQBarChartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.barChartView)
        self.view.addSubview(self.barChartView1)
        
    }
    
    //MARK: - lazy
    
    lazy var barChartView: LQChartView = {
        let chartView = LQChartView.chartView(frame: CGRect.init(x: 20, y: 20 + navigationBar_height, width: screen_width - 40, height: 250), type: .barChart)
        chartView.backgroundColor = .white
        chartView.chartWidth      = 10
        chartView.dataSource      = self
        return chartView
    }()
    
    lazy var barChartView1: LQChartView = {
        let chartView = LQChartView.chartView(frame: CGRect.init(x: 20, y: 300 + navigationBar_height, width: screen_width - 40, height: 250), type: .barChart)
        chartView.backgroundColor = .white
        chartView.chartWidth      = 60
        chartView.dataSource      = self
        return chartView
    }()
    
    lazy var dataSource: [Double] = {
        let dataSource = [355,50.0,270,187.0,334.0,60.0,167.0]
        return dataSource
    }()
    

}

extension LQBarChartVC: LQChartViewDataSource {
    func chartViewForDataSource(_ chartView: LQChartView) -> [Double] {
        return self.dataSource
    }
}
