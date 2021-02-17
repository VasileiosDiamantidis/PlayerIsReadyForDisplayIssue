//
//  ViewController.swift
//  PlayerIsReadyForDisplayIssue
//
//  Created by Vasileios on 17.02.21.
//

import UIKit
import AVKit
import AVFoundation
import TvOSSlider

private var playerItemStatusContext = 0
private var playerContext = 1
private var playerStatusContext = 2

class ViewController: UIViewController {
    
    /* normal stream play URL*/
//    let link = "https://staging-hls-live.zahs.tv/HD_ard-live.m3u8?z32=MF2WI2LPL5RW6ZDFMNZT2YLBMMTGG43JMQ6TCNRWGQ4TMRRTGAZTKQSCGAYECLJSGEYUEQZTGI2DEMJWIRCTKOBZEZZWSZZ5GE3V6NJUGEYWMMBYGM3GMZJRMQ4DKMZTMYZWEM3FGEYDCNTCGZSWKYTE"
    
    /* trick play URL*/
    let link = "https://demo-hls7-live.zahs.tv/hd/t_track_trick_bw_4800_num_0_tid_3_nd_4000_mbr_5000.m3u8?z32=ORUW2ZLTNBUWM5B5GM3DAMBGOY6TAJTTNFTT2MRRL44DANRRMI2DCOBSGM2DEZBRHFRWGYLGHBSGGNJQMRSTGZBWME4WM"
    
    var previewLayer: AVPlayerLayer?
    private var playerwIsReadyForDisplayItemObserver: NSKeyValueObservation?
    
    private var slider: TvOSSlider!
    private var valueLabel: UILabel!
    
    private var player: AVPlayer!
    private var playerItem: AVPlayerItem!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpPlayer(link: link)
        addObservers()
        previewLayer?.player?.pause()
        setUpSlider()
    }
    
    private func setUpPlayer(link: String) {
        if let playerURL = URL.init(string: link) {
            playerItem = AVPlayerItem(url: playerURL)
            
            playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemStatusContext)
    
            player = AVPlayer(playerItem: playerItem)
            
            player.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: [.initial, .old, .new], context: &playerContext)
            player.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.initial, .old, .new], context: &playerStatusContext)

            previewLayer = AVPlayerLayer(player: player)
            previewLayer?.frame = self.view.frame
            self.view.layer.addSublayer(previewLayer!)
        }
    }
    
    private func addObservers() {
        playerwIsReadyForDisplayItemObserver = previewLayer?.observe(\.isReadyForDisplay, options:  [.new, .old], changeHandler: { /*[weak self]*/ player, _ in
            print("self isReadyForDisplay value changed: \(player.isReadyForDisplay)")
        })
    }
    
    func setUpSlider() {
        slider = TvOSSlider(frame: CGRect(x: 50, y: self.view.frame.height - 120, width: self.view.frame.width - 100, height: 100))
        self.view.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueChanges), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.stepValue = 10
        slider.minimumTrackTintColor = .orange
        
        valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        valueLabel.textAlignment = .center
        valueLabel.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.view.addSubview(valueLabel)
    }
    
    @objc
    func sliderValueChanges(slider: TvOSSlider) {
        var date = Date()
        date.addTimeInterval(TimeInterval(-slider.value * 10))
        self.previewLayer?.player?.seek(to: date)
        valueLabel.text = "Will seek to \(date)"
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &playerItemStatusContext || context == &playerContext || context == &playerStatusContext else {
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
        if context == &playerItemStatusContext {
            if keyPath == #keyPath(AVPlayerItem.status) {
                let status: AVPlayerItem.Status
                
                // Get the status change from the change dictionary
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                
                // Switch over the status
                switch status {
                case .readyToPlay:
                    print("Player item is ready to play.")
                case .failed:
                    print("Player item failed. See error.")
                case .unknown:
                    print("Player item is not yet ready.")
                @unknown default:
                    ()
                }
            }
        }
        else if context == &playerContext {
            if keyPath == #keyPath(AVPlayer.rate) {
                let rate = change?[.newKey] as? Float
                
                if let rate = rate {
                    print("Player, rate changed to: \(rate)")
                }
                else {
                    print("Player, no rate found")
                }
            }
        }
        else if context == &playerStatusContext {
            if keyPath == #keyPath(AVPlayer.status) {
                let status: AVPlayer.Status
                
                // Get the status change from the change dictionary
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayer.Status(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                
                // Switch over the status
                switch status {
                case .readyToPlay:
                    print("Player is ready to play")
                case .failed:
                    print("Player failed. See error.")
                case .unknown:
                    print("Player is not yet ready.")
                @unknown default:
                    ()
                }
            }
        }
    }
}

