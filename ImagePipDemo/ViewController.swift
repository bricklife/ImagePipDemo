//
//  ViewController.swift
//  ImagePipDemo
//
//  Created by ooba on 17/07/2017.
//  Copyright © 2017 mercari. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    var playerLayer: AVPlayerLayer?
    var avPictureInPictureConctroller: AVPictureInPictureController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.start()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }
    
    func start() {
        self.playerLayer?.removeFromSuperlayer()
        
        ImagePlayer.shared.imageProvider = DateImageProvider()
        
        let playerLayer = AVPlayerLayer(player: ImagePlayer.shared.player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.frame = view.bounds
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            avPictureInPictureConctroller = AVPictureInPictureController(playerLayer: playerLayer)
            avPictureInPictureConctroller?.delegate = self
        }
        
        view.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
        
        ImagePlayer.shared.player.play()
    }
    
    @IBAction func pipButtonPushed(_ sender: Any) {
        if let avPictureInPictureConctroller = avPictureInPictureConctroller, !avPictureInPictureConctroller.isPictureInPictureActive {
            avPictureInPictureConctroller.startPictureInPicture()
        }
    }
}

extension ViewController: AVPictureInPictureControllerDelegate {
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        playerLayer?.isHidden = true
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        playerLayer?.isHidden = false
    }
}
