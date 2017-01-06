//
//  WebViewController.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/21/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import UIKit
import AVFoundation

class FullScreenVideoViewController: UIViewController {

    var playerLayer: AVPlayerLayer?
    var videoFileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoPlayer()
    }
    
    private func setupVideoPlayer() {
        guard let videoFileName = videoFileName else { return }
        
        if let videoURL = Bundle.main.url(forResource: videoFileName, withExtension: "mp4") {
            let player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            if let playerLayer = playerLayer {
                playerLayer.frame = self.view.bounds
                self.view.layer.addSublayer(playerLayer)
                player.play()
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
