//
//  BrandedViewController.swift
//  Here
//
//  Created by Joel Klabo on 12/17/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

class BrandedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: .zero)
        label.text = "here"
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.sizeToFit()
        navigationItem.titleView = label
    }

}
