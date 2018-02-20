//
//  LightHandler.swift
//  ChillZone
//
//  Created by David James on 1/27/18.
//  Copyright © 2018 David James. All rights reserved.
//
import Foundation
class LightHandler {
    //static let IP : String = "http://47.32.178.27";
    //static let IP : String = "http://192.168.2.9:3000";
    static var IP : String = "http://192.168.1.21";
    static var local = false;
    private static var states : [String : Bool] = [:];
    static func setUp() -> Preset{
        print("loacl is " + String(local));
        if(local){
            print("on wifi");
            IP = "192.168.1.21"
        }else{
            print("not on wifi");
            IP = "47.32.178.27";
        }
        return Preset(name: "", globe: false, reading: true, ambient: true);
    }
    static func send(preset : Preset){
        print("triggered");
        toggle(light: "globe", state: preset.globe);
        toggle(light: "reading", state : preset.reading);
        toggle(light: "ambient", state: preset.ambient);
    }
    static func toggle(light : String, state: Bool){
        if(state != states[light]){
            send(theurl: IP+"/"+light);
        }
    }
    private static func send(theurl : String){
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: theurl)
            var request = URLRequest(url: url!);
            request.httpMethod = "POST";
            URLSession.shared.dataTask(with: request).resume();
        }
    }
}

