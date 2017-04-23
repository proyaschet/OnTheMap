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
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activityIndicator.isHidden = true
        initialState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func Login(_ sender: Any) {
        startActivityIndicator()
        
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!
        {
            
            debugLabel.text = Errors.UserPassEmpty
            self.errorState()
        }
        else
        {
            udacityClient.login(emailTextField.text!, password: passwordTextField.text!, completionHandler: { (userKey, error
                ) in self.performUIUpdatesOnMain {
                    guard let userKey = userKey else
                    {
                        self.debugLabel.text = "User not found"
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
        if let signUpURL = URL(string: UdacityClient.SignUp.SignUpURL),UIApplication.shared.canOpenURL(signUpURL)
        {
            UIApplication.shared.open(signUpURL, completionHandler: nil)
        }
    }
    
    func getStudent(_ userKey : String)
    {
        udacityClient.getStudentDetails(userKey) { (student, error) in self.performUIUpdatesOnMain {
         guard let student = student else
         {
            self.debugLabel.text = "Student not found"
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
        
        debugLabel.text = ""
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
 
    
   
    
}

