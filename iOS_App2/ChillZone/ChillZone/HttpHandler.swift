//
//  HttpHandler.swift
//  ChillZone
//
//  Created by David James on 2/27/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
class HttpHandler {
    static var noConnection = false;
    static func request(method : String, path : String, body : String, callback : @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
        let timeout = path != "/Comet";
        print("doing web request")
        let url = URL(string: IPManager.IP+path);
        var req = URLRequest(url: url!);
        req.httpMethod = method;
        req.httpBody = body.data(using: String.Encoding.utf8);
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if(!timeout){
            req.timeoutInterval = 52560000; // about a year, because yeah
        }
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            HttpHandler.noConnection = (error != nil);
            callback(data, response, error);
        }
        task.resume()
        return task;
    }
}
