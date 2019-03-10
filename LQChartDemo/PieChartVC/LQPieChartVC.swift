//
//  LQPieChartVC.swift
//  LQChartDemo
//
//  Created by hhh on 2019/3/10.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

class LQPieChartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.pieChartView)
        
    }
    
    //MARK: - lazy
    
    lazy var pieChartView: LQChartView = {
        let chartView = LQChartView.chartView(frame: CGRect.init(x: 20, y: 20 + navigationBar_height, width: screen_width - 40, height: 250), type: .pieChart)
        chartView.backgroundColor = .white
        chartView.dataSource      = self
        chartView.pieChartColors  = [.red,.blue,.yellow,.orange,.purple]
        return chartView
    }()
    
    lazy var dataSource: [Double] = {
        let dataSource = [355.0,270.0,187.0,334.0,50.0]
        return dataSource
    }()

}

extension LQPieChartVC: LQChartViewDataSource {
    func chartViewForDataSource(_ chartView: LQChartView) -> [Double] {
        return self.dataSource
    }
}
