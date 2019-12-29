//
//  DataBase.swift
//  Uni
//
//  Created by David Sarkisyan on 29.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import Firebase



final class Database: UIViewController {     // ТУТ НИЧЕГО НЕ ТРОГАТЬ
    
    let university = UniversityDocument.university
    let faculty = FacultyDocument.faculty
    let department = DepartmentDocument.department
    
    override func viewDidLoad() {
        addUniversity()
        
        addFaculty()

        addDepartment()
    }

    
    func addUniversity(){
        NetworkManager.shared.db.collection("Universities").addDocument(data: [
            "name": university.name,
            "fullName": university.fullName,
            "city": university.city,
            "dormitory": university.dormitory,
            "militaryDepartment": university.militaryDepartment
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
    
    
    func addFaculty(){
        NetworkManager.shared.db.collection("Universities").whereField("name", isEqualTo: university.name).getDocuments(completion: { (querySnapshot, error) in
            for document in (querySnapshot?.documents)!{ NetworkManager.shared.db.collection("Universities").document("\(document.documentID)").collection("\(document.data()["name"]!)faculties").addDocument(data: [
                "name": self.faculty.name,
                "fullName": self.faculty.fullName
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }
                }
            }
        })
    }

    
    func addDepartment(){
        NetworkManager.shared.db.collection("Universities").whereField("name", isEqualTo: university.name).getDocuments(completion: { (querySnapshot, error) in
            for document in (querySnapshot?.documents)!{ NetworkManager.shared.db.collection("Universities").document("\(document.documentID)").collection("\(document.data()["name"]!)faculties").whereField("name", isEqualTo: self.faculty.name).getDocuments(completion: { (querySnapshot2, error2) in
                for document2 in (querySnapshot2?.documents)!{ NetworkManager.shared.db.collection("Universities").document("\(document.documentID)").collection("\(document.data()["name"]!)faculties").document("\(document2.documentID)").collection("\(document2.data()["name"]!)departments").addDocument(data: [
                    "name": self.department.name,
                    "fullName": self.department.fullName,
                    "link": self.department.link,
                    "minPoints": self.department.minPoints,
                    "subjects": self.department.subjects,
                    "followers": self.department.followers
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }
                    }
                }
            })
            }
        })
    }

}
