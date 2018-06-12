//
//  User.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
class User{
    private static var admin : Bool = false;
    private static var loggedin : Bool = false;
    private static var loginTime : Double = 0;
    public static var email : String?;
    public static func login(username :String?, password: String?, isGuest : Bool, closure : @escaping () -> Void){
        if(isGuest){
            loggedin = true;
            closure();
            return;
        }
        self.email = username;
        var body : String = "{\"email\" : \"";
        body+=username!;
        body+="\", \"password\" : \""
        body+=password!;
        body+="\"}"
        let _ = HttpHandler.request(method: "POST", path: "/Ssns", body: body){(data, response, error) in
            if(data == nil){
                DispatchQueue.main.async {
                    closure();
                }
                return;
            }
            let code = (response as! HTTPURLResponse).statusCode;
            print(code);
            if(code == 200){
                admin = true;
                loginTime = Date.timeIntervalSinceReferenceDate;
                DispatchQueue.main.async {
                    closure();
                }
                return;
            }else{
                print("bad login");
                return;
            }
        }
        print(body);
        print("body above");
    }
    public static func isLoggedIn() -> Bool{
        return loggedin;
    }
    public static func isAdmin() -> Bool{
        return admin;
    }
    public static func logout(){
        admin = false;
        loggedin = false;
        email = "";
        LoginViewController.logout();
    }
    public static func checkLoginTime() -> Bool {
        return Date.timeIntervalSinceReferenceDate - loginTime < 3600; //timeout values
    }
    public static func autoLogin(){
        if let userinfo = NSKeyedUnarchiver.unarchiveObject(withFile: AutoLoginViewController.archURL.path) as? [String:String]{
            login(username: userinfo["username"], password: userinfo["password"], isGuest: false){
                print("login attempted. wasSuccess == \(!HttpHandler.noConnection)")
            }
        }
    }
}
