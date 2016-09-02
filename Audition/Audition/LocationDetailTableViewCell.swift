//
//  LocationDetailTableViewCell.swift
//  Audition
//
//  Created by Dru Lang on 9/2/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import PureLayout

import UIKit

class LocationDetailTableViewCell: UITableViewCell {
    static let preferredHeight:CGFloat = 100

    private var constraintsAdded:Bool = false
    
    let locationNameLabel = UILabel(forAutoLayout: ())
    let locationDetailLabel = UILabel(forAutoLayout: ())
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()

        locationNameLabel.font = Apperance.Font.headlineFont
        locationNameLabel.textColor = Apperance.Palette.Text.primaryTextColor
        
        locationDetailLabel.font = Apperance.Font.subtitleFont
        locationDetailLabel.textColor = Apperance.Palette.Text.primaryTextColor
        
        contentView.addSubview(locationNameLabel)
        contentView.addSubview(locationDetailLabel)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func updateConstraints() {
        let hPadding:CGFloat = 10

        if !constraintsAdded {
            locationNameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: hPadding)
            locationNameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 0)
            locationNameLabel.autoConstrainAttribute(ALAttribute.Bottom, toAttribute: ALAttribute.Horizontal, ofView: self, withOffset: 0)
            
            locationDetailLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: hPadding + 10)
            locationDetailLabel.autoConstrainAttribute(ALAttribute.Top, toAttribute: ALAttribute.Horizontal, ofView: self, withOffset: 0)

            constraintsAdded = true
        }
        super.updateConstraints()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

