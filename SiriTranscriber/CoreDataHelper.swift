//
//  CoreDataHelper.swift
//  SiriTranscriber
//
//  Created by Jason Crawford on 2/24/17.
//  Copyright © 2017 Jason Crawford. All rights reserved.
//

import Foundation
import CoreData

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
}
