//
//  ViewController.swift
//  Note Float
//
//  Created by chicken nugget on 9/7/19.
//  Copyright © 2019 chicken nugget. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class player : NSObject {
    static let shared = player()
    var aPlayer : AVAudioPlayer!
    var qPlayer : AVQueuePlayer!
}

var once = false
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !once {
            makeAlert(title: "Before you use!", message: "Remember to unmute your device!")
         once = true
        }
    }
    
    // Warn of low memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func makeAlert(title: String, message: String) {
        
        // Creating the alert
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        // Adding the OK button to close alert
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                      handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
}

