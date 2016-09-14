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
        static let height:CGFloat = 70
    }
}


class UserLocationsViewController: UIViewController {
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let missionControl:MissionControl
    fileprivate let user:User
    fileprivate var constraintsAdded:Bool = false
    fileprivate let welcomeLabel:UILabel = UILabel(forAutoLayout: ())
    fileprivate let tableView:UITableView = UITableView(forAutoLayout: ())
    fileprivate let addLocationButton:UIButton = UIButton(forAutoLayout: ())
    fileprivate let toolBar = UIView(forAutoLayout: ())
    
    //MARK: Constructors
    init(missionControl:MissionControl, user:User) {
        self.missionControl = missionControl
        self.user = user

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    
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
        
        welcomeLabel.textColor = Apperance.Palette.Text.primaryTextColor
        welcomeLabel.font = UIFont(name: Apperance.Font.name, size: 17)
        
        let inset:CGFloat = 5
        addLocationButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        addLocationButton.setImage(UIImage.imageTemplate(imageTemplateWithNamed: ImageName.Icon.addLocationIcon), for: UIControlState())
        addLocationButton.tintColor = Apperance.Palette.accentColor
        addLocationButton.titleLabel?.font = Apperance.Font.buttonFont
        addLocationButton.addTarget(self, action: #selector(addLocationButtonTapped), for: UIControlEvents.touchUpInside)

        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationDetailTableViewCell.self, forCellReuseIdentifier: Config.TableView.cellId)
        tableView.allowsSelection = false
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            toolBar.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: ALEdge.bottom)
            toolBar.autoSetDimension(ALDimension.height, toSize: Config.ToolBar.height)

            welcomeLabel.autoPinEdge(toSuperviewEdge: ALEdge.left, withInset: Config.ToolBar.hInset)
            welcomeLabel.autoAlignAxis(ALAxis.horizontal, toSameAxisOf: addLocationButton)

            addLocationButton.autoPinEdge(toSuperviewEdge: ALEdge.top, withInset: Config.ToolBar.hInset)
            addLocationButton.autoPinEdge(toSuperviewEdge: ALEdge.bottom, withInset: Config.ToolBar.hInset / 2.0)
            addLocationButton.autoPinEdge(toSuperviewEdge: ALEdge.right, withInset: Config.ToolBar.hInset - (Config.ToolBar.hInset / 4.0))
            addLocationButton.autoConstrainAttribute(ALAttribute.width, to: ALAttribute.height, of: addLocationButton)
            
            tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: ALEdge.top)
            tableView.autoPinEdge(ALEdge.top, to: ALEdge.bottom, of: toolBar)
    
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

    func updateUserLocationFavorite(_ earthLocation:EarthLocation) {
        missionControl.issService.nextOverheadPassPrediction(onEarth: earthLocation, withCompletion: { (futureLocation, error) in
            earthLocation.issLocationInTheFuture = futureLocation
            
            if let index = self.user.favoriteEarthLocations.index(where: { return $0 === earthLocation }) {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        })
    }
}


/**
 Target/Action
 */
extension UserLocationsViewController {
    func addLocationButtonTapped(_ sender:UIButton) {
        log.debug("Adding a new location")

        let newLocationController = NewLocationViewController(missionControl: missionControl)
        newLocationController.delegate = self
        self.addChildViewController(newLocationController)
        newLocationController.didMove(toParentViewController: self)
        
        self.view.addSubview(newLocationController.view)
        
        //TODO: (DL) COmment, move magic
        newLocationController.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 450)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
            newLocationController.view.frame = CGRect(x:0, y:0, width: newLocationController.view.frame.width, height: newLocationController.view.frame.height)
        }) { (finished) in
            
        }
    }
}


/**
 NewLocationVieewControllerDelegate
 */
extension UserLocationsViewController: NewLocationViewControllerDelegate {
    
    func newLocationViewController(_ controller: NewLocationViewController, didCreateNewEarthLocation location: EarthLocation) {
        self.user.favoriteEarthLocations.append(location)
        updateUserLocationFavorite(location)
        tableView.reloadData()
    }
}


extension UserLocationsViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationDetailTableViewCell.preferredHeight
    }
}

extension UserLocationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.favoriteEarthLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Config.TableView.cellId, for: indexPath) as! LocationDetailTableViewCell

        let location = self.user.favoriteEarthLocations[(indexPath as NSIndexPath).row]
        
        // Set name
        if let locationName = location.name  {
            cell.locationNameLabel.text = locationName
        } else {
            cell.locationNameLabel.text = "Black hole"
        }
        
        // Set date
        if let issDate = location.issLocationInTheFuture?.risetimeDate {
            let dateFormatted = dateFormatter.string(from: issDate as Date)

            cell.locationDetailLabel.text = dateFormatted
        } else {
            cell.locationDetailLabel.text = "-"
        }

        return cell
    }
}

