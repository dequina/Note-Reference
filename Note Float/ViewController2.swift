//
//  ViewController2.swift
//  Note Float
//
//  Created by chicken nugget on 9/7/19.
//  Copyright © 2019 chicken nugget. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer



/* Short Scales */
class ViewController2: UIViewController {

    /* INSTANCE VARS */
    var player : AVAudioPlayer!
    var qPlayer : AVQueuePlayer!
    
    @IBOutlet weak var majmin: UISegmentedControl!
    @IBOutlet weak var direction: UISegmentedControl!
    
    var isMinor = false
    var dir = 0
    
    /* CONSTANTS */
    let asc = 0
    let desc = 1
    let both = 2
    
    let scalePaths = [
        Bundle.main.path(forResource: "C maj", ofType: "mp3"),      // 0
        Bundle.main.path(forResource: "C#:Db maj", ofType: "mp3"),  // 1
        Bundle.main.path(forResource: "D maj", ofType: "mp3"),      // 2
        Bundle.main.path(forResource: "D#:Eb maj", ofType: "mp3"),  // 3
        Bundle.main.path(forResource: "E maj", ofType: "mp3"),      // 4
        Bundle.main.path(forResource: "F maj", ofType: "mp3"),      // 5
        Bundle.main.path(forResource: "F#:Gb maj", ofType: "mp3"),  // 6
        Bundle.main.path(forResource: "G maj", ofType: "mp3"),      // 7
        Bundle.main.path(forResource: "G#:Ab maj", ofType: "mp3"),  // 8
        Bundle.main.path(forResource: "A maj", ofType: "mp3"),      // 9
        Bundle.main.path(forResource: "A#:Bb maj", ofType: "mp3"),  // 10
        Bundle.main.path(forResource: "B maj", ofType: "mp3"),      // 11
        Bundle.main.path(forResource: "C maj2", ofType: "mp3"),     // 12
        
        Bundle.main.path(forResource: "C min", ofType: "mp3"),      // 13
        Bundle.main.path(forResource: "C#:Db min", ofType: "mp3"),  // 14
        Bundle.main.path(forResource: "D min", ofType: "mp3"),      // 15
        Bundle.main.path(forResource: "D#:Eb min", ofType: "mp3"),  // 16
        Bundle.main.path(forResource: "E min", ofType: "mp3"),      // 17
        Bundle.main.path(forResource: "F min", ofType: "mp3"),      // 18
        Bundle.main.path(forResource: "F#:Gb min", ofType: "mp3"),  // 19
        Bundle.main.path(forResource: "G min", ofType: "mp3"),      // 20
        Bundle.main.path(forResource: "G#:Ab min", ofType: "mp3"),  // 21
        Bundle.main.path(forResource: "A min", ofType: "mp3"),      // 22
        Bundle.main.path(forResource: "A#:Bb min", ofType: "mp3"),  // 23
        Bundle.main.path(forResource: "B min", ofType: "mp3"),      // 24
        Bundle.main.path(forResource: "C min2", ofType: "mp3")      // 25
    ]
    
    let scales = ["C major", "C#:Db major", "D major", "D#:Eb major",
                  "E major", "F major", "F#:Gb major", "G major",
                  "G#:Ab major", "A major", "A#:Bb major", "B major", "C major",
                  
                  "C minor", "C#:Db minor", "D minor", "D#:Eb minor",
                  "E minor", "F minor", "F#:Gb minor", "G minor",
                  "G#:Ab minor", "A minor", "A#:Bb minor", "B minor", "C minor", "All Scales"
    ]
    
    /* FUNCTIONS */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupRemoteTransportControls(play: Int) {
        
        // Set up center
        let center = MPRemoteCommandCenter.shared()
        
        // Stuff not needed
        [center.stopCommand, center.bookmarkCommand, center.changePlaybackPositionCommand,
         center.changePlaybackRateCommand, center.changeRepeatModeCommand,
         center.changeShuffleModeCommand, center.ratingCommand, 
         center.disableLanguageOptionCommand, center.dislikeCommand, center.likeCommand,
         center.nextTrackCommand, center.seekBackwardCommand, center.skipBackwardCommand,
         center.seekForwardCommand, center.skipForwardCommand].forEach { $0.isEnabled = false}
        
        center.playCommand.isEnabled = true
        center.pauseCommand.isEnabled = true
        
        // Set up play for control center
        center.playCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            switch (play) {
                case 0:
                    if self.player != nil && !self.player.isPlaying {
                        self.player.play()
                    }
                case 1:
                    if self.player != nil {
                        self.player.pause()
                        self.player.volume = 0
                    }
                    if self.qPlayer != nil && self.qPlayer.rate == 0 {
                        self.qPlayer.play()
                    }
                default: ()
            }
            return MPRemoteCommandHandlerStatus.success
        }
        
        // Set up pause for remote center
        center.pauseCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            switch (play) {
                case 0:
                    if self.player != nil && self.player.isPlaying {
                        self.player.pause()
                    }
                case 1:
                    if self.qPlayer != nil && self.qPlayer.rate > 0 {
                        self.qPlayer.pause()
                    }
                default: ()
            }
            return MPRemoteCommandHandlerStatus.success
        }
    }
    
    // Set up display for remote center
    func setupNowPlaying(play: Int, scaleInd: Int) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Short Scales: \(scales[scaleInd])"
        
        if let image = UIImage(named: "nice.png") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
    
            if play == 0 {
                if player != nil {
                    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
                }
            } else {
                if qPlayer != nil {
                    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = qPlayer.rate
                }
        }
    
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    @IBAction func buttonSound(_sender: UIButton) {
        
        // Stop all current scales playing, reset all
        stop(_sender: _sender)
        player = nil
        qPlayer = nil
        
        // Check which scales
        let tag = _sender.tag
        
        // Check if major/minor indices
        var minIndex = 0
        if isMinor {
            minIndex = 13
        }
        
        // If single scale is played
        if tag != 12 {
            do {
                player = AVAudioPlayer()
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: scalePaths[tag + minIndex]!))
                setupNowPlaying(play: 0, scaleInd: (tag + minIndex))
                setupRemoteTransportControls(play: 0)
                player.play()
            }
            catch {
                print(error)
            }
        
        // If all of them should be played
        } else {
            qPlayer = AVQueuePlayer()
            var count =  1
            var count2 = 2
            var limit = 0
            var file : URL!
            
            if dir == desc {
                file = URL(fileURLWithPath: scalePaths[12 + minIndex]!)
            } else {
                file = URL(fileURLWithPath: scalePaths[0 + minIndex]!)
            }
            
            if dir == both {
                limit = 24
            } else {
                limit = 12
            }
            
            var item = AVPlayerItem(url: file)
            qPlayer.insert(item, after: nil)
            
            while count <= limit {
                
                if dir == asc {
                    file = URL(fileURLWithPath: scalePaths[count + minIndex]!)
                } else if dir == desc {
                    file = URL(fileURLWithPath: scalePaths[12 - count + minIndex]!)
                } else {
                    if count > 12 {
                        file = URL(fileURLWithPath: scalePaths[count - count2 + minIndex]!)
                        count2 += 2
                    } else {
                        file = URL(fileURLWithPath: scalePaths[count + minIndex]!)
                    }
                }
                
                item = AVPlayerItem(url: file)
                qPlayer.insert(item, after: nil)
                count += 1
            }
            player = AVAudioPlayer()
            do { player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: scalePaths[tag + minIndex]!)) }
            catch { print(error)}
            setupNowPlaying(play: 0, scaleInd: 26)
            setupRemoteTransportControls(play: 0)
            setupNowPlaying(play: 1, scaleInd: 26)
            setupRemoteTransportControls(play: 1)
            qPlayer.play()
        }
    }
    
    // Stop all sounds
    @IBAction func stop(_sender: Any) {
        if player != nil && player.isPlaying {
            player.stop()
        }
        
        if qPlayer != nil && qPlayer.rate > 0 {
            qPlayer.removeAllItems()
        }
    }
    
    // Major/minor segment
    @IBAction func majorMinor(_sender: Any) {
        switch majmin.selectedSegmentIndex {
            case 0: isMinor = false
            case 1: isMinor = true
            default: ()
        }
    }
    
    // Scale direction segment
    @IBAction func scaleDirection(_sender: Any) {
        switch direction.selectedSegmentIndex {
            case asc: dir = 0
            case desc: dir = 1
            case both: dir = 2
            default: ()
        }
    }
    
    @IBAction func cease(_sender: Any) {
        if player != nil {
            player = nil
        }
        if qPlayer != nil {
            qPlayer = nil
        }
    }
}
