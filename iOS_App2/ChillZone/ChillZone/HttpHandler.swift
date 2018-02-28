//
//  HttpHandler.swift
//  ChillZone
//
//  Created by David James on 2/27/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
class HttpHandler {
    static func request(method : String, path : String, body : String, callback : @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask{
        let url = URL(string: IPManager.IP+path);
        var req = URLRequest(url: url!);
        req.httpMethod = method;
        req.httpBody = body.data(using: String.Encoding.utf8);
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: req, completionHandler: callback);
        task.resume()
        return task;
    }
}
