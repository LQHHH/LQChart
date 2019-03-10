//
//  ViewController.swift
//  LQChartDemo
//
//  Created by hhh on 2019/3/9.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "LQChart"
        
        self.setupUI()
    }
    
    //MARK: - UI
    
    func setupUI() {
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    //MARK: - lazy
    
    lazy var titles: [Any] = {
        let titles = ["折线图",
                      "柱状图",
                      "曲线图",
                      "饼状图"]
        return titles
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.rowHeight       = 60
        tableView.delegate        = self
        tableView.dataSource      = self
        return tableView
    }()
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        var cell       = tableView.dequeueReusableCell(withIdentifier: identifier)
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = self.titles[indexPath.row] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = LQLineChartVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = LQBarChartVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = LQCurveChartVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = LQPieChartVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

