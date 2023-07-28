import Foundation
import CoreData

class StorageProvider {
    let persistentContainer: NSPersistentContainer
    static var shared = StorageProvider()
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Splunge")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Store failed to load with error: \(error)")
            }
        }
    }
    
    func saveMovie(named name: String) {
        let movie = Movie(context: persistentContainer.viewContext)
        movie.name = name
        
        do {
            try persistentContainer.viewContext.save()
            print("saved!")
        } catch {
            persistentContainer.viewContext.rollback()
            print("failed to save mov-ay \(error)")
        }
    }
}

