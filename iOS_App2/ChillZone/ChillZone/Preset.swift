//
//  Preset.swift
//  ChillZone
//
//  Created by David James on 1/27/18.
//  Copyright © 2018 David James. All rights reserved.
//

import Foundation
class Preset: NSObject, NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(globe, forKey: "globe");
        aCoder.encode(reading, forKey: "reading");
        aCoder.encode(ambient, forKey: "ambient");
        aCoder.encode(name, forKey: "name");
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        globe = aDecoder.decodeBool(forKey: "globe");
        reading = aDecoder.decodeBool(forKey: "reading");
        ambient = aDecoder.decodeBool(forKey: "ambient");
        name = aDecoder.decodeObject(forKey: "name") as! String;
    }
    
    var globe : Bool;
    var reading : Bool;
    var ambient: Bool;
    var name: String;
    init(name: String, globe: Bool, reading: Bool, ambient: Bool){
        self.name = name;
        self.globe = globe;
        self.reading = reading;
        self.ambient = ambient;
    }
}

