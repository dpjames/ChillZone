//
//  LoginViewController.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginClick(_ sender: UIButton) {
        User.login(username: usernameField.text, password: passwordField.text, isGuest: false) {()->Void in
            if(User.isAdmin()){
                performSegue(withIdentifier: "loginseg", sender: self);
            }
        }
    }
    @IBAction func guestLoginClick(_ sender: UIButton) {
        User.login(username: nil, password: nil, isGuest: true) {()->Void in
            if(User.isLoggedIn()){
                performSegue(withIdentifier: "guestloginseg", sender: self);
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
