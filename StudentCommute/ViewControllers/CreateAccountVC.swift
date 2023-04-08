import UIKit


class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var riderButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    var userSelected = true
    
    override func viewDidLoad() {
       super.viewDidLoad()
        self.setRadioButton()
   }
   
    @IBAction func onUser(_ sender: Any) {
        userSelected = true
        setRadioButton()
    }
    
    @IBAction func onRider(_ sender: Any) {
        userSelected = false
        setRadioButton()
    }
    
  
        func setRadioButton() {
            
            self.userButton.layer.cornerRadius = self.userButton.frame.size.height /  2
            self.riderButton.layer.cornerRadius = self.riderButton.frame.size.height /  2
            
            self.userButton.layer.borderWidth = 1
            self.riderButton.layer.borderWidth = 1

            if(userSelected) {
                
                self.userButton.backgroundColor = AppColors.primary
                self.userButton.layer.borderColor = AppColors.primary.cgColor
                self.riderButton.backgroundColor = UIColor.clear
                self.riderButton.layer.borderColor = UIColor.darkGray.cgColor
             
                
            }else {
                self.riderButton.backgroundColor = AppColors.primary
                self.riderButton.layer.borderColor = AppColors.primary.cgColor
                self.userButton.backgroundColor = UIColor.clear
                self.userButton.layer.borderColor = UIColor.darkGray.cgColor
                
            }
        }
 
    func validate() ->Bool {
        
        if(self.name.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter name.")
            return false
        }
        
        
        if(!isValidEmail(testStr: email.text!)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return false
        }
        
       
        if(self.pass.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
             return false
        }
        
        if(self.pass.text! != self.confirmPass.text!) {
             showAlertAnyWhere(message: "Password doesn't match")
             return false
        }
        
        if(self.pass.text!.count < 4 || self.pass.text!.count > 10 ) {
            
            showAlertAnyWhere(message: "Password  length shoud be 4 to 10")
            return false
        }
        
//        if !self.pass.text!.contains(where: { $0.isUppercase }) {
//            showAlertAnyWhere(message: "Password should contain at least one uppercase letter.")
//            return false
//        }
//
        
        
//        if !self.pass.text!.hasSpecialCharacters() {
//           showAlertAnyWhere(message: "Password should contain at least one special character.")
//           return false
//       }
        
        return true
    }
    
    @IBAction func onLockUnlock(_ sender: Any) {

        setLockImage()
    }
    
    @IBAction func onSignup(_ sender: Any) {
        
        
        if(self.validate()) {
            
            CoreDataManager.shared.signUp(name: self.name.text!, email: self.email.text!, password: self.pass.text!, userType: (userSelected ? UserType.USER : UserType.RIDER).rawValue)
            
        }
    }
}



extension CreateAccountVC {


    func setLockImage() {

        self.pass.isSecureTextEntry =  !self.pass.isSecureTextEntry

        if(self.pass.isSecureTextEntry) {
            self.lockButton.setImage(UIImage(systemName: "lock"), for: .normal)
        }else {
            self.lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
        }
    }
    

}
