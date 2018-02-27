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
        getMessages(since: 0)
    }
    static func getMessages(since time : Double){
        HttpHandler.request(method: "GET", path: "/Cnvs/1/Msgs", body: ""){(data, response, error) in
            if(data == nil){
                print("no data")
                return;
            }
            do{
                print("bellow my dudes")
                print(String(describing: data));
                let decoder = JSONDecoder();
                var vals = try decoder.decode(Array<Message>.self, from : data!);
                print(vals);
                while(viewController!.messages.last != nil && vals.first != nil && vals.first!.id == viewController!.messages.last!.id){
                    print(vals.remove(at: 0));
                }
                DispatchQueue.main.async {
                    viewController!.messages.append(contentsOf: vals)
                    print("going to scroll with \(viewController!.messages.count)")
                    viewController!.tableView.reloadData();
                    viewController!.scrollToBottom()
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func sendMessage(content : String){
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: IPManager.IP+"/Cnvs/1/Msgs")
            var request = URLRequest(url: url!);
            request.httpMethod = "POST";
            let body : String = "{\"content\" : \"\(content)\"}"
            request.httpBody = body.data(using: String.Encoding.utf8)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print(String(describing: request.httpBody!))
            let task = URLSession.shared.dataTask(with: request){(data, response, error) in
                //TODO possible error checking here
            }
            task.resume();
        }
    }
}

