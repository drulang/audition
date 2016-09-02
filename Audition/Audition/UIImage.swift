//
//  UIImage.swift
//  Audition
//
//  Created by Dru Lang on 9/2/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func imageTemplate(imageTemplateWithNamed imageName:String) -> UIImage? {
        var finalImage:UIImage?
    
        if let image = UIImage(named: imageName) {
            finalImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }

        return finalImage
    }
}
