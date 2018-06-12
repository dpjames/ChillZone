//
//  Comet.swift
//  ChillZone
//
//  Created by David James on 2/27/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
class Comet {
    private static var key : String = "";
    private static var callback : () -> Void = {};
    private static var theRequest : URLSessionDataTask?;
    private static var killflag : Bool = false;
    private static var dead : Bool = true;
    public static func comet(){
        dead = false;
        theRequest = HttpHandler.request(method: "GET", path: "/Comet", body: ""){(data,response,error) in
            if(killflag || HttpHandler.noConnection){
                print("finally dead");
                killflag = false;
                dead = true;
                return;
            }
            if(data == nil){
                comet();
                return;
            }
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any?]
            let path = json!["path"] as! String;
            print(path);
            if(path == key){
                callback();
            }
            comet();
        }
    }
    public static func kill(){
        print("kill!")
        killflag = true;
        if(theRequest != nil){
            print("canceling")
            theRequest!.cancel();
        }
    }
    public static func reset(){
        self.key = "";
        self.callback = {};
    }
    public static func key(key : String){
        self.key = key;
    }
    public static func callback(callback : @escaping () -> Void){
        self.callback = callback;
        if(dead){
            comet();
        }
    }
}
