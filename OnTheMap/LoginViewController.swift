//
//  ViewController.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 25/03/17.
//  Copyright © 2017 otd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    let udacityClient = UdacityClient.singleton()
    let dataSource = DataSource.singleton()
    


   

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activityIndicator.isHidden = true
        initialState()
        subscribeKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    

    @IBAction func Login(_ sender: Any) {
        startActivityIndicator()
        
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!
        {
            
            displayAlert(Errors.UserPassEmpty)
            self.errorState()
        }
        else
        {
            udacityClient.login(emailTextField.text!, password: passwordTextField.text!, completionHandler: { (userKey, error
                ) in self.performUIUpdatesOnMain {
                    guard let userKey = userKey else
                    {
                        self.displayAlert("User not found")
                        self.errorState()
                        return
                    }
                    
                    self.getStudent(userKey)
                }
                
            })
        }
        
 
    }
    
    @IBAction func signUp(_ sender : Any)
    {
        if let signUpURL = URL(string: UdacityClient.SignUp.SignUpURL)
        {
            UIApplication.shared.open(signUpURL, options: [:], completionHandler: nil)
        }
    }
    
    func getStudent(_ userKey : String)
    {
        udacityClient.getStudentDetails(userKey) { (student, error) in self.performUIUpdatesOnMain {
         guard let student = student else
         {
           self.displayAlert("Student not found")
            self.initialState()
            return
            }
            self.dataSource.studentLoggedIn = student
            self.login()
            
            }
            
        }
    }
    func login()
    {
        performSegue(withIdentifier: "login", sender: self)
    }
    
    func startActivityIndicator()
    {
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        signInButton.isEnabled = false
        signUpButton.isEnabled = false
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
        
      
    }
    func initialState()  {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        signInButton.isEnabled = true
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        signUpButton.isEnabled = true
        emailTextField.text=""
        passwordTextField.text=""
        
    }
    func errorState()  {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        signInButton.isEnabled = true
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        signUpButton.isEnabled = true
        
        
    }
    fileprivate func displayAlert(_ error: String) {
      
        let alertView = UIAlertController(title: "Login Error", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    func subscribeKeyboardNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    func keyboardWillShow(notification:Notification) {
        if emailTextField.isFirstResponder || passwordTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification:Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    

 
    
   
    
}
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}


