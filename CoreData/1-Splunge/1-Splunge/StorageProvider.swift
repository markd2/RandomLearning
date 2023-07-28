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

extension StorageProvider {
    func getAllMovies() -> [Movie] {
        let fetchRequest = Movie.fetchRequest() // NSFetchRequest<Movie>
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        persistentContainer.viewContext.delete(movie)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("failed to save after deleting: \(error)")
        }
    }
    
    func updateMovies() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("failed to save after updating: \(error)")
        }
    }
}

