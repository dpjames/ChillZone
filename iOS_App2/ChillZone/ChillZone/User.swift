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
    public static func login(username :String?, password: String?, isGuest : Bool, closure : () -> Void){
        admin = true;
        //need to add login logic, once server is set up TODO
        closure();
    }
    public static func isLoggedIn() -> Bool{
        return loggedin;
    }
    public static func isAdmin() -> Bool{
        return admin;
    }
}
