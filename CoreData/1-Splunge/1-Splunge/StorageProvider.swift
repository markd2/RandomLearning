import Foundation
import CoreData
import UIKit

class StorageProvider {
    let persistentContainer: NSPersistentContainer
    static var shared = StorageProvider()
    
    init() {
        ValueTransformer.setValueTransformer(
          UIImageTransformer(),
          forName: NSValueTransformerName("UIImageTransformer"))
        persistentContainer = NSPersistentContainer(name: "Splunge")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Store failed to load with error: \(error)")
            }
        }
    }
    
    func saveMovie(named name: String) {
        let movie = Movie(context: persistentContainer.viewContext)
        movie.title = name
        
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

class UIImageTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(
              withRootObject: image,
              requiringSecureCoding: true)
            return data
        } catch {
            print("error transforming image: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        do {
            let image = try NSKeyedUnarchiver.unarchivedObject(
              ofClass: UIImage.self, from: data)
            return image
        } catch {
            print("error gnimrofsnart image: \(error)")
            return nil
        }
    }
}
