//
//  DepartmentStruct.swift
//  Uni
//
//  Created by David Sarkisyan on 13/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation


struct Department {
    var name: String
    var minPoints: Int
    var fullName : String
    
    var dictionary : [String : Any]{
        return [
            "name" : name,
            "minPoints": minPoints,
            "fullName": fullName,
        ]
    }
}

extension Department: DocumentSerializable{
    init?(dictionary: [String: Any]){
        guard let name = dictionary["name"] as? String,
              let minPoints = dictionary["minPoints"] as? Int,
              let fullName = dictionary["fullName"] as? String
     
               else { return nil }
        
        self.init(name: name, minPoints: minPoints,fullName : fullName)
    }
}
