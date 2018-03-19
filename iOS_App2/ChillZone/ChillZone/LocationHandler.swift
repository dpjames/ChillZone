//
//  LocationHandler.swift
//  ChillZone
//
//  Created by David James on 3/7/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
import MapKit

class LocationHandler : NSObject, CLLocationManagerDelegate{
    private static var instance : LocationHandler?;
    private var lm : CLLocationManager;
    private var region : CLCircularRegion?;
    init(_ b : Bool){
        lm = CLLocationManager();
        super.init();
        lm.delegate = self;
        let coordinate = CLLocationCoordinate2DMake(35.2635, -120.6999);
        let radius = 100;
        region = CLCircularRegion(center: coordinate, radius: CLLocationDistance(radius), identifier: "chillZone");
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            lm.requestAlwaysAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {

            
            lm.startMonitoring(for: region!);
            
            
        }
    }
    static func update(){
        print("location is updating!")
        instance?.lm.requestLocation();
    }
    static func setup(){
        instance = LocationHandler(true);
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        updateLocation(1)
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        updateLocation(0)
    }
    func updateLocation(_ val : Int){
        if let userinfo = NSKeyedUnarchiver.unarchiveObject(withFile: AutoLoginViewController.archURL.path) as? [String:String]{
            print("doing a log in with cred")
            //print("logging in with uname \(userinfo["username"]) and \(userinfo["password"])")
            User.login(username: userinfo["username"], password: userinfo["password"], isGuest: false){
                if(HttpHandler.noConnection){
                    print("error in login location handler");
                    print("no cnn");
                    return;
                }
                self.getId(val);
            }
        }
    }
    func getId(_ val : Int){
        let _ = HttpHandler.request(method: "GET", path: "/Prss?email="+User.email!, body: ""){(data, response, error) in
            if(data == nil){
                print("undable to do response")
                return;
            }
            do{
                let person = try JSONDecoder().decode(Array<person>.self, from: data!);
                let id = person[0].id;
                self.updateHome(id, val);
            } catch {
                print(error);
            }
        }
    }
    func updateHome(_ id : Int, _ val : Int){
        var body = "{ \"isHome\" : ";
        body+="\"" + String(val) + "\"}"
        let _ = HttpHandler.request(method: "put", path: "/Prss/"+String(id), body: body){ (data, response, error) in
            let code = (response as! HTTPURLResponse).statusCode;
            if(code == 200){
                print("it worked")
            }else{
                print("it did not work")
            }
        }
    }
    //locationmanager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        print(error);
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.count);
        if let last = locations.last {
            print(region);
            print(region?.contains(last.coordinate))
            updateLocation((region?.contains(last.coordinate))! ? 1 : 0)
        }
        

    }
    
}
struct person : Codable{
    var id : Int
}
