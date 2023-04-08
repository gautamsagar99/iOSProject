
import CoreData

class UserModel: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var password: String
    @NSManaged var userType: String
}

enum UserType:String {
    case USER = "USER"
    case RIDER = "RIDER"
}


