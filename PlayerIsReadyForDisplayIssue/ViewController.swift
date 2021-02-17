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

class ViewController: UIViewController {
    
    /* normal stream play URL*/
//    let link = "https://fra3-1-hls7-live.zahs.tv/HD_itv1/master.m3u8?z32=OVZWK4S7NFSD2MRVG43TONBTHETGC5LENFXV6Y3PMRSWG4Z5MFQWGLDFMFRTGJTMNQ6TCJTNNFXHEYLUMU6TSMBQEZ2GS3LFONUGSZTUHUZTMMBQEZWWC6DSMF2GKPJQEZZWSZZ5MMYTKZLFGRSTIMRRGNRGCMRSHFSGMNZSGQ4GIZTBHBQTQZJVGI2SMY3TNFSD2MJWGY2DQMKGIQ3DINBSGFBUCNJNGQYDQNRTHFBEGNRVGA3UMQRUIYTGS3TJORUWC3DSMF2GKPJQ"
    
    /* trick play URL*/
    let link = "https://fra3-1-hls7-live.zahs.tv/HD_itv1/t_track_trick_bw_4800_num_0_tid_5_nd_4000_mbr_5000.m3u8?z32=MNZWSZB5GE3DMNBYGFDEINRUGQZDCQ2BGUWTIMBYGYZTSQSDGY2TAN2GII2EMJTUNFWWK43INFTHIPJTGYYDAJTVONSXEX3JMQ6TENJXG43TIMZZEZ3D2MBGONUWOPJZL42DCMTFGE3DSMRUMUYTQNZTMVRTQNRZME2DSMZZME4TKN3EGA4GE"
    
    var previewLayer: AVPlayerLayer?
    private var playerwIsReadyForDisplayItemObserver: NSKeyValueObservation?
    
    private var slider: TvOSSlider!
    private var valueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpPlayer(link: link)
        addObservers()
        previewLayer?.player?.pause()
        setUpSlider()
    }
    
    private func setUpPlayer(link: String) {
        if let playerURL = URL.init(string: link) {
            let avplayer = AVPlayer(playerItem: AVPlayerItem(url: playerURL))
            previewLayer = AVPlayerLayer(player: avplayer)
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
        self.view.addSubview(valueLabel)
    }
    
    @objc
    func sliderValueChanges(slider: TvOSSlider) {
        var date = Date()
        date.addTimeInterval(TimeInterval(-slider.value * 10))
        self.previewLayer?.player?.seek(to: date)
        valueLabel.text = "Will seek to \(date)"
    }
    
}

