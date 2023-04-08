 
import Foundation

class UserDefaultsManager  {
    
    static  let shared =  UserDefaultsManager()
     
    func clearUserDefaults() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()

            dictionary.keys.forEach
            {
                key in   defaults.removeObject(forKey: key)
            }
    }
    
    func isLoggedIn() -> Bool{
        
        let email = getEmail()
        
        if(email.isEmpty) {
            return false
        }else {
           return true
        }
      
    }
     
    func getEmail()-> String {
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        
        print(email)
        return email
    }
    
   
 
    func getUserType()-> UserType {
        if(UserDefaults.standard.string(forKey: "userType") == UserType.USER.rawValue)  {
            return .USER
        }else {
            return .RIDER
        }
    }

    
    
    func saveData(email:String,userType:String) {
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(userType, forKey: "userType")
     
    }
  
    
}
