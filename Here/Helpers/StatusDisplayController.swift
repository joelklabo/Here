//
//  StatusDisplayController.swift
//  Here
//
//  Created by Joel Klabo on 11/21/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

class StatusDisplayController: NSObject {

    static let shared = StatusDisplayController()
    
    private var statusView = UIView()
    private var progressIndicator = UIActivityIndicatorView(style: .gray)
    private var statusLabel = UILabel()
    
    private var topConstraint: NSLayoutConstraint?
    
    private let hiddenTopConstant: CGFloat = -99
    private let shownTopConstant:CGFloat = 12
    
    private var show: Bool = true {
        didSet {
            if show {
                topConstraint?.constant = shownTopConstant
            } else {
                topConstraint?.constant = hiddenTopConstant
            }
            statusView.superview?.setNeedsLayout()
        }
    }
    
    private var rootView: UIView? {
        return UIApplication.shared.keyWindow?.rootViewController?.children.first?.view
    }
    
    override init() {
        super.init()
        setupViews()
    }
    
    func setupViews() {
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.startAnimating()
        
        statusView.addSubview(progressIndicator)
        statusView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            progressIndicator.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            statusView.leadingAnchor.constraint(equalTo: progressIndicator.leadingAnchor, constant: -10),
            statusView.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 10),
            statusView.heightAnchor.constraint(equalTo: statusLabel.heightAnchor, multiplier: 2),
            progressIndicator.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)
        ])
    }
    
    func prepare() {
        guard let rootView = rootView else { fatalError("Must have a root view before preparing")}
        
        statusView.backgroundColor = .white
        statusView.layer.cornerRadius = 20
        rootView.addSubview(statusView)
        
        statusLabel.text = "TEST"
        
        let guide = rootView.safeAreaLayoutGuide
        
        topConstraint = statusView.topAnchor.constraint(equalTo: guide.topAnchor, constant: hiddenTopConstant)
        topConstraint?.isActive = true
        statusView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
    }
    
    func show(message: String) {
        DispatchQueue.main.async {
            self.show = true
            self.statusLabel.text = message
            UIView.animate(withDuration: 0.2, animations: {
                self.statusView.superview?.layoutIfNeeded()
            })
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.show = false
            UIView.animate(withDuration: 0.2, animations: {
                self.statusView.superview?.layoutIfNeeded()
            })
        }
    }
}
