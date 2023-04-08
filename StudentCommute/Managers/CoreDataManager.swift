import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StudentCommute")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    
    func isAlreadyRegister(_ email: String) -> Bool {
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                let count = try persistentContainer.viewContext.count(for: fetchRequest)
                return count > 0
            } catch {
                print("Error checking if email is already saved. Error: \(error)")
                return false
            }
        }
    
    func signUp(name: String, email: String, password: String, userType: String){
        
        let email = email.lowercased()
        
        if(isAlreadyRegister(email)) {
            showAlertAnyWhere(message: "Email Already Registered")
            return
        }
        
        let managedContext = persistentContainer.viewContext
        
        let user = User(context: managedContext)
        user.name = name
        user.email = email
        user.password = password
        user.userType = userType
        
        do {
            try managedContext.save()
            showOkAlertAnyWhereWithCallBack(message: "Registered") {
                SceneDelegate.shared?.checkLogin()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func login(email: String, password: String) {
        
            let email = email.lowercased()
        
            let managedContext = persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                let users = try managedContext.fetch(fetchRequest)
                guard let user = users.first else {
                    showAlertAnyWhere(message: "Email not found")
                    return
                }
                if user.password == password {
                    UserDefaultsManager.shared.saveData(email: user.email!, userType: user.userType!)
                    SceneDelegate.shared?.checkLogin()
                } else {
                    showAlertAnyWhere(message: "Password does not match")
                    return
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return
            }
        }
        
    
    func updateUser(_ user: User)  {
        let managedContext = persistentContainer.viewContext
        
        do {
            try managedContext.save()
            showAlertAnyWhere(message: "Updated")
        } catch let error as NSError {
           print(error)
        }
    }
    
    func getCurrentUser() -> User? {
        
       let email = UserDefaultsManager.shared.getEmail().lowercased()
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
     
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            return users.first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
       
        
        
    }
    
    func clearDatabase() {
            for entityName in persistentContainer.managedObjectModel.entities.map({ $0.name! }) {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try persistentContainer.viewContext.execute(batchDeleteRequest)
                    print("\(entityName) table cleared successfully.")
                } catch {
                    print("Failed to clear \(entityName) table. Error: \(error)")
                }
            }
        }
        
}

 
