 
import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var loginType: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    var user =  CoreDataManager.shared.getCurrentUser()!
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.borderWidth = 1.0
            userImageView.layer.borderColor = AppColors.primary.cgColor
        }
    }
    
    @IBAction func onEdit(_ sender: Any) {
        
        self.showEditTextAlert(placeHolder: "Enter Name", preString: self.name.text!) { [self] name in
            
            var user = self.user
            user.name = name
            self.user = user
            
            CoreDataManager.shared.updateUser(user)
            self.name.text = name
            
        }
    }
    
    override func viewDidLoad() {
         
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width/2
        self.name.text =  self.user.name
        self.email.text = self.user.email
        
        if( UserDefaultsManager.shared.getUserType() == .USER) {
            self.loginType.text = "Welcome User"
        }else {
            self.loginType.text = "Welcome Rider"
        }
       
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        UserDefaultsManager.shared.clearUserDefaults()
        CoreDataManager.shared.clearDatabase()
        SceneDelegate.shared!.checkLogin()
    }
    
}
