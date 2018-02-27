//
//  Messages.swift
//  ChillZone
//
//  Created by David James on 2/26/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
struct Message : Codable {
    var id : Int;
    var whenMade : Double;
    var email : String;
    var content : String;
}
