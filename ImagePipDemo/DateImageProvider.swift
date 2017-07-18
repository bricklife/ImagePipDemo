//
//  DateImageProvider.swift
//  ImagePipDemo
//
//  Created by ooba on 17/07/2017.
//  Copyright © 2017 mercari. All rights reserved.
//

import UIKit
import AVFoundation

class DateImageProvider: ImageProvider {
    
    func ciImage(size: CGSize) -> CIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // Fill background
        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)
        
        // Draw text
        let text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .long)
        let fontSize = size.width / 16
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
            NSForegroundColorAttributeName: UIColor.black,
            NSParagraphStyleAttributeName: textStyle
        ]
        let textRect = CGRect(x: 0, y: (rect.height - fontSize) / 2, width: rect.width, height: fontSize)
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // Create image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image.flatMap { CIImage(image: $0) }
    }
}
