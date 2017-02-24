//
//  ViewController.swift
//  SiriTranscriber
//
//  Created by Jason Crawford on 2/24/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var permissionLbl: UILabel!
    @IBOutlet weak var permissionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //bubbles through to transcribe permissions
    func requestRecordPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission() {
            [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    //get transcription permissions
                    self.requestTranscribePermissions()
                } else {
                    //error
                    self.showError()
                }
            }
        }
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization
            { [unowned self] authStatus in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        //great good to go!
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        //error handling
                        self.showError()
                    }
                }
        }
        
    }
    
    func showError() {
        self.permissionLbl.text = "You have previously denied this app access to speech recognition. Please change in settings and restart the app."
        self.disableButton()
    }
    
    func disableButton() {
        self.permissionBtn.isEnabled = false
        UIView.animate(withDuration: 1.0) {
            self.permissionBtn.alpha = 0.3
        }        
    }

    @IBAction func permissionBtnTapped(_ sender: UIButton) {
        requestTranscribePermissions()
    }

}

