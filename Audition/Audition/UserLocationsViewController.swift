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

    private let systemCommand:SystemCommandCenter
    private let user:User
    private var constraintsAdded:Bool = false
    private let tableView:UITableView = UITableView(forAutoLayout: ())
    private let addLocationButton:UIButton = UIButton(forAutoLayout: ())
    
    //MARK: Constructors
    init(systemCommand:SystemCommandCenter, user:User) {
        self.systemCommand = systemCommand
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(addLocationButton)
        view.addSubview(tableView)

        addLocationButton.setTitle("Add", forState: UIControlState.Normal)
        addLocationButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        addLocationButton.addTarget(self, action: #selector(addLocationButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Config.TableView.cellId)
        
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


extension UserLocationsViewController {
    func addLocationButtonTapped(sender:UIButton) {
        log.debug("Adding a new location")
        
        let newLocationController = NewLocationViewController(systemCommand: systemCommand)
        self.addChildViewController(newLocationController)
        newLocationController.didMoveToParentViewController(self)
        
        self.view.addSubview(newLocationController.view)
        
        //TODO: (DL) COmment, move magic
        newLocationController.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 350)
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
            newLocationController.view.frame = CGRect(x:0, y:0, width: newLocationController.view.frame.width, height: newLocationController.view.frame.height)
        }) { (finished) in
            
        }
    }
}


extension UserLocationsViewController: UITableViewDelegate {

}


extension UserLocationsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.favoriteEarthLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Config.TableView.cellId, forIndexPath: indexPath)
        
        let location = self.user.favoriteEarthLocations[indexPath.row]

        cell.textLabel?.text = location.alias

        return cell
        
    }
}

