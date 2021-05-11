//
//  Database.swift
//  LibraryManagement
//
//  Created by Arda ERSOY on 10.05.2021.
//

import UIKit
import CoreData

class Database {
    
    static let shared = Database()
    
    private var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    func insertBook(book: BookModel, completion: @escaping (Bool) -> Void) {
        guard let context = context else { return completion(false) }
        guard let bookObject = NSEntityDescription.insertNewObject(forEntityName: Keys.init().BOOK_DB, into: context) as? Book else { return completion(false) }
        
        bookObject.isbn = book.ISBN
        bookObject.title = book.title
        bookObject.author = book.author
        bookObject.summary = book.summary
        bookObject.image = book.image
        bookObject.price = book.price
        
        //save()
        completion(true)
    }
    
    func insertVideo(video: VideoModel, completion: @escaping (Bool) -> Void) {
        guard let context = context else { return completion(false) }
        guard let videoObject = NSEntityDescription.insertNewObject(forEntityName: Keys.init().VIDEO_DB, into: context) as? Video else { return completion(false) }
        
        videoObject.name = video.name
        videoObject.director = video.director
        videoObject.url = video.url
        
        save()
        completion(true)
    }
    
    func fetchData<T: NSManagedObject>(entity: String, completion: @escaping ([T]?) -> Void) {
        guard let context = context else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let allBooks = results as? [T] else { return }
            completion(allBooks)

        } catch let error as NSError {
            print("Could not fetch data \(error), \(error.userInfo)")
            completion(nil)
        }
    }
    
    func save() {
        guard let context = context else { return }
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save data \(error), \(error.userInfo)")
        }
    }
    
    func delete(object: Book) {
        guard let context = context else { return }
        
        context.delete(object)
        save()
    }
}