//
//  LoginViewController.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {
    private static let docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archURL = docDir.appendingPathComponent("savedLogin");
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userinfo = NSKeyedUnarchiver.unarchiveObject(withFile: LoginViewController.archURL.path) as? [String:String]{
            User.login(username: userinfo["username"], password: userinfo["password"], isGuest: false){
                self.performSegue(withIdentifier: "loginseg", sender: self);
            }
        }
        // Do any additional setup after loading the view.
    }
    static func logout(){
        do{
            try FileManager().removeItem(atPath: LoginViewController.archURL.path);
        }catch{
            print ("an error happened in logout");
        }
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
                var credentials : [String : String] = [:];
                credentials["username"] = self.usernameField.text;
                credentials["password"] = self.passwordField.text;
                NSKeyedArchiver.archiveRootObject(credentials, toFile: LoginViewController.archURL.path);
                self.performSegue(withIdentifier: "loginseg", sender: self);
            }
        }
    }
    @IBAction func guestLoginClick(_ sender: UIButton) {
        User.login(username: nil, password: nil, isGuest: true) {()->Void in
            if(User.isLoggedIn()){
                print("doing guest");
                self.performSegue(withIdentifier: "guestloginseg", sender: self);
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("doing test");
        if let _ = sender as? LoginViewController{
            return true;
        }
        if(identifier == "guestLoginSeg"){
            return true;
        }
        return false;
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
