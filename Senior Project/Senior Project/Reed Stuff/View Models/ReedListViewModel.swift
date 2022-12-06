//
//  ReedListViewModel.swift
//  Senior Project
//
//  Created by Michał Cieslik on 10/17/22.
//

import Foundation
import CoreData
import SwiftUI

// The View Model class for the list of Reeds, handling fethces, and updating lists. Stores the
//    non-core data list of reeds.
class ReedListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate{
    private (set) var context: NSManagedObjectContext
    
    enum FilterType: Int, Equatable, CaseIterable {
        case all = -1
        case blanks = 0
        case scraped = 1
        case finished = 2
        case destroyed = 3
    }
    
    // Array of @Published Reed objects that's accesible by the view
    @Published var reeds = [Reed]()
    
    @Published var filter: FilterType = FilterType.all
    
    var filteredReeds: [Reed]{
        switch filter {
            case .all:
                return reeds
            case .blanks:
                return reeds.filter { $0.reedStage == 0 }
            case .scraped:
                return reeds.filter { $0.reedStage == 1 }
            case .finished:
                return reeds.filter { $0.reedStage == 2 }
            case .destroyed:
                return reeds.filter { $0.reedStage == 3 }
            }
    }
    
    private let reedFetchedResultsController: NSFetchedResultsController<Reed>
    
    convenience init(context: NSManagedObjectContext){
        self.init(context: context, fetchRequest: Reed.all)
    }
    
    init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Reed>){
        self.context = context
        
        reedFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        reedFetchedResultsController.delegate = self
        
        do{
            try reedFetchedResultsController.performFetch()
            guard let reeds = reedFetchedResultsController.fetchedObjects else {
                return
            }
            
            self.reeds = reeds
        } catch {
            print(error)
        }
    }
    
    func deleteReed(reedID: NSManagedObjectID){
        do {
            guard let reed = try context.existingObject(with: reedID) as? Reed else{
                return
            }
            context.delete(reed)
            try? context.save()
        } catch {
            print(error)
        }
    }
    
    // Runs when something in the Core Data storage changes, and updates the reed array for the view
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let reeds = controller.fetchedObjects as? [Reed] else {
            return
        }
        
        self.reeds = reeds
    }
}

