//
//  MessageHandler.swift
//  ChillZone
//
//  Created by David James on 2/26/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
class MessageHandler{
    static var viewController : ChatViewController?
    static func setUp(vc : ChatViewController){
        viewController = vc;
    }
    static func getAllMessages(){
        viewController?.messages = [];
        getMessages(since: 0, all : true)
    }
    static func getMessages(since time : Double, all : Bool){
        print(time);
        var path : String = "/Cnvs/1/Msgs?dateTime="+String(describing: time);
        if(!all){
            path+=("&num=100");
        }
        HttpHandler.request(method: "GET", path: path, body: ""){(data, response, error) in
            if(data == nil){
                print("no data")
                return;
            }
            do{
                //print("bellow my dudes")
                //print(String(describing: data));
                let decoder = JSONDecoder();
                var vals = try decoder.decode(Array<Message>.self, from : data!);
                print(vals);
                while(viewController!.messages.last != nil && vals.first != nil && vals.first!.id == viewController!.messages.last!.id){
                    print(vals.remove(at: 0));
                }
                DispatchQueue.main.async {
                    viewController!.messages.append(contentsOf: vals)
                    //print("going to scroll with \(viewController!.messages.count)")
                    viewController!.tableView.reloadData();
                    viewController!.scrollToBottom()
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func sendMessage(content : String){
        let body : String = "{\"content\" : \"\(content)\"}"
        HttpHandler.request(method: "POST", path: "/Cnvs/1/Msgs", body: body){_,_,_ in };
    }
}

