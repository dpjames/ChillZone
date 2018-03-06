//
//  AutoLoginViewController.swift
//  ChillZone
//
//  Created by David James on 3/2/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class AutoLoginViewController: UIViewController {
    private static let docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archURL = docDir.appendingPathComponent("savedLogin");
    override func viewDidLoad() {
        print("in")
        super.viewDidLoad()
        if let userinfo = NSKeyedUnarchiver.unarchiveObject(withFile: AutoLoginViewController.archURL.path) as? [String:String]{
            print("doing a log in with cred")
            User.login(username: userinfo["username"], password: userinfo["password"], isGuest: false){
                self.performSegue(withIdentifier: "autoLoginSeg", sender: self);
            }
        }else{
            print(Thread.isMainThread);
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toLoginSeg", sender: self)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
