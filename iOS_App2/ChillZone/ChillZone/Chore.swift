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
}
