//
//  Chore.swift
//  ChillZone
//
//  Created by David James on 3/2/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
struct Chore: Codable{
    var name : String;
    var description : String;
    var duration : Double;
    var startTime : Double;
    var isRecurring : Int;
    var owner : String;
    var id : Int;
    var notify : Int;
    init(name : String, description : String, duration : Double, isRecurring: Int, owner : String){
        self.name = name;
        self.description = description;
        self.duration = duration;
        self.isRecurring = isRecurring
        self.owner = owner;
        self.notify = 0;
        id = -1;
        startTime = -1;
    }
}
