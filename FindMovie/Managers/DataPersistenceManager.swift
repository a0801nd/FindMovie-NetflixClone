import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    
    static let shared = DataPersistanceManager()
    
    func downloadTitleWith(model: TitleM, completion: @escaping (Result<Void,Error>) -> Void) {
        // Используя `@escaping`, замыкание явно объявляется как замыкание, что позволяет вызывающей функции `downloadTitleWith` обрабатывать завершение асинхронно, например, выполнять дальнейшие действия или обновлять пользовательский интерфейс, когда загрузка завершена или возникла ошибка.
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.vote_count = Int64(model.vote_count)
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func fetchingTitlesFromDatabase(completion: @escaping (Result<[TitleItem],Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func deleteItemsWith(model: TitleItem, completion: @escaping (Result<Void,Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDeleteData))
        }
    }
    
}
