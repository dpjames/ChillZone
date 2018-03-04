//
//  ChoreHandler.swift
//  ChillZone
//
//  Created by David James on 3/2/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
class ChoreHandler {
    static var vc : PeopleDetailViewController?
    static func setup(view : PeopleDetailViewController){
        ChoreHandler.vc = view;
    }
    static func getChores(for p : String){
        let _ = HttpHandler.request(method: "GET", path: "/Chores/", body: ""){(data, response, error) in
            if(data == nil){
                return;
            }
            do{
                //print(String(data: data!, encoding : String.Encoding.utf8));
                var choreList = try JSONDecoder().decode(Array<Chore>.self, from: data!)
                choreList = choreList.filter{ (element) in
                    return(element.owner.caseInsensitiveCompare(p) == ComparisonResult.orderedSame)
                }
                DispatchQueue.main.async {
                    ChoreHandler.vc!.chores = choreList;
                    ChoreHandler.vc!.table.reloadData();
                }
                //self.chores = choreList;
                
            }catch{
                print("an error occured checkt he json in people detail controller")
                print(error);
            }
        }
    }
    static func push(chore c : Chore, to user : String){
        let body = "{ \"owner\" : \"" + user + "\"}";
        let _ =  HttpHandler.request(method: "PUT", path: "/Chores/chown"+String(c.id), body: body) { (data, response, error) in
            let code = (response as! HTTPURLResponse).statusCode;
            if(code == 200){
                print("it does work")
            }else{
                print("it does not work")
            }
        }
    }
    static func add(chore c : Chore){
        var body = "{";
        body+="\"name\" : \"" + c.name + "\","
        body+="\"duration\" : \"" + String(c.duration) + "\","
        body+="\"description\" : \"" + c.description + "\","
        body+="\"isRecurring\" : \"" + String(c.isRecurring) + "\""
        body+="}"
        let _ = HttpHandler.request(method: "POST", path: "/Chores/"+c.owner, body: body) { (data, response, error) in
            print("I am inside")
            print(String(data: data!, encoding : String.Encoding.utf8));
            print(response);
            print(error);
            let code = (response as! HTTPURLResponse).statusCode;

            if(code == 200){
                print("it worked")
                getChores(for: c.owner);
            }else{
                print("it did not work")
            }
        }
    }
    static func remove(chore id : Int){
        let _ = HttpHandler.request(method: "DELETE", path: "/Chores/"+String(id), body: ""){ (data, response, error) in
            let code = (response as! HTTPURLResponse).statusCode;
            if(code == 200){
                print("it worked")
            }else{
                print("it did not work")
            }
        }
    }
}





