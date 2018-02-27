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
        //var ret : [Message] = [];
        let url = URLRequest(url: URL(string : IPManager.IP+"/Cnvs/1/Msgs?dateTime="+String(time))!)
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
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
                viewController!.messages.append(contentsOf: vals)
                DispatchQueue.main.async {
                    viewController!.tableView.reloadData();
                    viewController!.scrollToBottom()
                }
            } catch {
                print(error)
            }
        }
        task.resume();
    }
    
    static func sendMessage(content : String){
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let url = URL(string: IPManager.IP+"/Cnvs/1/Msgs")
                var request = URLRequest(url: url!);
                request.httpMethod = "POST";
                let body : String = "{\"content\" : \"\(content)\"}"
                request.httpBody = body.data(using: String.Encoding.utf8)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                print(String(describing: request.httpBody!))
                let task = URLSession.shared.dataTask(with: request){(data, response, error) in
                    print(error);
                    print(response);
                    print(String(data: data!, encoding : String.Encoding.utf8));
                }
                task.resume();
            }catch{
                print(error);
            }
        }
    }
    public static func comet(){
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string : IPManager.IP+"/Comet")
            var req = URLRequest(url: url!)
            req.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: req) {(data, response, error) in
                if(data == nil){
                    comet();
                    return;
                }
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any?]
                let path = json!["path"] as! String;
                print(path);
                if(path == "/Cnvs/1/Msgs"){
                    getMessages(since: viewController!.messages[viewController!.messages.count-1].whenMade)
                }
                comet();
            }
            task.resume();
        }
    }
}
private struct messSend : Codable{
    var content : String
}

