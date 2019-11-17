//
//  Manager.swift
//  Uni
//
//  Created by David Sarkisyan on 15.10.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import Firebase
import Alamofire
import RealmSwift
import CircleMenu
import paper_onboarding
import FoldingCell

final class Manager {
    
    private init(){}

    static let shared = Manager()
    
    var UFD = [ University : [Faculty? : [Department]?]]()
    
    var choosed: [Any?] = [nil,nil,nil]
    
    let db = Firestore.firestore()
    let realm = try! Realm()
    
    var preference: String?
    
    var doc: QueryDocumentSnapshot?
    
    func internetConnectionCheck(viewcontroller: UIViewController){
        if !NetworkReachabilityManager()!.isReachable{
            viewcontroller.tabBarController?.selectedIndex = 1
            let alert = UIAlertController(title: "Alert", message: "There is no internet. You can only use your wishlist info ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            viewcontroller.present(alert, animated: true)
        }
    }
    
    func observeDepartments(occasion: String, UniversityDocument: QueryDocumentSnapshot, FacultyDocument: QueryDocumentSnapshot, minPoints: Int?, quantityLimit: Int, completion: (() -> Void)? ) {
        self.db.collection("Universities")
            .document("\(UniversityDocument.documentID)")
            .collection("\(UniversityDocument.data()["name"]!)faculties")
            .document("\(FacultyDocument.documentID)")
            .collection("\(FacultyDocument.data()["name"]!)departments")
            .whereField("minPoints", isLessThanOrEqualTo: minPoints!)
            .limit(to: quantityLimit)
            .getDocuments { (querySnapshot3, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                else{
                    if occasion == "University Loading"{
                    if !Manager.shared.UFD.keys.contains(University(dictionary: UniversityDocument.data())!){
                        Manager.shared.UFD[University(dictionary: UniversityDocument.data())!] = [:]
                    }
                    }else if occasion == "Faculty Loading"{
                        Manager.shared.UFD[University(dictionary: UniversityDocument.data())!]?[Faculty(dictionary: FacultyDocument.data())] = []
                    }else if occasion == "Department Loading"{
                        var arrayOfDepartmnets = [Department]()
                        for document3 in (querySnapshot3?.documents)! {
                            arrayOfDepartmnets.append(Department(dictionary: document3.data())!)
                        }
                         Manager.shared.UFD[University(dictionary: UniversityDocument.data())!]?[Faculty(dictionary: FacultyDocument.data())] =  arrayOfDepartmnets
                    }
                    
                    completion?()
                }
        }
    }
    
    func observeFaculties(occasion: String, universityDocument: QueryDocumentSnapshot, departmentQuantityLimit: Int, minPoints: Int?, subjects: [String]?, completion: (() -> Void)?){
        self.db.collection("Universities")
            .document("\(universityDocument.documentID)")
            .collection("\(universityDocument.data()["name"]!)faculties")
            .whereField("subjects", isEqualTo: subjects!.sorted())
            .getDocuments { (querySnapshot2, error) in
                if !Manager.shared.UFD.keys.contains(University(dictionary: universityDocument.data())!) {
                    if let error = error {
                        print("\(error.localizedDescription)")
                        // добавить комплишены
                    }
                    else{
                        for document2 in (querySnapshot2?.documents)!{
                            Manager.shared.observeDepartments(occasion: occasion, UniversityDocument: universityDocument, FacultyDocument: document2, minPoints: minPoints, quantityLimit: departmentQuantityLimit, completion: completion)
                        }
                    }
                }
        }
    }
    
//    func findDepartment(university: University, faculty: Faculty,department: Department) -> QueryDocumentSnapshot {
//        
//       }
    
    
    func findFaculty(universityName: String, facultyName: String) -> QueryDocumentSnapshot? {
         var resultDocument: QueryDocumentSnapshot?
               db.collection("Universities")
                   .whereField("name", isEqualTo: universityName)
                   .getDocuments { (querySnapshot1, error) in
                       if let error = error {
                           print("\(error.localizedDescription)")
                       } else{
                           
                    }
        }
               return resultDocument
    }
        
    
    func findUniversityDocument(nameOfUniversity: String,completion: @escaping ((QueryDocumentSnapshot?) -> Void)) {
        var resultDocument: QueryDocumentSnapshot?
        db.collection("Universities")
            .whereField("name", isEqualTo: nameOfUniversity)
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    completion(nil)
                } else{
                    resultDocument = (querySnapshot1?.documents[0])!
                    Manager.shared.doc = resultDocument
                    completion(resultDocument)
                }
          }
    }

       
    func observeUniversities(occasion: String,departmentQuantityLimit: Int, city: String?, subjects: [String]?, minPoints: Int?, dormitory: Bool?, militaryDepartment: Bool?, completion: (() -> Void)?) {
        db.collection("Universities")
            .whereField("city", isEqualTo: city!)
            .whereField("militaryDepartment", isEqualTo: militaryDepartment!)
            .whereField("dormitory", isEqualTo: dormitory!)
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                else{
                    for document1 in (querySnapshot1?.documents)!{
                        Manager.shared.observeFaculties(occasion: occasion, universityDocument: document1, departmentQuantityLimit: departmentQuantityLimit, minPoints: minPoints, subjects: subjects, completion: completion)
                    }
                }
        }
    }
    
       
    func loadUniversities(city: String?, subjects: [String]?, minPoints: Int?, dormitory: Bool?, militaryDepartment: Bool?, completion: (() -> Void)?){
        Manager.shared.observeUniversities(occasion: "University Loading", departmentQuantityLimit: 1, city: city, subjects: subjects, minPoints: minPoints, dormitory: dormitory, militaryDepartment: militaryDepartment, completion: completion)
    }
    
    
//    func loadFaculties(universityDocument: QueryDocumentSnapshot, minPoints: Int?, subjects: [String]?, completion: (() -> Void)?) {
//        Manager.shared.observeFaculties(occasion: "Faculty Loading", universityDocument: universityDocument, departmentQuantityLimit: 1, minPoints: minPoints, subjects: subjects, completion: completion)
//    }
    
    func loadFaculties(minPoints: Int?, subjects: [String]?, completion: (() -> Void)?) {
              db.collection("Universities")
                  .whereField("name", isEqualTo:(Manager.shared.choosed[0] as! University).name)
                  .getDocuments { (querySnapshot1, error) in
                  if let error = error {
                     print("\(error.localizedDescription)")
                  }
                  else{
                    for document1 in (querySnapshot1?.documents)! {
                    self.db.collection("Universities")
                        .document(document1.documentID)
                        .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                        .whereField("subjects", isEqualTo: subjects!.sorted())
                        .getDocuments { (querySnapshot2, error) in
                          if let error = error {
                             print("\(error.localizedDescription)")
                          } else {
                               for document2 in (querySnapshot2?.documents)!{
                                  self.db.collection("Universities")
                                      .document("\(document1.documentID)")
                                      .collection("\(document1.data()["name"]!)faculties")
                                      .document("\(document2.documentID)")
                                      .collection("\(document2.data()["name"]!)departments")
                                      .whereField("minPoints", isLessThanOrEqualTo: minPoints!)
                                      .limit(to: 1)
                                      .getDocuments { (querySnapshot3, error) in
                                         if let error = error {
                                          print("\(error.localizedDescription)")
                                      }
                                      else{
                                          print("Manager \(document2.data())")
                          Manager.shared.UFD[University(dictionary: document1.data())!]?[Faculty(dictionary: document2.data())] = []
                                          
                                         }
                                          completion?()

                                      }
                                  }
                              }

                         }
                    }
              }
          }
      }
    
    func loadDepartments(minPoints: Int?, completion: (() -> Void)?) {
         db.collection("Universities")
           .whereField("name", isEqualTo: (Manager.shared.choosed[0] as! University).name)
           .getDocuments { (querySnapshot1, error) in
             if let error = error {
                 print("\(error.localizedDescription)")
             }
                   else{
                     for document1 in (querySnapshot1?.documents)! {
                     self.db.collection("Universities")
                         .document(document1.documentID)
                         .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                         .whereField("name", isEqualTo: (Manager.shared.choosed[1] as! Faculty).name)
                         .getDocuments { (querySnapshot2, error) in
                           if let error = error {
                              print("\(error.localizedDescription)")
                           }
                               else{
                                 for document2 in (querySnapshot2?.documents)!{
                                    self.db.collection("Universities")
                                        .document("\(document1.documentID)")
                                        .collection("\(document1.data()["name"]!)faculties")
                                        .document("\(document2.documentID)")
                                        .collection("\(document2.data()["name"]!)departments")
                                        .whereField("minPoints", isLessThanOrEqualTo: minPoints!)
                                        .getDocuments { (querySnapshot3, error) in
                                          var arrayOfDepartmnets = [Department]()
                                          if let error = error {
                                            print("\(error.localizedDescription)")
                                        }
                                             else{
                                                for document3 in (querySnapshot3?.documents)! {
                                                arrayOfDepartmnets.append(Department(dictionary: document3.data())!)
                                            }
                                             Manager.shared.UFD[University(dictionary: document1.data())!]?[Faculty(dictionary: document2.data())] =  arrayOfDepartmnets
                                      }
                                            completion?()
                                }
                          }
                     }
                 }
            }
        }
    }
}
    
    
    func addFollower() {
        db.collection("Universities")
            .whereField("name", isEqualTo: (Manager.shared.choosed[0] as! University).name)
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                else{
                    let document1 = (querySnapshot1?.documents[0])!
                    self.db.collection("Universities")
                        .document(document1.documentID)
                        .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                        .whereField("name", isEqualTo: (Manager.shared.choosed[1] as! Faculty).name)
                        .getDocuments { (querySnapshot2, error) in
                            if let error = error {
                                print("\(error.localizedDescription)")
                            }
                            else{
                                let document2 = (querySnapshot2?.documents[0])!
                                    self.db.collection("Universities")
                                    .document(document1.documentID)
                                    .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                                    .document(document2.documentID)
                                    .collection("\((Manager.shared.choosed[1] as! Faculty).name)departments")
                                    .whereField("name", isEqualTo: (Manager.shared.choosed[2] as! Department).name)
                                    .getDocuments { (querySnapshot, error) in
                                        if let error = error {
                                            print("\(error.localizedDescription)")
                                        }else{
                                            let document = (querySnapshot?.documents[0])!
                                            print(document.data())
                                            let currentFollowers = (document.data()["followers"] as! Int) + 1
                                            self.db.collection("Universities")
                                                .document(document1.documentID)
                                                .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                                                .document(document2.documentID)
                                                .collection("\((Manager.shared.choosed[1] as! Faculty).name)departments")
                                                .document(document.documentID)
                                                .updateData(["followers": currentFollowers ]) { (error) in
                                                    if let error = error {
                                                        print("\(error.localizedDescription)")
                                                    }else{
                                                        print("Updating is completed")
                                                }
                                            }
                                        
                                }
                                }}}}}}
                        
    func removeFollower() {
        db.collection("Universities")
            .whereField("name", isEqualTo: (Manager.shared.choosed[0] as! University).name)
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                else{
                    let document1 = (querySnapshot1?.documents[0])!
                    self.db.collection("Universities")
                        .document(document1.documentID)
                        .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                        .whereField("name", isEqualTo: (Manager.shared.choosed[1] as! Faculty).name)
                        .getDocuments { (querySnapshot2, error) in
                            if let error = error {
                                print("\(error.localizedDescription)")
                            }
                            else{
                                let document2 = (querySnapshot2?.documents[0])!
                                    self.db.collection("Universities")
                                    .document(document1.documentID)
                                    .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                                    .document(document2.documentID)
                                    .collection("\((Manager.shared.choosed[1] as! Faculty).name)departments")
                                    .whereField("name", isEqualTo: (Manager.shared.choosed[2] as! Department).name)
                                    .getDocuments { (querySnapshot, error) in
                                        if let error = error {
                                            print("\(error.localizedDescription)")
                                        }else{
                                            let document = (querySnapshot?.documents[0])!
                                            print(document.data())
                                            let currentFollowers = (document.data()["followers"] as! Int) - 1
                                            self.db.collection("Universities")
                                                .document(document1.documentID)
                                                .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                                                .document(document2.documentID)
                                                .collection("\((Manager.shared.choosed[1] as! Faculty).name)departments")
                                                .document(document.documentID)
                                                .updateData(["followers": currentFollowers ]) { (error) in
                                                    if let error = error {
                                                        print("\(error.localizedDescription)")
                                                    }else{
                                                        print("Updating is completed")
                                                }
                                            }
                                        
                                }
                                }}}}}}
    
    func addToWishlist (sender: UIButton){
        let wishlistObject = WishlistObj(university: Manager.shared.choosed[0] as! University, department: Manager.shared.choosed[2] as! Department)
        print("objects = \(self.realm.objects(WishlistObj.self))")
        if !self.realm.objects(WishlistObj.self).contains(wishlistObject){
            do {
                try self.realm.write {
                    self.realm.add(wishlistObject)
                }
            } catch{
                print(error.localizedDescription)
            }}
        Manager.shared.addFollower()
        print("fileURL = \(self.realm.configuration.fileURL)")
        sender.setImage(UIImage(systemName: "star.fill")?.withTintColor(.red), for: .normal)
        
       }
    
    func deleteFromWishlist (sender: UIButton){
        let wishlistObject = WishlistObj(university: Manager.shared.choosed[0] as! University, department: Manager.shared.choosed[2] as! Department)
            do{
                try self.realm.write {
//                    self.realm.deleteAll()
                     self.realm.delete(realm.objects(WishlistObj.self).filter("departmentName = '\(wishlistObject.departmentName)'"))
                }
            }
            catch{
                print(error.localizedDescription)
            }
        Manager.shared.removeFollower()
        sender.setImage(UIImage(systemName: "star")?.withTintColor(.red), for: .normal)
    }
    
    func departmentStatus(department: Department) -> Bool {
        if Manager.shared.realm.objects(WishlistObj.self).contains(where: { (wishlistObject) -> Bool in
            return wishlistObject.departmentName == department.name
        }){
            return false
        } else{
            return true
        }
    }
    }
    
   



//             if !Manager.shared.wishlist.keys.contains(Manager.shared.choosed[0] as! University){
//                   Manager.shared.wishlist[Manager.shared.choosed[0] as! University] = [:]
//                Manager.shared.wishlist[Manager.shared.choosed[0] as! University]![Manager.shared.choosed[1] as! Faculty] = []
//                   Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]?.append(Manager.shared.choosed[2] as! Department)
//               }
//               else if  Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty] == nil{
//                Manager.shared.wishlist[Manager.shared.choosed[0] as! University]![Manager.shared.choosed[1] as! Faculty] = []
//                Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]?.append(Manager.shared.choosed[2] as! Department)
//        }
//               else {
//                Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]?.append(Manager.shared.choosed[2] as! Department)
//        }
//        if !(Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]?.contains(where: { (Department) -> Bool in
//                   return Department.name == department.name
//               }) ?? false){
//            return true
//               } else {
//                   return false
//               }


//  if Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]!.count == 1{
//            Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?.removeValue(forKey: Manager.shared.choosed[1] as! Faculty)
//        }
//        else  {
//            Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]!.removeAll(where: { (department) -> Bool in
//                return department.name == (Manager.shared.choosed[2] as? Department)?.name
//            })
//        }
