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
        HttpHandler.request(method: "POST", path: "/Ssns", body: body){(data, response, error) in
            if(data == nil){
                return;
            }
            let code = (response as! HTTPURLResponse).statusCode;
            print(code);
            if(code == 200){
                admin = true;
                DispatchQueue.main.async {
                    closure();
                    return;
                }
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
}
