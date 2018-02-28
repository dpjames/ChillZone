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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doLogout(_ sender: Any) {
        User.logout();
        Comet.kill();
        performSegue(withIdentifier: "logoutSeg", sender: nil);
    }
}
