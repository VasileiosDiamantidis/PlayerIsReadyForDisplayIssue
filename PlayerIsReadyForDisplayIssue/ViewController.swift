//
//  ViewController.swift
//  PlayerIsReadyForDisplayIssue
//
//  Created by Vasileios on 17.02.21.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: AVPlayerViewController {
    
//    let link = "https://fra3-1-hls7-live.zahs.tv/HD_itv1/master.m3u8?z32=OVZWK4S7NFSD2MRVG43TONBTHETGC5LENFXV6Y3PMRSWG4Z5MFQWGLDFMFRTGJTMNQ6TCJTNNFXHEYLUMU6TSMBQEZ2GS3LFONUGSZTUHUZTMMBQEZWWC6DSMF2GKPJQEZZWSZZ5MMYTKZLFGRSTIMRRGNRGCMRSHFSGMNZSGQ4GIZTBHBQTQZJVGI2SMY3TNFSD2MJWGY2DQMKGIQ3DINBSGFBUCNJNGQYDQNRTHFBEGNRVGA3UMQRUIYTGS3TJORUWC3DSMF2GKPJQ"
    let previewPlayLink = "https://fra3-1-hls7-live.zahs.tv/HD_itv1/t_track_trick_bw_4800_num_0_tid_5_nd_4000_mbr_5000.m3u8?z32=MNZWSZB5GE3DMNBYGFDEINRUGQZDCQ2BGUWTIMBYGYZTSQSDGY2TAN2GII2EMJTUNFWWK43INFTHIPJTGYYDAJTVONSXEX3JMQ6TENJXG43TIMZZEZ3D2MBGONUWOPJZL42DCMTFGE3DSMRUMUYTQNZTMVRTQNRZME2DSMZZME4TKN3EGA4GE"
    
    var previewPlayer: AVPlayer?
    var previewLayer: AVPlayerLayer?
    
//    private var previewIsReadyForDisplayItemObserver: NSKeyValueObservation?
    private var playerwIsReadyForDisplayItemObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpPlayer(link: previewPlayLink /*, previewPlayLink: previewPlayLink*/)
        addObservers()
        player?.play()
    }
    
    private func setUpPlayer(link: String/*, previewPlayLink: String*/) {
        
        if let playerURL = URL.init(string: link) {
            let avplayer = AVPlayer(playerItem: AVPlayerItem(url: playerURL))
            self.player = avplayer
        }
        
//        if let previewPlayerURL = URL.init(string: previewPlayLink) {
//            let previewPlayer = AVPlayer(playerItem: AVPlayerItem(url: previewPlayerURL))
//            guard let previewView = self.view else { return }
//            previewLayer = AVPlayerLayer(player: previewPlayer)
//            previewLayer!.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
//            previewView.layer.addSublayer(previewLayer!)
//            previewPlayer.pause()
//        }
    }
    
    private func addObservers() {
//        previewIsReadyForDisplayItemObserver = previewLayer?.observe(\.isReadyForDisplay, options:  [.new, .old], changeHandler: { /*[weak self]*/ player, _ in
//            print("previewLayer isReadyForDisplay value changed: \(player.isReadyForDisplay)")
//        })
        
        playerwIsReadyForDisplayItemObserver = self.observe(\.isReadyForDisplay, options:  [.new, .old], changeHandler: { /*[weak self]*/ player, _ in
            print("self isReadyForDisplay value changed: \(player.isReadyForDisplay)")
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        print(#function)
        if let player = (object as? AVPlayer) {
            DispatchQueue.main.async {
                [weak self] in
                self?.setNeedsFocusUpdate()
                self?.updateFocusIfNeeded()

                guard let self = self, player.status == .readyToPlay else {
                    print("player.status != .readyToPlay => \(player.status)")
                    return
                }

                self.setNeedsFocusUpdate()
                self.updateFocusIfNeeded()
            }
        }
    }
}

