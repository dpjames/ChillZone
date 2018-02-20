//
//  File.swift
//  ChillZone
//
//  Created by David James on 1/28/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation

class User{
    static var loggedIn = false;
    //maybe make these private and add accessor classes!!!
    static var level = 0;
    static var fname : String = "";
    static var lname : String = "";
    static var id : Int = -1;
    static var cookieIdentifier : String = "";
    static func get(){
        
    }
    static func login(username :String?, password: String?) -> Bool{
        //add more functionality, a lot more. This has to do with backend. set name and id cookie etc.
        loggedIn = (username == "David" && password == "password")
        if(loggedIn){
            User.level = 100;
        }
        return loggedIn;
    }
    static func clear(){
        level = 0;
        fname = "";
        lname = "";
        id = -1;
        cookieIdentifier = "";
    }
}
