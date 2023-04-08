 
import UIKit

class HomeVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        
        fromTF.delegate = self
        toTF.delegate = self
     
        // Add a tap gesture recognizer to the text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fromTapped))
        fromTF.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(toTapped))
        toTF.addGestureRecognizer(tapGesture2)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.name.text = CoreDataManager.shared.getCurrentUser()!.name
    }
    
    
    // Implement UITextFieldDelegate method to disallow editing
      func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          return false
      }
    
    
    @objc func fromTapped() {
           
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationSelectorVC") as! LocationSelectorVC
        self.navigationController?.pushViewController(vc, animated: true)
       // open MAP
    }
    
    @objc func toTapped() {
       // open Map
    }
    
    func resetFields() {
        self.fromTF.text = ""
        self.toTF.text = ""
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        
        
        if(self.fromTF.text!.isEmpty) {
            showAlert(message: "Please enter starting point")
            return
        }
        
        if(self.fromTF.text!.isEmpty) {
            showAlert(message: "Please enter destination point")
            return
        }
        
        self.resetFields()
    }
}
