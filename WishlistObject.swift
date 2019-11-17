//
//  WishlisObject.swift
//  Uni
//
//  Created by David Sarkisyan on 05.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import RealmSwift

class WishlistObj: Object{
    
    @objc dynamic var departmentName: String = ""
    @objc dynamic var universityName: String = ""
    @objc dynamic var minPoints: Int = 0
//    @objc dynamic var subjects: [String] = []
   convenience init(university: University ,department: Department) {
        self.init()
        self.departmentName = department.name
        self.universityName = university.name
        self.minPoints = department.minPoints
//        self.subjects = faculty.subjects
    }
}
