//
//  ViewController.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import PureLayout
import UIKit


private struct Config {
    struct TableView {
        static let cellId = "Location Cell"
    }

    struct ToolBar {
        static let hInset:CGFloat = 20
        static let height:CGFloat = 65
    }
}


class UserLocationsViewController: UIViewController {
    private let dateFormatter = NSDateFormatter()
    private let missionControl:MissionControl
    private let user:User
    private var constraintsAdded:Bool = false
    private let welcomeLabel:UILabel = UILabel(forAutoLayout: ())
    private let tableView:UITableView = UITableView(forAutoLayout: ())
    private let addLocationButton:UIButton = UIButton(forAutoLayout: ())
    private let toolBar = UIView(forAutoLayout: ())
    
    //MARK: Constructors
    init(missionControl:MissionControl, user:User) {
        self.missionControl = missionControl
        self.user = user

        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Apperance.Palette.primaryColor
        
        updateUserLocationFavorites()  // Kick this off ASAP so user doesn't have to wait too long for data

        toolBar.addSubview(welcomeLabel)
        toolBar.addSubview(addLocationButton)
        
        view.addSubview(toolBar)
        view.addSubview(tableView)

        if let name = user.name {
            welcomeLabel.text = "Welcome, \(name)"
        } else {
            welcomeLabel.text = "Welcome, cadet"
        }
        
        welcomeLabel.textColor = Apperance.Palette.Text.secondaryTextColor
        welcomeLabel.font = UIFont(name: Apperance.Font.name, size: 16)
        
        let inset:CGFloat = 5
        addLocationButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        addLocationButton.setImage(UIImage.imageTemplate(imageTemplateWithNamed: ImageName.Icon.addLocationIcon), forState: UIControlState.Normal)
        addLocationButton.tintColor = Apperance.Palette.accentColor
        addLocationButton.titleLabel?.font = Apperance.Font.buttonFont
        addLocationButton.addTarget(self, action: #selector(addLocationButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(LocationDetailTableViewCell.self, forCellReuseIdentifier: Config.TableView.cellId)
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            toolBar.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Bottom)
            toolBar.autoSetDimension(ALDimension.Height, toSize: Config.ToolBar.height)

            toolBar.backgroundColor = Apperance.Palette.secondaryColor

            welcomeLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: Config.ToolBar.hInset)
            welcomeLabel.autoAlignAxis(ALAxis.Horizontal, toSameAxisOfView: addLocationButton)

            addLocationButton.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: Config.ToolBar.hInset)
            addLocationButton.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: Config.ToolBar.hInset / 2.0)
            addLocationButton.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: Config.ToolBar.hInset - (Config.ToolBar.hInset / 4.0))
            addLocationButton.autoConstrainAttribute(ALAttribute.Width, toAttribute: ALAttribute.Height, ofView: addLocationButton)
            
            tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top)
            tableView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: toolBar)
    
            constraintsAdded = true
        }
        super.updateViewConstraints()
    }
}

/**
 Helpers
 */
extension UserLocationsViewController {
    
    func updateUserLocationFavorites() {
        log.info("Updating user's location favorites")

        for earthLocation in user.favoriteEarthLocations {
            updateUserLocationFavorite(earthLocation)
        }
    }

    func updateUserLocationFavorite(earthLocation:EarthLocation) {
        missionControl.issService.nextOverheadPassPrediction(onEarth: earthLocation, withCompletion: { (futureLocation, error) in
            earthLocation.issLocationInTheFuture = futureLocation
            
            if let index = self.user.favoriteEarthLocations.indexOf({ return $0 === earthLocation }) {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        })
    }
}


/**
 Target/Action
 */
extension UserLocationsViewController {
    func addLocationButtonTapped(sender:UIButton) {
        log.debug("Adding a new location")

        let newLocationController = NewLocationViewController(missionControl: missionControl)
        newLocationController.delegate = self
        self.addChildViewController(newLocationController)
        newLocationController.didMoveToParentViewController(self)
        
        self.view.addSubview(newLocationController.view)
        
        //TODO: (DL) COmment, move magic
        newLocationController.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 450)
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
            newLocationController.view.frame = CGRect(x:0, y:0, width: newLocationController.view.frame.width, height: newLocationController.view.frame.height)
        }) { (finished) in
            
        }
    }
}


/**
 NewLocationVieewControllerDelegate
 */
extension UserLocationsViewController: NewLocationViewControllerDelegate {
    
    func newLocationViewController(controller: NewLocationViewController, didCreateNewEarthLocation location: EarthLocation) {
        self.user.favoriteEarthLocations.append(location)
        updateUserLocationFavorite(location)
        tableView.reloadData()
    }
}


extension UserLocationsViewController :UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return LocationDetailTableViewCell.preferredHeight
    }
}

extension UserLocationsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.favoriteEarthLocations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Config.TableView.cellId, forIndexPath: indexPath) as! LocationDetailTableViewCell

        let location = self.user.favoriteEarthLocations[indexPath.row]
        
        // Set name
        if let locationName = location.name  {
            cell.locationNameLabel.text = locationName
        } else {
            cell.locationNameLabel.text = "Black hole"
        }
        
        // Set date
        if let issDate = location.issLocationInTheFuture?.risetimeDate {
            let dateFormatted = dateFormatter.stringFromDate(issDate)

            cell.locationDetailLabel.text = dateFormatted
        } else {
            cell.locationDetailLabel.text = "-"
        }

        return cell
    }
}

