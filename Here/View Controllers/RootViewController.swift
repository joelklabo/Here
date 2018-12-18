//
//  RootViewController.swift
//  Here
//
//  Created by Joel Klabo on 11/28/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

class RootViewController: BrandedViewController {

    let mapViewController = MapViewController()
    let tabBar = UITabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(mapViewController)
        view.addSubview(mapViewController.view)
        mapViewController.view.translatesAutoresizingMaskIntoConstraints = false
        mapViewController.didMove(toParent: self)
        
        let barItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        tabBar.setItems([barItem], animated: true)
        tabBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(composeButtonTapped)))
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mapViewController.view.leftAnchor.constraint(equalTo: guide.leftAnchor),
            mapViewController.view.topAnchor.constraint(equalTo: guide.topAnchor),
            mapViewController.view.rightAnchor.constraint(equalTo: guide.rightAnchor),
            mapViewController.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            tabBar.leftAnchor.constraint(equalTo: guide.leftAnchor),
            tabBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            tabBar.rightAnchor.constraint(equalTo: guide.rightAnchor)
        ])
    }
    
    @objc func composeButtonTapped() {
        let recordingViewController = RecordingViewController()
        recordingViewController.location = mapViewController.currentLocation
        let navigationController = UINavigationController(rootViewController: recordingViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
