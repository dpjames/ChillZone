//
//  LoginViewController.swift
//  ChillZone
//
//  Created by David James on 1/28/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func login(_ sender: UIButton) {
        //ASK ABOUT THIS
        
        if(User.login(username : username.text, password : password.text)){
            performSegue(withIdentifier: "loggedIn", sender: self);
        }
    }
    
    @IBAction func help(_ sender: UIButton) {
        print("no help here");
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
