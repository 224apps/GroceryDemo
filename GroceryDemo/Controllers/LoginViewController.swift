//
//  ViewController.swift
//  GroceryDemo
//
//  Created by Abdoulaye Diallo on 2/10/18.
//  Copyright © 2018 Abdoulaye Diallo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    let  listIdentifier = "listIdentifier"
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rootRef = Database.database().reference()
        let childRef = Database.database().reference(withPath: "items")
        let itemRef = rootRef.child("items")
        let milkRef = itemRef.child("milk")
        print(rootRef.key)
        print( childRef.key)
        print(itemRef.key)
        print(milkRef.key)
        
        let listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: self.listIdentifier, sender: nil)
            }
        }
        Auth.auth().removeStateDidChangeListener(listener)
    }
    
    
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: loginEmailTextField.text!, password: passwordTextField.text!)
        performSegue(withIdentifier: listIdentifier, sender: nil)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sign Up", message: "Register", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (action) in
            let emailTextField = alert.textFields![0]
            let passwordTextField = alert.textFields![1]
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    if let  errorCode = AuthErrorCode(rawValue: error!._code){
                        switch errorCode{
                            
                        case .emailAlreadyInUse:
                            print( " This email is already in use")
                        case .weakPassword:
                            print("Please provide a strong password")
                        default: print("There is an error")
                        }
                    }
                }
                if user != nil {
                    user?.sendEmailVerification(){ (error) in
                        print( "error:\(String(describing: error?.localizedDescription ))")
                        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
                        self.performSegue(withIdentifier: self.listIdentifier, sender: nil)
                    }
                }
                
            })
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addTextField { (emailText) in emailText.placeholder = " Enter Your Email" }
        alert.addTextField { (passwordText) in
            passwordText.placeholder = "Enter Your Password"
            passwordText.isSecureTextEntry = true
        }
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginEmailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

