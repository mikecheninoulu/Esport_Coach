//
//  ViewController.swift
//  Esport_Coach
//
//  Created by 陈皓宇 on 05/05/2018.
//  Copyright © 2018 Haoyu Chen. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var signupModeActive = true
    
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert(title:"Error in form", message:"Please enter an username and password")
            
        } else {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signupModeActive) {
                
                print("Signing up....")
                
                let user = PFUser()
                
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error {
                        
                        self.displayAlert(title:"Could not sign you up", message:error.localizedDescription)
                        
                        // let errorString = error.userInfo["error"] as? NSString
                        // Show the errorString somewhere and let the user try again.
                        
                        print(error)
                        
                    } else {
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                })
                
            } else {
                
                PFUser.logInWithUsername(inBackground: username.text!, password: password.text!, block: { (user, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                        
                    } else {
                        
                        var errorText = "Unknown error: please try again"
                        
                        if let error = error {
                            
                            errorText = error.localizedDescription
                            
                        }
                        
                        self.displayAlert(title:"Could not sign you up", message:errorText)
                        
                    }
                    
                })
                
            }
        }
        
    }
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    
    @IBAction func switchLoginMode(_ sender: Any) {
        
        
        if (signupModeActive) {
            
            signupModeActive = false
            
            signupOrLoginButton.setTitle("Log In", for: [])
            
            switchLoginModeButton.setTitle("Sign Up", for: [])
            
        } else {
            
            signupModeActive = true
            
            signupOrLoginButton.setTitle("Sign Up", for: [])
            
            switchLoginModeButton.setTitle("Log In", for: [])
            
        }
        
        
    }
    
    
    @IBOutlet weak var switchLoginModeButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil{
            self.performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
