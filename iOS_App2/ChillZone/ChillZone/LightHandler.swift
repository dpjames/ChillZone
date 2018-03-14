//
//  LightHandler.swift
//  ChillZone
//
//  Created by David James on 1/27/18.
//  Copyright © 2018 David James. All rights reserved.
//
import Foundation
class LightHandler {
    static var viewController : LightsViewController?;
    static var states : [String : Bool] = [:];
    static func setUp(_ vc : LightsViewController) -> Preset{
        self.viewController = vc;
        states["ambient"] = false;
        states["globe"] = false;
        states["reading"] = false;
        return Preset(name: "", globe: false, reading: false, ambient: false);
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
            send(path : "/Lights/"+light);
        }
    }
    private static func send(path : String){
        let _ = HttpHandler.request(method: "POST", path: path, body: ""){_,_,_ in }
    }
    public static func getState(){
        DispatchQueue.global(qos: .userInitiated).async {
            let _ = HttpHandler.request(method: "GET", path: "/Lights", body: ""){(data, response, error) in
                if(data == nil){
                    return;
                }
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
        }
    }
}

