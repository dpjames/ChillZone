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
                print(String(data: data!, encoding : String.Encoding.utf8));
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
}
