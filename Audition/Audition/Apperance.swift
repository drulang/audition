//
//  Apperance.swift
//  Audition
//
//  Created by Dru Lang on 9/2/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

struct Apperance {
    struct Palette {
        static let primaryColor = UIColor.whiteColor()
        static let secondaryColor = UIColor.lightGrayColor()
        static let accentColor = UIColor.blueColor()
        
        struct Text {
            static let primaryTextColor = UIColor.blueColor()
            static let secondaryTextColor = UIColor.lightGrayColor()
        }
    }
    
    struct Font {
        static let name = "Courier New"
        static let headlineFont = UIFont(name: Font.name, size: 25)
        static let titleFont = UIFont(name: Font.name, size: 19)
        static let subtitleFont = UIFont(name: Font.name, size: 17)
        static let textfieldJumboFont = UIFont(name: Font.name, size: 40)
    }
}