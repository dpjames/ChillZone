//
//  LoginViewController.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit
import MapKit
class LoginViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    private var lm : CLLocationManager?;
    private var loadlocation : CLLocationCoordinate2D?;
    private static let docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archURL = docDir.appendingPathComponent("savedLogin");
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lm = CLLocationManager();
        lm?.delegate = self;
        lm?.requestLocation();        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location!")
        loadlocation = locations.last?.coordinate;
        //print(loadlocation)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    @IBOutlet weak var serverLabel: UILabel!
    static func logout(){
        do{
            try FileManager().removeItem(atPath: LoginViewController.archURL.path);
        }catch{
            print ("an error happened in logout");
        }
        HttpHandler.noConnection = false;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func helpClick(_ sender: UIButton) {
        let help = UIAlertController(title: "Help", message: "Login. If you dont have login credentials tap guest.", preferredStyle: .alert);
        help.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(help, animated : true, completion: nil)
    }
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginClick(_ sender: UIButton) {
        User.login(username: usernameField.text, password: passwordField.text, isGuest: false) {
            if(HttpHandler.noConnection){
                print("error in login vc");
                self.serverLabel.isHidden = false;
                return;
            }
            if(User.isAdmin()){
                var credentials : [String : String] = [:];
                credentials["username"] = self.usernameField.text;
                credentials["password"] = self.passwordField.text;
                NSKeyedArchiver.archiveRootObject(credentials, toFile: LoginViewController.archURL.path);
                self.performSegue(withIdentifier: "loginseg", sender: self);
            }
        }
    }
    private func isHome() -> Bool{
        let coordinate = CLLocationCoordinate2DMake(35.2635, -120.6999);
        let radius = 100;
        let region = CLCircularRegion(center: coordinate, radius: CLLocationDistance(radius), identifier: "chillZone");
        var ret = false;
        if let _ = loadlocation {
            ret =  region.contains(loadlocation!);
        }
        lm?.requestLocation();
        return ret;
    }
    @IBAction func guestLoginClick(_ sender: UIButton) {
        let _ = HttpHandler.request(method: "GET", path: "/Lights", body: "") { _,_,_ in } // check cnn
        if(!isHome()){
            return;
        }
        User.login(username: nil, password: nil, isGuest: true) {
            if(HttpHandler.noConnection){
                print("no Cnn");
                return;
            }
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
    override func viewDidAppear(_ animated: Bool) {
        if(HttpHandler.noConnection){
            print("no Cnn");
            serverLabel.isHidden = false;
        } else {
            serverLabel.isHidden = true;
        }
    }

}
