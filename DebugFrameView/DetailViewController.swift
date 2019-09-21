//
//  DetailViewController.swift
//  DebugFrameView
//
//  Created by Action on 31/08/2019.
//  Copyright © 2019 DD. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        let isSwitchOn = DebugFrameManager.shared.isDebug
        navigationItem.rightBarButtonItem = getSwitchItem(selector: #selector(switchValueDidChange(sender:)), isOn: isSwitchOn)
        
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    @objc func switchValueDidChange(sender: UISwitch) {
        
        DebugFrameManager.shared.isDebug = sender.isOn
        
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }

}

