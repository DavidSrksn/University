//
//  File.swift
//  Uni
//
//  Created by David Sarkisyan on 26.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NetworkManager{
    
    let db = Firestore.firestore()
    
    private  init(){}
    
    static var shared = NetworkManager()
    
    let queue = DispatchQueue(label: "Not Main")
    let semaphore = DispatchSemaphore(value: 1)
    
    func loadUniversities(city: String?, subjects: [String]?, minPoints: Int?, dormitory: Bool?, militaryDepartment: Bool?, completion: ((_ currentUniversity: Int, _ allUniversitiesNumber: Int) -> Void)?){
        var checkedUniversitiesCounter: Int = 0
        Manager.shared.UFD.removeAll()
        
        db.collection("Universities")
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion?(0,0)
                }else{
                    for document1 in (querySnapshot1?.documents)!{
                        checkedUniversitiesCounter += 1
                        if ( (document1.data()["city"] as? String == city) || (city == nil) ) && ( (document1.data()["militaryDepartment"] as? Bool == militaryDepartment) || (militaryDepartment == nil) || (militaryDepartment == false)  ) && ( (document1.data()["dormitory"] as? Bool == dormitory) || (dormitory == nil) || (dormitory == false) ){
                            self.db.collection("Universities")
                                .document("\(document1.documentID)")
                                .collection("\(document1.data()["name"]!)faculties")
                                .getDocuments { (querySnapshot2, error) in
                                    if let error = error {
                                        print("\(error.localizedDescription)")
                                        completion?(0,0)
                                    }else{
                                        for document2 in (querySnapshot2?.documents)!{ // Сделать очередь на постепенные запросы к firebase (мб DispatchGroup либо очередь)
                                            self.db.collection("Universities")
                                                .document("\(document1.documentID)")
                                                .collection("\(document1.data()["name"]!)faculties")
                                                .document("\(document2.documentID)")
                                                .collection("departments")
                                                .whereField("minPoints", isGreaterThanOrEqualTo: minPoints ?? 0)
                                                .getDocuments { (querySnapshot3, error) in
                                                    if let error = error {
                                                        print("\(error.localizedDescription)")
                                                        completion?(0,0)
                                                    } else{
                                                        for document3 in (querySnapshot3?.documents)!{
                                                            if (subjects == nil) || ( (document3.data()["subjects"] as? [String])?.sorted() == subjects?.sorted()) {
                                                                Manager.shared.UFD[University(dictionary: document1.data())!] = [:]
                                                            }
                                                        }
                                                        completion?(checkedUniversitiesCounter,(querySnapshot1?.documents)!.count)
                                                    }
                                            }
                                        }
                                        completion?(checkedUniversitiesCounter,(querySnapshot1?.documents)!.count)
                                    }
                            }
                        } else{
                            completion?(checkedUniversitiesCounter,(querySnapshot1?.documents)!.count)
                        }
                    }
                }
        }
    }
        
        
    func loadFaculties(minPoints: Int?, subjects: [String]?, completion: (() -> Void)?) {
        db.collection("Universities")
            .document((Manager.shared.choosed[0] as! University).name)
            .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion?()
                }else {
                    for document1 in (querySnapshot1?.documents)!{
                        self.db.collection("Universities")
                            .document((Manager.shared.choosed[0] as! University).name)
                            .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                            .document("\(document1.documentID)")
                            .collection("departments")
                            .whereField("minPoints", isLessThanOrEqualTo: minPoints ?? 400)
//                            .order(by: "subjects")
                            .getDocuments { (querySnapshot3, error) in
                                if let error = error {
                                    print("\(error.localizedDescription)")
                                }else{
                                    for document2 in (querySnapshot3?.documents)!{
                                        if subjects != nil{
                                            if document2.data()["subjects"] as? [String] == subjects {
                                                Manager.shared.UFD[University(dictionary: document1.data())!]?[Faculty(dictionary: document1.data())] = []
                                            }
                                        }else{
                                            Manager.shared.UFD[(Manager.shared.choosed[0] as! University)]?[Faculty(dictionary: document1.data())] = []
                                        }
                                        completion?()
                                    }
                                }
                        }
                    }
                }
        }
    }
        
    func loadDepartments(subjects: [String]? ,minPoints: Int?, completion: (() -> Void)?) {
        db.collection("Universities")
            .document((Manager.shared.choosed[0] as! University).name)
            .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
            .document((Manager.shared.choosed[1] as! Faculty).fullName)
            .collection("departments")
            .whereField("minPoints", isLessThanOrEqualTo: minPoints ?? 400)
            .getDocuments { (querySnapshot, error) in
                var arrayOfDepartmnets = [Department]()
                if let error = error {
                    print("\(error.localizedDescription)")
                }else{
                    for document in (querySnapshot?.documents)! {
 
                            arrayOfDepartmnets.append(Department(dictionary: document.data())!)

                    }
                    Manager.shared.UFD[(Manager.shared.choosed[0] as! University)]?[(Manager.shared.choosed[1] as! Faculty)] =  arrayOfDepartmnets
                    completion?()
                }
        }
    }
                         
    
    
//    func followersMonitoring(departmentFullName: String, universityName: String, departmentFollowers: inout Int?, facultyFullName: String, completion: ((Int)->Void)? ){
//
//        var followersNumber: Int?
//
//        db.collection("Universities")
//            .document(universityName)
//            .collection("\(universityName)faculties")
//            .document(facultyFullName)
//            .collection("\(facultyFullName)departments")
//            .document(departmentFullName)
//
//            .getDocument { (querySnapshot, error) in
//                if let error = error{
//                    print(error.localizedDescription)
//                }else{
//                    followersNumber = querySnapshot?.data()!["followers"] as? Int
//                    completion?(followersNumber!)
//                }
//        }
//    }
    
   @objc func changeFollower(occasion: String, universityname: String,facultyFullName: String, departmentFullName: String) {  //occasion =  "add" или "remove"
        var difference: Int
        
        if occasion == "remove"{
            difference = -1
        }else{ difference = 1 }
        
        db.collection("Universities")
            .document(universityname)
            .collection("\(universityname)faculties")
            .document(facultyFullName)
            .collection("departments")
            .document(departmentFullName)
            .getDocument { (querySnapshot, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }else{
                    let currentFollowers = (querySnapshot!.data()!["followers"] as! Int)
                    self.db.collection("Universities")
                        .document(universityname)
                        .collection("\(universityname)faculties")
                        .document(facultyFullName)
                        .collection("departments")
                        .document(departmentFullName)
                        .updateData(["followers": currentFollowers + difference]) { (error) in
                            if let error = error {
                                print("\(error.localizedDescription)")
                            }else{
                                print("Updating is completed")
                            }
                    }
                    
                }
        }
    }
    
    func listenFollowers(universityName: String, facultyFullName: String, departmentFullName: String, completion: ((Int)-> Void)?){
        db.collection("Universities")
            .document(universityName)
            .collection("\(universityName)faculties")
            .document(facultyFullName)
            .collection("departments")
            .document(departmentFullName)
            .addSnapshotListener { (documentSnapshot, error) in
                if documentSnapshot?.data() != nil{
                let followers = documentSnapshot?.data()!["followers"] as! Int
                    completion?(followers)
                }
        }
    }
    
    
}
