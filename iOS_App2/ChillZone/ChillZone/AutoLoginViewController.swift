//
//  AutoLoginViewController.swift
//  ChillZone
//
//  Created by David James on 3/2/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit
import MapKit
class AutoLoginViewController: UIViewController {
    public static let docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    public static let archURL = docDir.appendingPathComponent("savedLogin");
    override func viewDidLoad() {
        print("in")
        super.viewDidLoad()
        if let userinfo = NSKeyedUnarchiver.unarchiveObject(withFile: AutoLoginViewController.archURL.path) as? [String:String]{
            print("doing a log in with cred")
            User.login(username: userinfo["username"], password: userinfo["password"], isGuest: false){
                print("going to check the error thing")
                if(HttpHandler.noConnection){
                    self.performSegue(withIdentifier: "toLoginSeg", sender: self)
                    return;
                }
                self.performSegue(withIdentifier: "autoLoginSeg", sender: self);
            }
        }else{
            print(Thread.isMainThread);
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toLoginSeg", sender: self)
            }
        }
    }
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
