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

    struct AddLocationButton {
        static let topInset:CGFloat = 20
        static let rightInset:CGFloat = 20
    }
}


class UserLocationsViewController: UIViewController {
    private let dateFormatter = NSDateFormatter()
    private let missionControl:MissionControl
    private let user:User
    private var constraintsAdded:Bool = false
    private let tableView:UITableView = UITableView(forAutoLayout: ())
    private let addLocationButton:UIButton = UIButton(forAutoLayout: ())

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
        
        view.addSubview(addLocationButton)
        view.addSubview(tableView)

        addLocationButton.setTitle("Add", forState: UIControlState.Normal)
        addLocationButton.setTitleColor(Apperance.Palette.accentColor, forState: UIControlState.Normal)
        addLocationButton.addTarget(self, action: #selector(addLocationButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(LocationDetailTableViewCell.self, forCellReuseIdentifier: Config.TableView.cellId)
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            addLocationButton.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: Config.AddLocationButton.topInset)
            addLocationButton.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: Config.AddLocationButton.rightInset)
    
            tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top)
            tableView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: addLocationButton)
    
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
            cell.textLabel?.text = location.alias
        }

        return cell
    }
}

