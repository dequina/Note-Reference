//
//  ViewController4.swift
//  Note Float
//
//  Created by chicken nugget on 9/7/19.
//  Copyright © 2019 chicken nugget. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

/* Intervals */
class ViewController4: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

   
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var booton: UIButton!
    
    var player : AVAudioPlayer!
    var interval = 0
    
    /* CONSTANTS */
    let pickerData = [
        ["Major", "Minor", "Perfect", "Augmented", "Diminished"],
        ["Unison", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Octave"]]
    
    let images = [
        UIImage(named: "perf uni.png"),    // 0
        UIImage(named: "min 2nd.png"),     // 1
        UIImage(named: "maj 2nd.png"),     // 2
        UIImage(named: "aug 2nd.png"),     // 3
        UIImage(named: "min 3rd.png"),     // 4
        UIImage(named: "maj 3rd.png"),     // 5
        UIImage(named: "perf 4th.png"),    // 6
        UIImage(named: "aug 4thpng"),      // 7
        UIImage(named: "dim 5th.png"),     // 8
        UIImage(named: "perf 5th.png"),    // 9
        UIImage(named: "aug 5th.png"),     // 10
        UIImage(named: "min 6th.png"),     // 11
        UIImage(named: "maj 6th.png"),     // 12
        UIImage(named: "aug 6th.png"),     // 13
        UIImage(named: "min 7th.png"),     // 14
        UIImage(named: "maj 7th.png"),     // 15
        UIImage(named: "perf 8th.png"),    // 16
        UIImage(named: "none.png")         // 17
    ]
    
    let intPaths = [
        Bundle.main.path(forResource: "perf uni", ofType: "mp3"),      // 0
        Bundle.main.path(forResource: "min 2nd", ofType: "mp3"),       // 1
        Bundle.main.path(forResource: "maj 2nd", ofType: "mp3"),       // 2
        Bundle.main.path(forResource: "min 3rd", ofType: "mp3"),       // 3
        Bundle.main.path(forResource: "maj 3rd", ofType: "mp3"),       // 4
        Bundle.main.path(forResource: "perf 4th", ofType: "mp3"),      // 5
        Bundle.main.path(forResource: "tritone", ofType: "mp3"),       // 6
        Bundle.main.path(forResource: "perf 5th", ofType: "mp3"),      // 7
        Bundle.main.path(forResource: "min 6th", ofType: "mp3"),       // 8
        Bundle.main.path(forResource: "maj 6th", ofType: "mp3"),       // 9
        Bundle.main.path(forResource: "min 7th", ofType: "mp3"),       // 10
        Bundle.main.path(forResource: "maj 7th", ofType: "mp3"),       // 11
        Bundle.main.path(forResource: "perf oct", ofType: "mp3"),      // 12

    ]

    /* FUNCTIONS */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func setupRemoteTransportControls() {
        
        // Set up center
        let center = MPRemoteCommandCenter.shared()
        
        // Stuff not needed
        [center.stopCommand, center.bookmarkCommand, center.changePlaybackPositionCommand,
         center.changePlaybackRateCommand, center.changeRepeatModeCommand,
         center.changeShuffleModeCommand, center.ratingCommand,
         center.disableLanguageOptionCommand, center.dislikeCommand, center.likeCommand,
         center.nextTrackCommand, center.seekBackwardCommand, center.skipBackwardCommand,
         center.seekForwardCommand, center.skipForwardCommand].forEach { $0.isEnabled = false}
        
        // Set up play for control center
        center.playCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
            
            if self.player != nil && !self.player.isPlaying {
                self.player.play()
            }
            return MPRemoteCommandHandlerStatus.success
        }
        
        // Set up pause for remote center
        center.pauseCommand.addTarget { (commandEvent) -> MPRemoteCommandHandlerStatus in
          
                if self.player != nil && self.player.isPlaying {
                    self.player.pause()
                }
            return MPRemoteCommandHandlerStatus.success
        }
    }
    
    // Set up display for remote center
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = """
        Interval: \(pickerData[0] [picker.selectedRow(inComponent: 0)]) \(pickerData[1] [picker.selectedRow(inComponent: 1)])
        """
       
        if let image = img.image {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        if player != nil {
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        }
       
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    @IBAction func play(_sender: Any) {
        do {
            player = AVAudioPlayer()
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: intPaths[interval]!))
            setupNowPlaying()
            setupRemoteTransportControls()
            player.play()
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func stop(_sender: Any) {
        if player != nil && player.isPlaying {
            player.stop()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var num = 5
        if component == 1 {
            num = 8
        }
        return num
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if !booton.isEnabled {
            booton.isEnabled = true
        }
        
        switch picker.selectedRow(inComponent: 0) {
            
            // Major
            case 0:
                switch picker.selectedRow(inComponent: 1) {
                    case 1: img.image = images[2]; interval = 2
                    case 2: img.image = images[5]; interval = 4
                    case 5: img.image = images[12]; interval = 9
                    case 6: img.image = images[15]; interval = 11
                default: img.image = images[17]; booton.isEnabled = false
                }
            
            // Minor
            case 1:
                switch picker.selectedRow(inComponent: 1) {
                    case 1: img.image = images[1]; interval = 1
                    case 2: img.image = images[4]; interval = 3
                    case 5: img.image = images[11]; interval = 8
                    case 6: img.image = images[14]; interval = 10
                default: img.image = images[17]; booton.isEnabled = false
                }
            
            // Perfect
            case 2:
                switch picker.selectedRow(inComponent: 1) {
                    case 0: img.image = images[0]; interval = 0
                    case 3: img.image = images[6]; interval = 5
                    case 4: img.image = images[9]; interval = 7
                    case 7: img.image = images[16]; interval = 12
                default: img.image = images[17]; booton.isEnabled = false
                    
                }
            
            // Augmented
            case 3:
                switch picker.selectedRow(inComponent: 1) {
                case 0: img.image = images[1]; interval = 1
                case 1: img.image = images[3]; interval = 3
                case 2: img.image = images[5]; interval = 5
                case 3: img.image = images[7]; interval = 6
                case 4: img.image = images[10]; interval = 8
                case 5: img.image = images[13]; interval = 10
                case 6: img.image = images[16]; interval = 12
                default: img.image = images[17]; booton.isEnabled = false
                    
                }
            
            // Diminished
            case 4:
                switch picker.selectedRow(inComponent: 1) {
                case 1: img.image = images[0]; interval = 0
                case 2: img.image = images[2]; interval = 2
                case 3: img.image = images[5]; interval = 4
                case 4: img.image = images[8]; interval = 6
                case 5: img.image = images[9]; interval = 7
                case 6: img.image = images[12]; interval = 9
                case 7: img.image = images[15]; interval = 11
                default: img.image = images[17]; booton.isEnabled = false
                    
                }
            
            default: ()
        }
    }

    @IBAction func cease(_sender: Any) {
        if player != nil {
            player = nil
        }
    }

}
