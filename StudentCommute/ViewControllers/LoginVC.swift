 
import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var password: UITextField!



    override func viewDidLoad() {
        super.viewDidLoad()

        let alreadyHaveAccountLabel = view.viewWithTag(11) as! ClickableLabel

        let text = "Don't have an account? SignUp"

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: AppColors.primary, range: NSRange(location: text.count - 7, length: 7))
        alreadyHaveAccountLabel.attributedText = attributedString
        alreadyHaveAccountLabel.isUserInteractionEnabled = true
        alreadyHaveAccountLabel.onClick = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
         }
    }
//
    @IBAction func onLogin(_ sender: Any) {
 
        
        if(!isValidEmail(testStr: email.text!)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return
        }
        
       
        if(self.password.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
             return
        }
        
        
        CoreDataManager.shared.login(email: email.text!, password: self.password.text!)
    }
 
        
    @IBAction func onLockUnlock(_ sender: Any) {
       
               setLockImage()
    }
       
    func setLockImage() {
        
        self.password.isSecureTextEntry =  !self.password.isSecureTextEntry
        
        if(self.password.isSecureTextEntry) {
            self.lockButton.setImage(UIImage(systemName: "lock"), for: .normal)
        }else {
            self.lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
        }
    }
    
}




 
