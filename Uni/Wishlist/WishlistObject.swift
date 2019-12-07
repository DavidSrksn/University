//
//  WishlisObject.swift
//  Uni
//
//  Created by David Sarkisyan on 05.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import RealmSwift

class WishlistObject: Object{
    
    @objc dynamic var departmentName: String = ""
    @objc dynamic var universityName: String = ""
    @objc dynamic var minPoints: Int = 0
    @objc dynamic var firstSubject: String = ""
    @objc dynamic var secondSubject: String = ""
    @objc dynamic var thirdSubject: String = ""
    
   convenience init(university: University ,department: Department) {
    self.init()
    self.departmentName = department.fullName
    self.universityName = university.name
    self.minPoints = department.minPoints
    self.firstSubject = department.subjects[0]
    self.secondSubject = department.subjects[1]
    self.thirdSubject = department.subjects[2]
    }
}
