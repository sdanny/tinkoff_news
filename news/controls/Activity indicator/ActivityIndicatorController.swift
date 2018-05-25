//
//  ActivityIndicatorController.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit


class ActivityIndicatorController: UIViewController {
    
    enum State {
        case none
        case appearing
        case disapearing
    }
    
    @IBOutlet fileprivate var panelView: UIView!
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate var descriptionLabel: UILabel!
    @IBOutlet fileprivate var panelCenterY: NSLayoutConstraint!
    
    var text: String? {
        didSet {
            guard let label = descriptionLabel else {
                return
            }
            label.text = text
        }
    }
    
    fileprivate(set) var state = State.none
    
    // MARK: instantiating and presenting
    class func indicator() -> ActivityIndicatorController {
        let indicator = ActivityIndicatorController(nibName: String(describing: ActivityIndicatorController.self), bundle: nil)
        indicator.view.backgroundColor = UIColor.clear
        indicator.view.isOpaque = false
        indicator.view.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    func present(in view: UIView, below subview: UIView? = nil, animated: Bool = true) {
        // check if already here
        if self.view.superview == view && state != .disapearing { return }
        // check if somewhere
        if self.view.superview != nil {
            dismiss(animated: false)
        }
        state = .appearing
        if let subview = subview {
            view.insertSubview(self.view, belowSubview: subview)
        } else {
            view.addSubview(self.view)
        }
        NSLayoutConstraint.activate([view.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                     view.rightAnchor.constraint(equalTo: self.view.rightAnchor)])
        if animated {
            self.view.fadeInAnimated() {
                if self.state == .appearing {
                    self.state = .none
                }
            }
        }
    }
    
    func dismiss(animated: Bool = true) {
        if animated {
            state = .disapearing
            view.fadeOutAnimated() {
                if self.state == .disapearing {
                    self.view.removeFromSuperview()
                    self.state = .none
                }
            }
        } else {
            view.removeFromSuperview()
        }
    }
    
    // MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        descriptionLabel.text = text
    }
}


