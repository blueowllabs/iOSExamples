//
//  ViewController.swift
//  Touch ID Example
//
//  Created by Stephen Kyles on 7/10/15.
//  Copyright (c) 2015 Blue Owl Labs. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authenticateUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func authenticateUser() {
        // Get the local authentication context from the framework
        let context : LAContext = LAContext()
        
        // Set the string that will appear on the authentication alert
        let reasonForAsking = "Authentication is needed to access your account."
        
        // Check if the device supports Touch ID
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: NSErrorPointer()) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonForAsking, reply: {
                (success: Bool, evalPolicyError: NSError?) -> Void in
                if success {
                    // send to logged in view controller
                    self.performSegueWithIdentifier("validUser", sender: self)
                } else {
                    // In case that the error is a user fallback, then show a password alert view
                    println(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user")
                    case LAError.UserFallback.rawValue:
                        print("User selected to enter custom password")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    default:
                        print("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
            })]
        } else {
            print("Device not supported.")
            self.showPasswordAlert()
        }
    }
    
    func showPasswordAlert() {
        var passwordAlert : UIAlertView = UIAlertView(
            title: "My App",
            message: "Please type your password",
            delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "Okay")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == "password" {
                    self.performSegueWithIdentifier("validUser", sender: self)
                } else {
                    showPasswordAlert()
                }
            } else {
                showPasswordAlert()
            }
        }
    }
}





