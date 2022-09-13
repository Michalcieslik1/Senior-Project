//
//  DataController.swift
//  Senior Project
//
//  Created by Michał Cieslik on 9/13/22.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "ReedModel")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error{
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
        }
    }
}