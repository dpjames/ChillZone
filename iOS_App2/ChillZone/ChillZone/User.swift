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
    public static func login(username :String?, password: String?, isGuest : Bool, closure : @escaping () -> Void){
        if(isGuest){
            loggedin = true;
            closure();
            return;
        }
        //need to add login logic, once server is set up TODO
        var req : URLRequest = URLRequest(url: URL(string: IPManager.IP+"/Ssns")!);
        req.httpMethod = "POST";
        var body : String = "{\"email\" : \"";
        body+=username!;
        body+="\", \"password\" : \""
        body+=password!;
        body+="\"}"
        print(body);
        print("body above");
        req.httpBody = body.data(using: String.Encoding.utf8);
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: req) {(data, response, error) in
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
        task.resume();
    }
    public static func isLoggedIn() -> Bool{
        return loggedin;
    }
    public static func isAdmin() -> Bool{
        return admin;
    }
}
