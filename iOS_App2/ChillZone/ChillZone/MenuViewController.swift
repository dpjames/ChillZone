//
//  MenuViewController.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Comet.comet();
        
        //This means they are certainly logged in. Therfore we can save that info on device. Bad security idk maybe.
        // Do any additional setup after loading the view.
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let _ = HttpHandler.request(method: "GET", path: "/Lights", body: "") {_,_,_ in }; //just to see if connection is good again
        if(HttpHandler.noConnection){
            self.navigationItem.title = "Cannot Reach Server!!!"
        }
        return !HttpHandler.noConnection;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doLogout(_ sender: Any) {
        User.logout();
        Comet.kill();
        performSegue(withIdentifier: "logoutSeg", sender: nil);
    }
    override func viewDidAppear(_ animated: Bool) {
        if(!User.checkLoginTime()){
            User.autoLogin();
        }
        print("here I am");
        print("also this is the thing \(HttpHandler.noConnection)")
        if(HttpHandler.noConnection){
            self.navigationItem.title = "Cannot Reach Server!!!"
        } else {
            self.navigationItem.title = "Home"
            LocationHandler.update();
        }
    }
}
