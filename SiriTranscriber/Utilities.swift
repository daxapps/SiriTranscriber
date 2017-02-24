//
//  Utilities.swift
//  SiriTranscriber
//
//  Created by Jason Crawford on 2/24/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import Foundation
import AVFoundation
import Speech

class Utilities {
    
    var DateTimeString: String?
    
    func getDocsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        return docsDirect
    }
    
    func getAudioFileUrl() -> URL? {
        do {
            let audioUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".m4a")
            return audioUrl
            
        } catch _ {
            return nil
        }
    }
    
    func getTextFileUrl() -> URL? {
        do {
            let textUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".txt")
            return textUrl
            
        } catch _ {
            return nil
        }
    }
    
    func getDateAndTime() -> String {
        
        if let dateT = DateTimeString {
            return dateT
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let timeString = formatter.string(from: date)
        return timeString
        
    }
}
