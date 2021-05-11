//
//  ViewController3.swift
//  Note Float
//
//  Created by chicken nugget on 9/7/19.
//  Copyright © 2019 chicken nugget. All rights reserved.
//

import UIKit
import AVFoundation

/* Starting Notes */
class ViewController3: UIViewController {
    
    var player : AVAudioPlayer!
    var item : AVPlayerItem!

    let notePaths = [
        Bundle.main.path(forResource: "C", ofType: "mp3"),      // 0
        Bundle.main.path(forResource: "C#:Db", ofType: "mp3"),  // 1
        Bundle.main.path(forResource: "D", ofType: "mp3"),      // 2
        Bundle.main.path(forResource: "D#:Eb", ofType: "mp3"),  // 3
        Bundle.main.path(forResource: "E", ofType: "mp3"),      // 4
        Bundle.main.path(forResource: "F", ofType: "mp3"),      // 5
        Bundle.main.path(forResource: "F#:Gb", ofType: "mp3"),  // 6
        Bundle.main.path(forResource: "G", ofType: "mp3"),      // 7
        Bundle.main.path(forResource: "G#:Ab", ofType: "mp3"),  // 8
        Bundle.main.path(forResource: "A", ofType: "mp3"),      // 9
        Bundle.main.path(forResource: "A#:Bb", ofType: "mp3"),  // 10
        Bundle.main.path(forResource: "B", ofType: "mp3")       // 11
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonSound(_sender: UIButton) {
        
        // Check note
        let tag = _sender.tag
        
        do {
            player = AVAudioPlayer()
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: notePaths[tag]!))
            player.play()
        }
        catch {
            print(error)
        }
    }
}
