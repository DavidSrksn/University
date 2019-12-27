//
//  WishlisObject.swift
//  Uni
//
//  Created by David Sarkisyan on 05.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmWishlistObject: Object{
    
    @objc dynamic var departmentName: String = ""
    @objc dynamic var universityName: String = ""
    @objc dynamic var minPoints: Int = 0
    var subjects = List<String?>()
    
    convenience init(university: University ,department: Department) {
        self.init()
        self.departmentName = department.fullName
        self.universityName = university.name
        self.minPoints = department.minPoints
        self.subjects = {()->List<String?> in
            let subjectsList = List<String?>()
            for subject in department.subjects{
                subjectsList.append(subject)
            }
            if (5 - department.subjects.count) != 0{
                for _ in department.subjects.count ... 5{
                    subjectsList.append(nil)
                }
            }
            return subjectsList
        }()
    }
}
