//
//  ViewController.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import PureLayout
import UIKit

class UserLocationsViewController: UIViewController {
    static let locationCellId = "Location Cell"
    
    private let systemCommand:SystemCommandCenter
    private let user:User
    private var constraintsAdded:Bool = false
    private let tableView:UITableView = UITableView(forAutoLayout: ())

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

        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: UserLocationsViewController.locationCellId)
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
            constraintsAdded = true
        }
        super.updateViewConstraints()
    }
}


extension UserLocationsViewController: UITableViewDelegate {
    
}

extension UserLocationsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.favoriteEarthLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UserLocationsViewController.locationCellId, forIndexPath: indexPath)
        
        let location = self.user.favoriteEarthLocations[indexPath.row]

        cell.textLabel?.text = location.alias

        return cell
        
    }
}

