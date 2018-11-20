//
//  ContainedStackViewController.swift
//  here
//
//  Created by Joel Klabo on 7/17/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

class ContainedStackViewController: UIViewController {
    
    let viewControllers: [UIViewController]
    let axis: NSLayoutConstraint.Axis
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = self.axis
        view.distribution = .fillEqually
        return view
    }()
    
    init(witViewControllers viewControllers: [UIViewController], axis: NSLayoutConstraint.Axis) {
        self.viewControllers = viewControllers
        self.axis = axis
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = stackView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add View Controllers as Children
        for viewController in viewControllers {
            add(asChildViewController: viewController)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Arranged Subview in Stack View
        stackView.addArrangedSubview(viewController.view)
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
}
