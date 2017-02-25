//
//  CoreDataHelper.swift
//  SiriTranscriber
//
//  Created by Jason Crawford on 2/24/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    
    init() {
        let container = NSPersistentContainer(name: "SiriTranscriber")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("DAX: \(error)")
            } else {
                print("DAX: Core data Fine!")
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeTranscription(audioFileUrlString: String, textFileUrlString: String) {
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Transcription", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        transc.setValue(audioFileUrlString, forKey: "audioFileUrlString")
        transc.setValue(textFileUrlString, forKey: "textFileUrlString")
        
        do {
            try context.save()
            print("DAX: Saved")
        } catch {
            
        }
        
    }
    
    func getTranscriptions() -> [NSManagedObject]? {
        
        let fetchRequest: NSFetchRequest<Transcription> = Transcription.fetchRequest()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            print("DAX: Number of Results = \(searchResults.count)")
            
            for trans in searchResults as [NSManagedObject] {
                print("DAX Result: \(trans.value(forKey: "audioFileUrlString"))")
                
            }
            return searchResults as [NSManagedObject]
        } catch {
            return nil
        }
    }
}







