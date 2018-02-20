//
//  ViewController.swift
//  ChillZone
//
//  Created by David James on 1/24/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork;
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded");
        //need to restore user here
        let ssid = getWiFiSsid();
        User.get();
        if(User.loggedIn){
            if((ssid != nil) && ssid == "Chill Zone - 5G"){
                print("on wifi, setting ipFlag");
                LightHandler.local = true;
            }
            return;
        }else if((ssid != nil) && ssid == "Chill Zone - 5G"){
            LightHandler.local = true;
            User.level = 1;
            print("On wifi, setting permissions");
        }else{
            showLoginScreen();
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func logout(_ sender: UIButton) {
        User.clear();
        showLoginScreen();
    }
    func showLoginScreen() {
        self.navigationController?.performSegue(withIdentifier: "toLogin", sender: self)
    }
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(User.level >= 10){
            return true;
        }else if(User.level < 10 ){
            return identifier == "toLights";
        }
        return false;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("errorerrorerror");
        // Dispose of any resources that can be recreated.
    }



}

