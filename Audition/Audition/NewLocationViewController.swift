//
//  NewLocationViewController.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController {
    
    private let systemCommand:SystemCommandCenter
    private var constraintsAdded:Bool = false
    
    //MARK: Constructors
    init(systemCommand:SystemCommandCenter) {
        self.systemCommand = systemCommand

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
        }
        super.updateViewConstraints()
    }
    
}
