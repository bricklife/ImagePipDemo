//
//  ImagePlayer.swift
//  ImagePipDemo
//
//  Created by ooba on 17/07/2017.
//  Copyright © 2017 mercari. All rights reserved.
//

import UIKit
import AVFoundation

class ImagePlayer {
    
    static let shared = ImagePlayer()
    
    var imageProvider: ImageProvider?
    
    lazy var player: AVPlayer = AVPlayer(playerItem: self.item)
    
    private var item: AVPlayerItem {
        let url = Bundle.main.url(forResource: "white", withExtension: "mov")!
        let asset = AVURLAsset(url: url)
        
        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { [weak self] request in
            if let image = self?.imageProvider?.ciImage(size: request.renderSize) {
                request.finish(with: image, context: nil)
            } else {
                request.finish(with: request.sourceImage, context: nil)
            }
        })
        
        let item = AVPlayerItem(asset: asset)
        item.videoComposition = composition
        
        return item
    }
    
    init() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil, using: { [weak self] _ in
            DispatchQueue.main.async {
                self?.player.seek(to: kCMTimeZero)
                self?.player.play()
            }
        })
    }
}

protocol ImageProvider {
    
    func ciImage(size: CGSize) -> CIImage?
}
