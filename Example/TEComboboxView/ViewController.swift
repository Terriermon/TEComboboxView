//
//  ViewController.swift
//  TEComboboxView
//
//  Created by codermoe@gmail.com on 01/09/2019.
//  Copyright (c) 2019 codermoe@gmail.com. All rights reserved.
//

import UIKit
import TEComboboxView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let comboxView = TEComboBoxView()
        comboxView.icon = #imageLiteral(resourceName: "下箭头")
        comboxView.placeholder = "---类型选择--"
        comboxView.frame = CGRect(x: 10, y: 300, width: 300, height: 44)
        comboxView.options = (1...10).map{ "\($0)"}
        comboxView.optionSelected = {(index, title) in
            print(title)
        }
        self.view.addSubview(comboxView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

