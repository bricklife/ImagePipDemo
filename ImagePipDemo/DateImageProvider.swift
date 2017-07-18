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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
            NSForegroundColorAttributeName: UIColor.black,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let textRect = (text as NSString).boundingRect(with: size,
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: attributes,
                                                       context: nil)
        let drawRect = textRect.offsetBy(dx: rect.midX - textRect.midX, dy: rect.midY - textRect.midY)
        
        text.draw(in: drawRect, withAttributes: attributes)
        
        // Create image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image.flatMap { CIImage(image: $0) }
    }
}
