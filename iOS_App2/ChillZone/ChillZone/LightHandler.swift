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
    //static var IP : String = "http://192.168.1.21";
    //static var local = true;
    static var viewController : LightsViewController?;
    static var states : [String : Bool] = [:];
    static func setUp(_ vc : LightsViewController) -> Preset{
        self.viewController = vc;
        /*
        print("loacl is " + String(local));
        if(local){
            print("on wifi");
            IP = "http://192.168.1.21"
        }else{
            print("not on wifi");
            IP = "47.32.178.27";
        }
         */
        return Preset(name: "", globe: false, reading: true, ambient: true);
    }
    static func send(preset : Preset){
        print("triggered");
        toggle(light: "globe", state: preset.globe);
        toggle(light: "reading", state : preset.reading);
        toggle(light: "ambient", state: preset.ambient);
        getState();
    }
    static func toggle(light : String, state: Bool){
        if(state != states[light]){
            send(theurl: IPManager.IP+"/Lights/"+light);
        }
    }
    private static func send(theurl : String){
        print(theurl);
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: theurl)
            var request = URLRequest(url: url!);
            request.httpMethod = "POST";
            URLSession.shared.dataTask(with: request).resume();
        }
    }
    public static func getState(){
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: IPManager.IP+"/Lights")
            print(IPManager.IP+"/Lights");
            var request = URLRequest(url: url!);
            request.httpMethod = "GET";
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                print(String(describing: data));
                //print(response);
                print("got response for the get thing")
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any?]
                states["ambient"] = json!["ambient"] as! Int == 1;
                states["globe"] = json!["globe"] as! Int == 1;
                states["reading"] = json!["reading"] as! Int == 1;
                print(states);
                DispatchQueue.main.async {
                    print("doing the thing")
                    print(states);
                    viewController?.updateStates(states);
                }
            }
            task.resume();
        }
    }
    public static func comet(){
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string : IPManager.IP+"/Comet")
            var req = URLRequest(url: url!)
            req.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: req) {(data, response, error) in
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any?]
                let path = json!["path"] as! String;
                print(path);
                if(path == "/Lights"){
                    getState();
                }
                comet();
            }
            task.resume();
        }
    }
}

