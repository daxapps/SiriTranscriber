//
//  RecordViewController.swift
//  SiriTranscriber
//
//  Created by Jason Crawford on 2/24/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    
    
    var audioRec: AVAudioRecorder?
    var recFileUrl: URL!
    var textFileUrl: URL!
    
    var transcribed: Bool = false
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let utils = Utilities()
        recFileUrl = utils.getAudioFileUrl()
        textFileUrl = utils.getTextFileUrl()
        
        print("DAX" + recFileUrl!.absoluteString)
        recordAudio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Audio Recording
    
    @IBAction func stopButtonClicked(_ sender: UIButton) {
        stopRecording(sender: sender)
    }
    
    func stopRecording(sender: UIButton) {
        audioRec?.stop()
        sender.titleLabel?.text = "Finished"
        sender.isEnabled = false
        //sender.alpha = 0.2
        activityIndicator.stopAnimating()
        
    }
    
    func recordAudio() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 44100,
                            AVNumberOfChannelsKey: 2,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRec = try AVAudioRecorder(url: recFileUrl, settings: settings)
            audioRec?.delegate = self
            audioRec?.record()
            activityIndicator.startAnimating()
            
            
        } catch let error {
            //failed to record
            print("DAX: failed recording \(error)")
            recordingEnded(success: false)
        }
    }
    
    func recordingEnded(success: Bool) {
        audioRec?.stop()
        if success {
            do {
                //play and transcribe audio
                audioPlayer?.stop()
                audioPlayer = try AVAudioPlayer(contentsOf: recFileUrl)
                audioPlayer?.play()
                transcribeAudio()
                print("DAX: Recording")
            } catch let error {
                print(error)
            }
        }
    }
    
    //MARK: Audio Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recordingEnded(success: false)
        } else {
            recordingEnded(success: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer?.stop()
        if transcribed {
            CoreDataHelper().storeTranscription(audioFileUrlString: String(describing: recFileUrl), textFileUrlString: String(describing: textFileUrl))
        }
    }
    
    // MARK: Transcribe
    func transcribeAudio() {
        let recogniser = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: recFileUrl)
        
        recogniser?.recognitionTask(with: request) {
            [unowned self] (result, error) in
            
            guard let result = result else {
                print("DAX " + String(describing: error!))
                return
            }
            
            if result.isFinal {
                let text = result.bestTranscription.formattedString
                self.textView.text = text
                do {
                    try text.write(to: self.textFileUrl, atomically: true, encoding: String.Encoding.utf8)
                    self.transcribed = true
                } catch {
                    
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
