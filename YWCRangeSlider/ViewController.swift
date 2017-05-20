//
//  ViewController.swift
//  YWCRangeSlider
//
//  Created by YangWeicheng on 15/05/2017.
//  Copyright © 2017 YWC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YWCRangeSlider"
        
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        let basicSlider = RangeSlider(frame: CGRect(x: 50, y: 50, width: 300, height: 50));
        view.addSubview(basicSlider);
        
        let minimumRangeNegativeSlider = RangeSlider(frame: CGRect(x: 50, y: 100, width: 300, height: 50));
        minimumRangeNegativeSlider.minimumRange = -1;
        view.addSubview(minimumRangeNegativeSlider);
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = "fsadf"
        return cell!
    }
}
