//
//  NewLocationViewController.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import PureLayout

import UIKit


protocol NewLocationViewControllerDelegate {
    func newLocationViewController(_ controller: NewLocationViewController, didCreateNewEarthLocation location:EarthLocation)
}


class NewLocationViewController: UIViewController {
    
    fileprivate let missionControl:MissionControl
    fileprivate var constraintsAdded:Bool = false
    fileprivate let locationNameTextField:UITextField = UITextField(forAutoLayout: ())
    fileprivate let saveButton:UIButton = UIButton(forAutoLayout: ())
    fileprivate let cancelButton:UIButton = UIButton(forAutoLayout: ())
    fileprivate let activityIndictaor:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var delegate:NewLocationViewControllerDelegate?

    //MARK: Constructors
    init(missionControl:MissionControl) {
        self.missionControl = missionControl

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Apperance.Palette.primaryColor
        
        activityIndictaor.translatesAutoresizingMaskIntoConstraints = false
        activityIndictaor.hidesWhenStopped = true
        activityIndictaor.color = Apperance.Palette.accentColor
        
        locationNameTextField.backgroundColor = UIColor.clear
        locationNameTextField.placeholder = "New location..."
        locationNameTextField.font = Apperance.Font.textfieldJumboFont
        locationNameTextField.tintColor = Apperance.Palette.accentColor
        
        saveButton.setTitle("Save", for: UIControlState())
        saveButton.setTitleColor(Apperance.Palette.accentColor, for: UIControlState())
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: UIControlEvents.touchUpInside)
    
        cancelButton.setImage(UIImage.imageTemplate(imageTemplateWithNamed: ImageName.Icon.closeIcon), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: UIControlEvents.touchUpInside)
        cancelButton.tintColor = Apperance.Palette.accentColor
        
        view.addSubview(self.locationNameTextField)
        view.addSubview(self.saveButton)
        view.addSubview(self.cancelButton)
        view.addSubview(activityIndictaor)
        
        updateViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationNameTextField.becomeFirstResponder()
    }

    override func updateViewConstraints() {
        if !constraintsAdded {
            //TODO: (DL) Remove magic no.
            let hInset:CGFloat = 20
            
            activityIndictaor.autoAlignAxis(toSuperviewAxis: ALAxis.vertical)
            activityIndictaor.autoConstrainAttribute(ALAttribute.bottom, to: ALAttribute.horizontal, of: self.view, withOffset: -25)
            
            locationNameTextField.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: 10)
            locationNameTextField.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: 10)
            locationNameTextField.autoAlignAxis(toSuperviewAxis: ALAxis.horizontal)
            locationNameTextField.textColor = Apperance.Palette.Text.secondaryTextColor
            locationNameTextField.keyboardType = UIKeyboardType.asciiCapable
            locationNameTextField.keyboardAppearance = UIKeyboardAppearance.alert
            locationNameTextField.attributedPlaceholder = NSAttributedString(string:"New location",
                                                            attributes:[NSForegroundColorAttributeName: Apperance.Palette.Text.secondaryTextColor])
            
            saveButton.autoPinEdge(toSuperviewEdge: ALEdge.bottom, withInset: 50)
            saveButton.autoPinEdge(ALEdge.right, to: ALEdge.right, of: locationNameTextField, withOffset: -hInset)

            cancelButton.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: 30)
            cancelButton.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: hInset)
            cancelButton.autoSetDimensions(to: CGSize(width: 25, height: 25))
            
            constraintsAdded = true
        }
        super.updateViewConstraints()
    }
}

extension NewLocationViewController {
    func close() {
        locationNameTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { (finished) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }) 
    }
    
    func setInterfaceLoading() {
        activityIndictaor.startAnimating()
        locationNameTextField.isEnabled = false
        saveButton.isEnabled = true
    }
    
    func setInterfaceNormal() {
        locationNameTextField.isEnabled = true
        saveButton.isEnabled = true
        activityIndictaor.stopAnimating()
    }
}

extension NewLocationViewController {

    func saveButtonTapped() {
        setInterfaceLoading()

        if let locationText = locationNameTextField.text {
            missionControl.earthService.forwardGeolocateLocation(locationText, withCompletion: { (coordinate, name, error) in
                log.info("Created new location: \(coordinate)")

                if let _ = self.delegate {
                    if let _ = coordinate {
                        let earthLocation:EarthLocation = EarthLocation(coordinate: coordinate!)
                        earthLocation.name = name
                        self.delegate!.newLocationViewController(self, didCreateNewEarthLocation: earthLocation)
                    }
                }
                self.setInterfaceNormal()
                self.close()
            })
        } else {
            log.debug("No text")
            setInterfaceNormal()
        }
    }

    func cancelButtonTapped() {
        close()
    }
}
