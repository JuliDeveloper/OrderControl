//
//  StorageManager.swift
//  ОrderСontrol
//
//  Created by Julia Romanenko on 24.08.2022.
//

import UIKit
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    lazy var context = StorageManager.shared.persistentContainer.viewContext
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OrderControl")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    // Описание сущности
    func entityForName(entityName: String) -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
    
    // Извление записей
    func fetchCustomer(_ completion: (Result<[Customer], Error>) -> Void) {
        let fetchRequest = Customer.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            completion(.success(results))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchServise(_ completion: (Result<[Service], Error>) -> Void) {
        let fetchRequest = Service.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            completion(.success(results))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchDocuments(_ completion: (Result<[Order], Error>) -> Void) {
        let fetchRequest = Order.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            completion(.success(result))
        } catch let error {
            completion(.failure(error))
        }
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addDocument(customer: Customer,
                     customerName: String,
                     made: Bool, paid: Bool,
                     datePicker: UIDatePicker) {
        let document = Order(context: context)
        document.customer = customer
        document.customer?.name = customerName
        document.date = datePicker.date
        document.made = made
        document.paid = made
        
        saveContext()
    }
    
    func editDocument(document: Order,
                      newCustomer: Customer,
                      newCustomerName: String,
                      newMade: Bool,
                      newPaid: Bool) {
        document.customer = newCustomer
        document.customer?.name = newCustomerName
        document.made = newMade
        document.paid = newPaid
        
        saveContext()
    }
    
    func deleteObject(object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }

    private init() {}
}
