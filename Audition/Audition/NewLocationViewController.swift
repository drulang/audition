//
//  NewLocationViewController.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import PureLayout

import UIKit

class NewLocationViewController: UIViewController {
    
    private let systemCommand:SystemCommandCenter
    private var constraintsAdded:Bool = false
    private let locationNameTextField:UITextField = UITextField(forAutoLayout: ())
    private let saveButton:UIButton = UIButton(forAutoLayout: ())
    private let cancelButton:UIButton = UIButton(forAutoLayout: ())
    
    
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
        
        locationNameTextField.backgroundColor = UIColor.whiteColor()
        
        saveButton.setTitle("Save", forState: UIControlState.Normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
    
        cancelButton.setTitle("X", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(self.locationNameTextField)
        view.addSubview(self.saveButton)
        view.addSubview(self.cancelButton)
        
        updateViewConstraints()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationNameTextField.becomeFirstResponder()
    }

    override func updateViewConstraints() {
        if !constraintsAdded {
            //TODO: (DL) Remove magic no.
            locationNameTextField.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 30)
            locationNameTextField.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 30)
            locationNameTextField.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
           
            saveButton.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 50)
            saveButton.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: locationNameTextField)
            
            cancelButton.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 20)
            cancelButton.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 20)
            
            constraintsAdded = true
        }
        super.updateViewConstraints()
    }
}

extension NewLocationViewController {
    func close() {
        locationNameTextField.resignFirstResponder()
        
        UIView.animateWithDuration(0.1, animations: {
            self.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }) { (finished) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
}

extension NewLocationViewController {
    
    func saveButtonTapped() {
        close()
    }
    
    func cancelButtonTapped() {
        close()
    }
}
