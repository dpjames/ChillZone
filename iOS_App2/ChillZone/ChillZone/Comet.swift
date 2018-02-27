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
    public static func comet(){
        HttpHandler.request(method: "GET", path: "/Comet", body: ""){(data,response,error) in
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
    public static func reset(){
        self.key = "";
        self.callback = {};
    }
    public static func key(key : String){
        self.key = key;
    }
    public static func callback(callback : @escaping () -> Void){
        self.callback = callback;
    }
}
