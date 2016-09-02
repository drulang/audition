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
        static let primaryColor = UIColor(red: 13/255.0, green: 21/255.0, blue: 28/255.0, alpha: 1)
        static let secondaryColor = UIColor(red: 17/255.0, green: 49/255.0, blue: 78/255.0, alpha: 1)
        static let accentColor = UIColor(red: 174/255.0, green: 220/255.0, blue: 226/255.0, alpha: 1)
        
        struct Text {
            static let primaryTextColor = UIColor(red: 174/255.0, green: 220/255.0, blue: 226/255.0, alpha: 1)
            static let secondaryTextColor = UIColor(red: 70/255.0, green: 144/255.0, blue: 178/255.0, alpha: 1)
        }
    }
    
    struct Font {
        static let name = "Courier New"
        static let headlineFont = UIFont(name: Font.name, size: 25)
        static let titleFont = UIFont(name: Font.name, size: 19)
        static let subtitleFont = UIFont(name: Font.name, size: 17)
        static let textfieldJumboFont = UIFont(name: Font.name, size: 40)
        static let buttonFont = UIFont(name: Font.name, size: 16)
    }
}

struct  ImageName {
    struct Icon {
        static let addLocationIcon = "icon-add-location"
        static let closeIcon = "icon-close"
    }
}